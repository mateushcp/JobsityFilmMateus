//
//  TVMazeService.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
}

protocol TVMazeServiceProtocol {
    func fetchShows(page: Int, completion: @escaping (Result<[Show], Error>) -> Void)
    func searchShows(query: String, completion: @escaping (Result<[Show], Error>) -> Void)
    func fetchShowDetail(withId id: Int,
                         completion: @escaping (Result<(Show, [Episode]), Error>) -> Void)
}

final class TVMazeService: TVMazeServiceProtocol {
    private let baseURL: URL
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(baseURL: URL = URL(string: "https://api.tvmaze.com")!) {
        self.baseURL = baseURL
    }

    func fetchShows(page: Int, completion: @escaping (Result<[Show], Error>) -> Void) {
        guard
            let comps = URLComponents(url: baseURL.appendingPathComponent("shows"),
                                      resolvingAgainstBaseURL: false)
        else {
            return completion(.failure(NetworkError.invalidURL))
        }
        let compsWithQuery = comps.adding(queryItem: URLQueryItem(name: "page", value: "\(page)"))
        guard let url = compsWithQuery.url else {
            return completion(.failure(NetworkError.invalidURL))
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                return completion(.failure(NetworkError.invalidResponse(statusCode: http.statusCode)))
            }
            guard let data = data else {
                return completion(.failure(NetworkError.noData))
            }
            do {
                let shows = try self.decoder.decode([Show].self, from: data)
                completion(.success(shows))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }

    func searchShows(query: String,
                     completion: @escaping (Result<[Show], Error>) -> Void) {
        guard
            let comps = URLComponents(url: baseURL.appendingPathComponent("search/shows"),
                                      resolvingAgainstBaseURL: false)
        else {
            return completion(.failure(NetworkError.invalidURL))
        }
        let compsWithQuery = comps.adding(queryItem: URLQueryItem(name: "q", value: query))
        guard let url = compsWithQuery.url else {
            return completion(.failure(NetworkError.invalidURL))
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode),
                  let data = data
            else {
                let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                return completion(.failure(NetworkError.invalidResponse(statusCode: code)))
            }
            do {
                struct SearchResult: Decodable { let show: Show }
                let wrapper = try self.decoder.decode([SearchResult].self, from: data)
                completion(.success(wrapper.map { $0.show }))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }

    func fetchShowDetail(withId id: Int,
                         completion: @escaping (Result<(Show, [Episode]), Error>) -> Void) {
        guard
            let comps = URLComponents(url: baseURL.appendingPathComponent("shows/\(id)"),
                                      resolvingAgainstBaseURL: false)
        else {
            return completion(.failure(NetworkError.invalidURL))
        }
        let compsWithQuery = comps.adding(queryItem: URLQueryItem(name: "embed[]", value: "episodes"))
        guard let url = compsWithQuery.url else {
            return completion(.failure(NetworkError.invalidURL))
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode),
                  let data = data
            else {
                let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                return completion(.failure(NetworkError.invalidResponse(statusCode: code)))
            }
            do {
                struct ShowDetailResponse: Decodable {
                    let id: Int
                    let name: String
                    let image: Show.ImageURLs?
                    let schedule: Show.Schedule
                    let genres: [String]
                    let summary: String?
                    let embedded: Embedded

                    enum CodingKeys: String, CodingKey {
                        case id, name, image, schedule, genres, summary
                        case embedded = "_embedded"
                    }
                    struct Embedded: Decodable { let episodes: [Episode] }
                }
                let detail = try self.decoder.decode(ShowDetailResponse.self, from: data)
                let show = Show(
                    id: detail.id,
                    name: detail.name,
                    image: detail.image,
                    schedule: detail.schedule,
                    genres: detail.genres,
                    summary: detail.summary
                )
                completion(.success((show, detail.embedded.episodes)))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

private extension URLComponents {
    func adding(queryItem item: URLQueryItem) -> URLComponents {
        var copy = self
        copy.queryItems = (copy.queryItems ?? []) + [item]
        return copy
    }
}

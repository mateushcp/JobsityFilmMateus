//
//  ShowListViewModel.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import Foundation

protocol ShowListViewModelDelegate: AnyObject {
    func didUpdateShows()
    func didFail(with error: Error)
}

final class ShowListViewModel {
    let service: TVMazeServiceProtocol
    var shows: [Show] = []
    private var currentPage = 0
    private var isLoading = false
    private var isSearching = false

    weak var delegate: ShowListViewModelDelegate?

    init(service: TVMazeServiceProtocol) {
        self.service = service
    }

    func loadNextPage() {
        guard !isLoading && !isSearching else { return }
        isLoading = true
        service.fetchShows(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let list):
                    self?.shows += list
                    self?.currentPage += 1
                    self?.delegate?.didUpdateShows()
                case .failure(let e):
                    self?.delegate?.didFail(with: e)
                }
            }
        }
    }

    func search(_ query: String) {
        guard !query.isEmpty else {
            isSearching = false
            shows.removeAll()
            delegate?.didUpdateShows()
            loadNextPage()
            return
        }
        isSearching = true
        service.searchShows(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.shows = list
                    self?.delegate?.didUpdateShows()
                case .failure(let error):
                    self?.delegate?.didFail(with: error)
                }
            }
        }
    }

    func show(at index: Int) -> Show {
        shows[index]
    }
}

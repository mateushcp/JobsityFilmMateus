//
//  ShowDetailViewModel.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import Foundation

protocol ShowDetailViewModelDelegate: AnyObject {
    func didLoadDetail()
    func didFail(with error: Error)
}

final class ShowDetailViewModel {
    let service: TVMazeServiceProtocol
    let showId: Int
    
    private(set) var show: Show?
    private(set) var episodesBySeason: [(season: Int, episodes: [Episode])] = []
    
    weak var delegate: ShowDetailViewModelDelegate?
    
    init(showId: Int, service: TVMazeServiceProtocol) {
        self.showId = showId
        self.service = service
    }
    
    func loadDetail() {
        service.fetchShowDetail(withId: showId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (show, episodes)):
                    self?.show = show
                    let grouped = Dictionary(grouping: episodes) { $0.season }
                    self?.episodesBySeason = grouped
                        .map { (season: $0.key, episodes: $0.value) }
                        .sorted { $0.season < $1.season }
                    self?.delegate?.didLoadDetail()
                case .failure(let error):
                    self?.delegate?.didFail(with: error)
                }
            }
        }
    }
}

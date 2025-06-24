//
//  FavoritesViewModel.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import Foundation

protocol FavoritesViewModelDelegate: AnyObject {
    func favoritesDidUpdate(_ viewModel: FavoritesViewModel)
}

final class FavoritesViewModel {
    private(set) var favorites: [Show] = []
    weak var delegate: FavoritesViewModelDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadFavorites),
                                               name: .favoritesChanged,
                                               object: nil)
        loadFavorites()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loadFavorites() {
        favorites = FavoritesManager.shared.favorites
        delegate?.favoritesDidUpdate(self)
    }
    
    func remove(at index: Int) {
        guard favorites.indices.contains(index) else { return }
        let show = favorites[index]
        FavoritesManager.shared.remove(show)
    }
}

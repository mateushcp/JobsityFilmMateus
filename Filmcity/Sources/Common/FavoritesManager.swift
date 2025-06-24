//
//  FavoritesManager.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 24/06/25.
//

import Foundation

final class FavoritesManager {
  static let shared = FavoritesManager()
  private let repo: FavoritesRepository = UserDefaultsFavoritesRepository()
  private(set) var favorites: [Show]

  private init() {
    self.favorites = repo.load()
  }

  func isFavorite(_ show: Show) -> Bool {
    favorites.contains(show)
  }

  func add(_ show: Show) {
    guard !isFavorite(show) else { return }
    favorites.append(show)
    repo.save(favorites)
    NotificationCenter.default.post(name: .favoritesChanged, object: nil)
  }

  func remove(_ show: Show) {
    guard let idx = favorites.firstIndex(of: show) else { return }
    favorites.remove(at: idx)
    repo.save(favorites)
    NotificationCenter.default.post(name: .favoritesChanged, object: nil)
  }
}

extension Notification.Name {
  static let favoritesChanged = Notification.Name("FavoritesManager.favoritesChanged")
}

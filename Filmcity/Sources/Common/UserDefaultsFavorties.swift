//
//  UserDefaultsFavorties.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 24/06/25.
//

import Foundation

protocol FavoritesRepository {
  func load() -> [Show]
  func save(_ shows: [Show])
}

final class UserDefaultsFavoritesRepository: FavoritesRepository {
  private let key = "com.filmcity.favorites"

  func load() -> [Show] {
    guard
      let data = UserDefaults.standard.data(forKey: key),
      let shows = try? JSONDecoder().decode([Show].self, from: data)
    else {
      return []
    }
    return shows
  }

  func save(_ shows: [Show]) {
    guard let data = try? JSONEncoder().encode(shows) else { return }
    UserDefaults.standard.set(data, forKey: key)
  }
}

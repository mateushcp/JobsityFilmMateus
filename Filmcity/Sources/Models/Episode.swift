//
//  Episode.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let summary: String?
    let image: Show.ImageURLs?
}

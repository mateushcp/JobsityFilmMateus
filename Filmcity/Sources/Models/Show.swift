//
//  Show.swift
//  Filmcity
//
//  Created by Mateus Henrique Coelho de Paulo on 19/06/25.
//

import Foundation

struct Show: Codable, Hashable {
    let id: Int
    let name: String
    let image: ImageURLs?
    let schedule: Schedule
    let genres: [String]
    let summary: String?

    struct ImageURLs: Codable, Hashable {
        let medium: String?
        let original: String?
    }

    struct Schedule: Codable, Hashable {
        let time: String
        let days: [String]
    }
}

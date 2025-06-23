//
//  Store.swift
//  NUSNomNom
//
//  Created by Nutabi on 16/6/25.
//

struct Store: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let is_open: Bool
    let cuisine: String
    let information: String
    let items: [Item]
}

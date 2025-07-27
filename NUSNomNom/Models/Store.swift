//
//  Store.swift
//  NUSNomNom
//
//  Created by Nutabi on 16/6/25.
//

import Foundation

struct Store: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var isOpen: Bool
    var cuisine: String
    var information: String
    var imageUrl: URL
    var items: [Item]
}

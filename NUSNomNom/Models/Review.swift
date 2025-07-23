//
//  Review.swift
//  NUSNomNom
//
//  Created by Nutabi on 23/7/25.
//

import Foundation

struct Review: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var is_open: Bool
    var cuisine: String
    var information: String
    var image_url: URL
    var items: [Item]
}

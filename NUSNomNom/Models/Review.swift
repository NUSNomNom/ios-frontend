//
//  Review.swift
//  NUSNomNom
//
//  Created by Nutabi on 23/7/25.
//

import Foundation

struct Review: Identifiable, Codable, Hashable {
    var id: Int
    var nomerId: Int
    var storeId: Int
    var score: Int
    var comment: String
    var createdAt: Date
}

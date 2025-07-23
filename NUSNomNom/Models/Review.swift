//
//  Review.swift
//  NUSNomNom
//
//  Created by Nutabi on 23/7/25.
//

import Foundation

struct Review: Identifiable, Codable, Hashable {
    var id: Int
    var nomer_id: Int
    var store_id: Int
    var score: Int
    var comment: String
    var created_at: Date
}

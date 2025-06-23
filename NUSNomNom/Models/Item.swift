//
//  Item.swift
//  NUSNomNom
//
//  Created by Nutabi on 16/6/25.
//

import Foundation

struct Item: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    @StringToDecimal var price: Decimal
    var is_available: Bool
    var information: String
}

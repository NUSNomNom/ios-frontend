//
//  StringToDecimal.swift
//  NUSNomNom
//
//  Created by Nutabi on 21/6/25.
//

import Foundation

@propertyWrapper
struct StringToDecimal: Codable, Hashable {
    var wrappedValue: Decimal
    
    init(wrapperValue: Decimal) {
        self.wrappedValue = wrapperValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decimalValue = try? container.decode(Decimal.self) {
            self.wrappedValue = decimalValue
        } else if let stringValue = try? container.decode(String.self),
                  let decimalValue = Decimal(string: stringValue) {
            self.wrappedValue = decimalValue
        } else {
            throw DecodingError.typeMismatch(
                Decimal.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected Decimal or String convertible to Decimal"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}

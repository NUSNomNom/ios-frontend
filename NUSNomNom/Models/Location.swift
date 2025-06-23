//
//  StoreLocationModel.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 9/6/25.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    @StringToDecimal var latitude: Decimal
    @StringToDecimal var longitude: Decimal
    var stores: [Store]
    
    func asCoord() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    }
}

//
//  NUSLocation.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 15/6/25.
//

import Foundation
import CoreLocation

struct NUSLocation: Identifiable, Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}



//
//  StoreLocationModel.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 9/6/25.
//

import SwiftUI
import MapKit

struct StoreLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


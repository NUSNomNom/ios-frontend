//
//  NavigationView.swift
//  NUSNomNom
//
//  Created by Nutabi on 21/6/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var selectedLocation: Location?
    
    @State private var mapPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: 1.2991160394750842,
                longitude: 103.77324456865944
            ),
            distance: 5000
        )
    )

    
    var body: some View {
        NavigationStack {
            Map(position: $mapPosition, selection: $selectedLocation) {
                UserAnnotation()
                
                ForEach(dataManager.locations) { location in
                    Marker(
                        location.name,
                        coordinate: location.asCoord(),
                    ).tag(location)
                }
            }
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .navigationDestination(item: $selectedLocation) { location in
                DetailedLocationView(location: location)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

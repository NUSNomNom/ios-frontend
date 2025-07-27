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
            mapContent
                .navigationDestination(item: $selectedLocation) { location in
                    DetailedLocationView(location: location)
                }
                .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private var mapContent: some View {
        Map(position: $mapPosition, selection: $selectedLocation) {
            // Show user location annotation
            if let userLocation = locationManager.currentLocation {
                Annotation("Your Location", coordinate: userLocation.coordinate) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            
            ForEach(dataManager.locations) { location in
                Marker(
                    location.name,
                    coordinate: location.asCoord()
                ).tag(location)
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
            MapUserLocationButton()
        }
        .onAppear {
            // Center map on user location if available
            if let userLocation = locationManager.currentLocation {
                withAnimation(.easeInOut(duration: 1.0)) {
                    mapPosition = .camera(
                        MapCamera(
                            centerCoordinate: userLocation.coordinate,
                            distance: 2000
                        )
                    )
                }
            }
        }
        .onChange(of: locationManager.currentLocation) { oldLocation, newLocation in
            // Update map position when user location changes (first time)
            if oldLocation == nil, let newLocation = newLocation {
                withAnimation(.easeInOut(duration: 1.0)) {
                    mapPosition = .camera(
                        MapCamera(
                            centerCoordinate: newLocation.coordinate,
                            distance: 2000
                        )
                    )
                }
            }
        }
    }
}

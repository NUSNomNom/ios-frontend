//
//  NavigationView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI
import MapKit

struct NavigationView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 1.2966, longitude: 103.7764),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: nusLocations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.orange)
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                        Text(location.name)
                            .font(.caption)
                            .padding(2)
                            .background(Color.white)
                            .cornerRadius(4)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .onReceive(locationManager.$userLocation) { newLocation in
                if let loc = newLocation {
                    region.center = loc
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Button(action: {
                            zoom(factor: 0.5)
                        }) {
                            Image(systemName: "plus.magnifyingglass")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }

                        Button(action: {
                            zoom(factor: 2.0)
                        }) {
                            Image(systemName: "minus.magnifyingglass")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("NUS Food Map")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func zoom(factor: Double) {
        region.span.latitudeDelta *= factor
        region.span.longitudeDelta *= factor
    }
}


#Preview {
    NavigationView()
}

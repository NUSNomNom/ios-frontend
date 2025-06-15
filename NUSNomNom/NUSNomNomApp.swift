//
//  NUSNomNomApp.swift
//  NUSNomNom
//
//  Created by Nutabi on 5/5/25.
//

import SwiftUI

@main
struct NusNomNomApp: App {
    var body: some Scene {
        WindowGroup {
            let locationViewModel = LocationViewModel()
            MainView(locationViewModel: locationViewModel)
                .onAppear {
                    locationViewModel.fetchLocations()
                }
        }
    }
}




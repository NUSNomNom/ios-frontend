//
//  NUSNomNomApp.swift
//  NUSNomNom
//
//  Created by Nutabi on 5/5/25.
//

import SwiftUI

@main
struct NusNomNomApp: App {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authManager)
                .environmentObject(dataManager)
                .environmentObject(locationManager)
        }
    }
}

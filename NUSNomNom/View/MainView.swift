//
//  MainView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        TabView {
            LocationView()
                .tabItem {
                    Label("Locations", systemImage: "list.bullet")
                }
                .environmentObject(dataManager)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .environmentObject(dataManager)
                .environmentObject(locationManager)
            
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .environmentObject(authManager)
                .environmentObject(dataManager)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthManager.shared)
        .environmentObject(DataManager.shared)
        .environmentObject(LocationManager.shared)
}

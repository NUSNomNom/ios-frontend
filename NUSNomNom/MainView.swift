//
//  MainView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct MainView: View {
    let locationViewModel: LocationViewModel  // now passed in

    var body: some View {
        TabView {
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            ReviewsView()
                .tabItem {
                    Label("Reviews", systemImage: "text.bubble")
                }
            
            NavigationView(locationViewModel: locationViewModel) // pass down
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}




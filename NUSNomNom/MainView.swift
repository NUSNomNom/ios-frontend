//
//  MainView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct MainView: View {
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

            NavigationView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            SettingView()
                .tabItem{
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    MainView()
}

//
//  LocationView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 25/6/25.
//

import SwiftUI

struct LocationView: View {
    @EnvironmentObject private var data: DataManager
    @State private var searchText: String = ""
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private var filteredLocations: [Location] {
        if searchText.isEmpty {
            return data.locations
        } else {
            return data.locations.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                NUSLogoHeader()
                
                SearchBar(
                    searchText: $searchText,
                    placeholder: "Search locations..."
                )
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredLocations) { location in
                        NavigationLink {
                            DetailedLocationView(location: location)
                        } label: {
                            LocationCard(location: location)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
    }
}

#Preview {
    LocationView()
        .environmentObject(DataManager.shared)
}


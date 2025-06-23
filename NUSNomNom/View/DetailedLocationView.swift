//
//  DetailedLocationView.swift
//  NUSNomNom
//
//  Created by Nutabi on 21/6/25.
//

import SwiftUI
import MapKit

struct DetailedLocationView: View {
    let location: Location
    @EnvironmentObject private var data: DataManager
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .clipped()

        List {
            Section(header: Text("Stores")) {
                ForEach(location.stores) { store in
                    NavigationLink(store.name) {
                        DetailedStoreView(store: store)
                    }
                }
            }
        }
        .navigationTitle(location.name)
    }
}

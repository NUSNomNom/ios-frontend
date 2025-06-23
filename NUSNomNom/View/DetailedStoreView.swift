//
//  DetailedStoreView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct DetailedStoreView: View {
    let store: Store
    @EnvironmentObject private var data: DataManager
    
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .clipped()
        
        List {
            Section(header: Text("Details")) {
                VStack(alignment: .leading, spacing: 12) {
                    (
                        Text("Information: ")
                            .foregroundStyle(.gray)
                        + Text(store.information)
                    )
                    .font(.body)
                    
                    (
                        Text("Cuisine: ")
                            .foregroundStyle(.gray)
                        + Text(store.cuisine)
                    )
                    .font(.body)
                    
                    (
                        Text("Status: ")
                            .foregroundColor(.gray)
                        + Text(store.is_open ? "Open" : "Closed")
                            .foregroundStyle(store.is_open ? .green : .red)
                    )
                    .font(.body)
                }
            }
            
            Section(header: Text("Items")) {
                ForEach(store.items) { item in
                    NavigationLink(item.name) {
                        DetailedItemView(item: item)
                    }
                }
            }
        }
        .navigationTitle(store.name)
    }
}

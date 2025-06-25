//
//  SearchView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 25/6/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var data: DataManager
    @State private var searchText: String = ""
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private var filteredStores: [(store: Store, locationName: String)] {
        if searchText.isEmpty {
            return data.locations.flatMap { location in
                location.stores.map { (store: $0, locationName: location.name) }
            }
        } else {
            return data.locations.flatMap { location in
                location.stores
                    .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                    .map { (store: $0, locationName: location.name) }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("nusNomNomLongLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 25)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search stores...", text: $searchText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredStores, id: \.store.id) { pair in
                        NavigationLink {
                            DetailedStoreView(store: pair.store)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .cornerRadius(12)

                                Text(pair.store.name)
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .lineLimit(1)

                                Text(pair.locationName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(radius: 4)
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
    SearchView()
        .environmentObject(DataManager.shared)
}

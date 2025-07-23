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
    @State private var isShowingFilterSheet = false
    @State private var selectedCuisines: Set<String> = []
    @State private var showOnlyOpenStores = false

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private var allCuisines: [String] {
        Set(data.locations.flatMap { $0.stores.map { $0.cuisine } }).sorted()
    }

    private var filteredStores: [(store: Store, locationName: String)] {
        data.locations.flatMap { location in
            location.stores
                .filter { store in
                    let matchesSearch = searchText.isEmpty || store.name.localizedCaseInsensitiveContains(searchText)
                    let matchesCuisine = selectedCuisines.isEmpty || selectedCuisines.contains(store.cuisine)
                    let matchesOpen = !showOnlyOpenStores || store.isOpen
                    return matchesSearch && matchesCuisine && matchesOpen
                }
                .map { (store: $0, locationName: location.name) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Image("nusNomNomLongLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 25)

                HStack(spacing: 12) {
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

                    Button(action: {
                        isShowingFilterSheet = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredStores, id: \.store.id) { pair in
                        NavigationLink {
                            DetailedStoreView(store: pair.store)
                        } label: {
                            storeCard(for: pair)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingFilterSheet) {
                FilterSheetView(
                    allCuisines: allCuisines,
                    selectedCuisines: $selectedCuisines,
                    showOnlyOpenStores: $showOnlyOpenStores
                ) {
                    isShowingFilterSheet = false
                }
            }
        }
    }

    @ViewBuilder
    private func storeCard(for pair: (store: Store, locationName: String)) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteImage(image_url: pair.store.imageUrl)
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

#Preview {
    SearchView()
        .environmentObject(DataManager.shared)
}

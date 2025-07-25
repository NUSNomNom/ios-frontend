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
                NUSLogoHeader()

                SearchBar(
                    searchText: $searchText,
                    placeholder: "Search stores...",
                    showFilterButton: true,
                    onFilterTap: {
                        isShowingFilterSheet = true
                    }
                )
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredStores, id: \.store.id) { pair in
                        NavigationLink {
                            DetailedStoreView(store: pair.store)
                        } label: {
                            StoreCard(store: pair.store, locationName: pair.locationName)
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
}

#Preview {
    SearchView()
        .environmentObject(DataManager.shared)
}

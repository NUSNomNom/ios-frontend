//
//  DetailedStoreView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct DetailedStoreView: View {
    let store: Store
    @EnvironmentObject private var data: AuthManager
    
    @State private var selectedTab: Tab = .details
    
    enum Tab: String, CaseIterable, Identifiable {
        case details = "Details"
        case items = "Items"
        case reviews = "Reviews"
        var id: String { rawValue }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                
                tabSection
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            NUSLogoHeader()
            
            PageTitle(title: store.name)
            
            RemoteImage(image_url: store.imageUrl)
                .scaledToFill()
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
        }
    }
    
    private var tabSection: some View {
        VStack {
            tabPicker
            
            selectedTabContent
        }
        .padding(.bottom)
    }
    
    private var tabPicker: some View {
        Picker("Select Tab", selection: $selectedTab) {
            ForEach(Tab.allCases) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var selectedTabContent: some View {
        Group {
            switch selectedTab {
            case .details:
                detailsTabContent
            case .items:
                itemsTabContent
            case .reviews:
                StoreReviewsView(store: store)
            }
        }
    }
    
    private var detailsTabContent: some View {
        VStack(spacing: 10) {
            storeInfoRow(title: "Information:", value: store.information)
            storeInfoRow(title: "Cuisine:", value: store.cuisine)
            storeStatusRow()
        }
        .padding()
    }
    
    private func storeInfoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionTitle(title: title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func storeStatusRow() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionTitle(title: "Status:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(store.isOpen ? "Open" : "Closed")
                .foregroundColor(store.isOpen ? .green : .red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var itemsTabContent: some View {
        VStack(spacing: 12) {
            ForEach(store.items) { item in
                NavigationLink {
                    DetailedItemView(item: item)
                } label: {
                    ItemCard(item: item)
                }
            }
        }
    }
}

#Preview {
    let mockItem = Item(
        id: 1,
        name: "Fried Rice",
        price: .init(wrapperValue: Decimal(string: "5.00") ?? 0),
        isAvailable: true,
        information: "Classic egg fried rice with vegetables.",
        imageUrl: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/item_chinese_1.jpeg")!
    )

    let mockStore = Store(
        id: 1,
        name: "Golden Wok",
        isOpen: true,
        cuisine: "Chinese",
        information: "Wok-fried Chinese specialties",
        imageUrl: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/store_chinese.jpeg")!,
        items: [mockItem]
    )

    NavigationStack {
        DetailedStoreView(store: mockStore)
    }
    .environmentObject(AuthManager.shared)
}

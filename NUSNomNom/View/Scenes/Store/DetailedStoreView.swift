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
                Image("nusNomNomLongLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 25)
                
                Text(store.name)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.nusBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 26)
                
                RemoteImage(image_url: store.imageUrl)
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipped()
                
                VStack {
                    Picker("Select Tab", selection: $selectedTab) {
                        ForEach(Tab.allCases) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    switch selectedTab {
                    case .details:
                        VStack(spacing: 10) {
                            Text("Information:")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.nusBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(store.information)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Cuisine:")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.nusBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(store.cuisine)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Status:")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.nusBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(store.isOpen ? "Open" : "Closed")
                                .foregroundColor(store.isOpen ? .green : .red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding()
                    case .items:
                        VStack(spacing: 12) {
                            ForEach(store.items) { item in
                                NavigationLink {
                                    DetailedItemView(item: item)
                                } label: {
                                    HStack {
                                        RemoteImage(image_url: item.imageUrl)
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .padding(10)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
                                            Text(item.information)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                            
                                            Text(item.isAvailable ? "Available" : "Sold Out")
                                                .font(.caption)
                                                .foregroundColor(item.isAvailable ? .green : .red)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    case .reviews:
                        StoreReviewsView(store: store)
                    }
                }
                .padding(.bottom)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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

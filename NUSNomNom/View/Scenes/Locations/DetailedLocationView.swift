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
    @State private var selectedTab: Tab = .stores
    
    @State private var directionSteps: [String] = []

    enum Tab: String, CaseIterable, Identifiable {
        case stores = "Stores"
        case directions = "Directions"
        var id: String { rawValue }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                NUSLogoHeader()

                PageTitle(title: location.name)
                .padding(.horizontal)

                RemoteImage(image_url: location.imageUrl)
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipped()

                Picker("Select Tab", selection: $selectedTab) {
                    ForEach(Tab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                switch selectedTab {
                case .stores:
                    SectionTitle(title: "Stores")
                        .padding(.horizontal)
                        .padding(.leading)

                    ForEach(location.stores) { store in
                        NavigationLink {
                            DetailedStoreView(store: store)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(store.name)
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    Text(store.cuisine)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Text(store.isOpen ? "Open" : "Closed")
                                        .font(.caption)
                                        .foregroundColor(store.isOpen ? .green : .red)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                case .directions:
                    SectionTitle(title: "Directions")
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RouteMapView(destination: location.asCoord()) { steps in
                        self.directionSteps = steps
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    if !directionSteps.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Steps")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(directionSteps, id: \.self) { step in
                                Text("• \(step)")
                                    .font(.subheadline)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let mockStore = Store(
        id: 1,
        name: "Golden Wok",
        isOpen: true,
        cuisine: "Chinese",
        information: "Authentic stir-fried dishes",
        imageUrl: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/store_chinese.jpeg")!,
        items: []
    )

    let mockLocation = Location(
        id: 101,
        name: "Fine Food @ UTown",
        latitude: .init(wrapperValue: Decimal(string: "1.3041") ?? 0),
        longitude: .init(wrapperValue: Decimal(string: "103.7721") ?? 0),
        imageUrl: URL(string: "https://nomnom-image.sgp1.cdn.digitaloceanspaces.com/canteen_fine_food.jpeg")!,
        stores: [mockStore]
    )
    NavigationStack {
        DetailedLocationView(location: mockLocation)
            .environmentObject(DataManager.shared)
    }
}

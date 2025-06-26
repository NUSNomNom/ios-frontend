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
        
        Image("nusNomNomLongLogo")
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 25)
        Text(location.name)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.nusBlue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 26)
        
        Image(systemName: "photo")
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .clipped()
        
        Text("Stores")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.nusBlue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 26)
        
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

                        Text(store.is_open ? "Open" : "Closed")
                            .font(.caption)
                            .foregroundColor(store.is_open ? .green : .red)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        
        Spacer()
    }
}

#Preview {
    let mockStore = Store(
        id: 1,
        name: "Golden Wok",
        is_open: true,
        cuisine: "Chinese",
        information: "Authentic stir-fried dishes",
        items: []
    )

    let mockLocation = Location(
        id: 101,
        name: "Fine Food @ UTown",
        latitude: .init(wrapperValue: Decimal(string: "1.3041") ?? 0),
        longitude: .init(wrapperValue: Decimal(string: "103.7721") ?? 0),
        stores: [mockStore]
    )
    NavigationStack {
        DetailedLocationView(location: mockLocation)
            .environmentObject(DataManager.shared)
    }
}

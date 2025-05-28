//
//  SearchView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct SearchView: View {
    
    var body: some View {
        
        
        NavigationStack {
            List(MockStoreData.stores) {
                store in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(store.name)
                            .font(.headline)
                        Spacer()
                        Text(store.isOpen ? "Open" : "Closed")
                            .font(.caption)
                            .foregroundColor(store.isOpen ? .green : .red)
                    }
                    
                    Text(store.cuisine)
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                    
                    Text(store.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("All Food Stalls")
        }
    }
}

#Preview {
    SearchView()
}

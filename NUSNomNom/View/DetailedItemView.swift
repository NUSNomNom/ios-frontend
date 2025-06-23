//
//  DetailedItemView.swift
//  NUSNomNom
//
//  Created by Nutabi on 22/6/25.
//

import SwiftUI

struct DetailedItemView: View {
    let item: Item
    
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFill()
            .frame(height: 500)
            .frame(maxWidth: .infinity)
            .clipped()
        
        VStack(alignment: .center, spacing: 12) {
            Text(item.name)
                .font(.headline)
            
            Text(item.information)
                .font(.body)
        }
    }
}

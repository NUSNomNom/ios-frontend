//
//  SearchBar.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    let placeholder: String
    let showFilterButton: Bool
    let onFilterTap: (() -> Void)?
    
    init(
        searchText: Binding<String>,
        placeholder: String = "Search...",
        showFilterButton: Bool = false,
        onFilterTap: (() -> Void)? = nil
    ) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.showFilterButton = showFilterButton
        self.onFilterTap = onFilterTap
    }
    
    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField(placeholder, text: $searchText)
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
            
            if showFilterButton {
                Button(action: {
                    onFilterTap?()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        SearchBar(
            searchText: .constant(""),
            placeholder: "Search locations...",
            showFilterButton: false
        )
        
        SearchBar(
            searchText: .constant(""),
            placeholder: "Search stores...",
            showFilterButton: true,
            onFilterTap: {}
        )
    }
}

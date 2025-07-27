//
//  FilterSheetView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 26/6/25.
//

import SwiftUI

struct FilterSheetView: View {
    let allCuisines: [String]
    @Binding var selectedCuisines: Set<String>
    @Binding var showOnlyOpenStores: Bool
    let onDone: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    
                    cuisineSection
                    
                    storeStatusSection
                    
                    actionButtons
                    
                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var headerSection: some View {
        VStack {
            PageTitle(
                title: "Filter by",
                alignment: .leading
            )
            .padding(.horizontal)

            Divider()
        }
    }
    
    private var cuisineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cuisine")
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal)

            ForEach(allCuisines, id: \.self) { cuisine in
                MultipleSelectionRow(
                    title: cuisine,
                    isSelected: selectedCuisines.contains(cuisine)
                ) {
                    toggleCuisineSelection(cuisine)
                }
                .padding(.horizontal)
            }
            
            Divider()
        }
    }
    
    private var storeStatusSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Only show open stores", isOn: $showOnlyOpenStores)
                .padding(.horizontal)
            
            Divider()
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            NUSBlueButton(title: "Done") {
                onDone()
            }
            .padding(.horizontal)
            
            NUSOrangeButton(title: "Reset Filters") {
                resetFilters()
            }
            .padding(.horizontal)
        }
    }
    
    private func toggleCuisineSelection(_ cuisine: String) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.remove(cuisine)
        } else {
            selectedCuisines.insert(cuisine)
        }
    }
    
    private func resetFilters() {
        selectedCuisines.removeAll()
        showOnlyOpenStores = false
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    FilterSheetView(
        allCuisines: ["Chinese", "Indian", "Malay", "Japanese"],
        selectedCuisines: .constant(["Chinese", "Japanese"]),
        showOnlyOpenStores: .constant(true),
        onDone: {}
    )
}

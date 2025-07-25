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
                    

                    Text("Filter by")
                        .foregroundColor(.nusBlue)
                        .font(.system(size: 40, weight: .heavy))
                        .padding(.horizontal)

                    Divider()
                    
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
                                if selectedCuisines.contains(cuisine) {
                                    selectedCuisines.remove(cuisine)
                                } else {
                                    selectedCuisines.insert(cuisine)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Only show open stores", isOn: $showOnlyOpenStores)
                            .padding(.horizontal)
                    }

                    Divider()

                    Button(action: {
                        onDone()
                    }) {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.nusBlue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        selectedCuisines.removeAll()
                        showOnlyOpenStores = false
                    }) {
                        Text("Reset Filters")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.nusOrange)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
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

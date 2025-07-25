//
//  ButtonStyles.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isDisabled: Bool
    let isLoading: Bool
    let action: () -> Void
    
    init(
        title: String,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .fontWeight(.bold)
                }
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(isDisabled ? Color.gray : Color.blue)
        .cornerRadius(12)
        .disabled(isDisabled || isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(isDisabled ? Color.gray : Color.orange)
        .cornerRadius(12)
        .disabled(isDisabled)
    }
}

struct NUSBlueButton: View {
    let title: String
    let isDisabled: Bool
    let isLoading: Bool
    let action: () -> Void
    
    init(
        title: String,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .fontWeight(.bold)
                }
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(isDisabled ? Color.gray : Color.nusBlue)
        .cornerRadius(12)
        .disabled(isDisabled || isLoading)
    }
}

struct NUSOrangeButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(isDisabled ? Color.gray : Color.nusOrange)
        .cornerRadius(12)
        .disabled(isDisabled)
    }
}

// MARK: - Previews
#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Primary Button") {}
        SecondaryButton(title: "Secondary Button") {}
        NUSBlueButton(title: "NUS Blue Button") {}
        NUSOrangeButton(title: "NUS Orange Button") {}
        
        PrimaryButton(title: "Loading", isLoading: true) {}
        PrimaryButton(title: "Disabled", isDisabled: true) {}
    }
    .padding()
}

//
//  NavigationHeader.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct CancelNavigationHeader: View {
    let onCancel: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button("Cancel") {
                onCancel()
            }
            .foregroundColor(.blue)
            .fontWeight(.bold)
            .padding(.trailing)
        }
        .padding(.bottom, 40)
    }
}

struct PageTitle: View {
    let title: String
    let alignment: Alignment
    let color: Color
    let fontSize: CGFloat
    
    init(
        title: String,
        alignment: Alignment = .leading,
        color: Color = .nusBlue,
        fontSize: CGFloat = 40
    ) {
        self.title = title
        self.alignment = alignment
        self.color = color
        self.fontSize = fontSize
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(color)
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(.leading, alignment == .leading ? 26 : 0)
    }
}

// MARK: - Previews
#Preview {
    VStack(spacing: 20) {
        CancelNavigationHeader {
            print("Cancel tapped")
        }
        
        PageTitle(title: "Welcome to NUS NomNom")
        
        PageTitle(
            title: "Centered Title",
            alignment: .center,
            color: .blue,
            fontSize: 32
        )
    }
}

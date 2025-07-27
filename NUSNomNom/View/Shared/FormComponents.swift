//
//  FormComponents.swift
//  NUSNomNom
//
//  Created by Nutabi on 25/7/25.
//

import SwiftUI

struct StyledTextField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization
    
    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(autocapitalization)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
    }
}

struct StyledSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
    }
}

struct StyledTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let height: CGFloat
    
    init(
        text: Binding<String>,
        placeholder: String = "Enter text here...",
        height: CGFloat = 120
    ) {
        self._text = text
        self.placeholder = placeholder
        self.height = height
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
            
            TextEditor(text: $text)
                .frame(height: height)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3))
                )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StyledTextField(
            placeholder: "Email",
            text: .constant(""),
            keyboardType: .emailAddress,
            autocapitalization: .never
        )
        
        StyledSecureField(
            placeholder: "Password",
            text: .constant("")
        )
        
        StyledTextEditor(
            text: .constant(""),
            placeholder: "Enter your review here..."
        )
    }
    .padding()
}

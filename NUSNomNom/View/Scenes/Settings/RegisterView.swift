//
//  RegisterView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 30/5/25.
//

import SwiftUI

struct RegisterRequest: Codable {
    let displayName: String
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let message: String
}

struct RegisterView: View {
    @State private var inputDisplayName = ""
    @State private var inputEmail = ""
    @State private var inputPassword = ""
    @State private var inputConfirmPassword = ""
    
    @State private var showErrorAlert = false
    @State private var alertMessage: String?
    
    @Binding var registerSuccess: Bool
    
    @EnvironmentObject var auth: AuthManager

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.blue)
                .fontWeight(.bold)
                .padding(.trailing)
            }
            
            Image(systemName: "envelope")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 80, height: 80)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Create an Account")
                .font(.title)
                .bold()
                .foregroundColor(.black)
            
            Text("Use your email to create an account and start eating!")
                .font(.subheadline)
                .bold()
                .foregroundColor(.gray)
            
            Group {
                TextField("Display Name", text: $inputDisplayName)
                TextField("Email Address", text: $inputEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("Password", text: $inputPassword)
                SecureField("Confirm Password", text: $inputConfirmPassword)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Button("Register") {
                
                if let error = validateInputs() {
                    alertMessage = error
                    showErrorAlert = true
                    return
                }
                
                Task {
                    do {
                        try await auth.register(displayName: inputDisplayName, email: inputEmail, password: inputPassword)
                        registerSuccess = true
                    } catch {
                        alertMessage = error.localizedDescription
                        showErrorAlert = true
                    }
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .fontWeight(.bold)
            .cornerRadius(12)
            .padding(.horizontal)
            .disabled(inputDisplayName.isEmpty || inputEmail.isEmpty || inputPassword.isEmpty || inputConfirmPassword.isEmpty)
            
            Spacer()
        }
        .padding(.top)
        
        .alert(
            "Registration Error",
            isPresented: $showErrorAlert,
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage ?? "Unknown error occurred")
        }
    }
    
    private func validateInputs() -> String? {
        if inputDisplayName.isEmpty || inputEmail.isEmpty || inputPassword.isEmpty || inputConfirmPassword.isEmpty {
            return "All fields are required."
        }
        
        if !inputEmail.contains("@") || !inputEmail.contains(".") {
            return "Please enter a valid email address."
        }
        
        if inputPassword.count < 8 {
            return "Password must be at least 8 characters long."
        }
        
        if inputPassword != inputConfirmPassword {
            return "Passwords do not match."
        }

        return nil
    }
    
}


#Preview {
    RegisterView(registerSuccess: .constant(false))
        .environmentObject(AuthManager.shared)
}

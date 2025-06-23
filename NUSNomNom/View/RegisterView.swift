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

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.nusBlue, .nusOrange]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

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
                .background(Color.green)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(inputDisplayName.isEmpty || inputEmail.isEmpty || inputPassword.isEmpty || inputConfirmPassword.isEmpty)

                Spacer()
            }
            .padding(.top)
        }
        .alert(
            "Registration Error",
            isPresented: $showErrorAlert,
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage ?? "Unknown error occurred")
        }
    }
}

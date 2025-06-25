//
//  LoginView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 28/5/25.
//

import SwiftUI

struct LoginView: View {
    @State private var inputEmail = ""
    @State private var inputPassword = ""
    
    @State private var showRegisterSuccessAlert = false
    @State private var showRegisterView = false
    
    @State private var showLoginErrorAlert = false
    @State private var loginErrorMessage = ""
    
    @EnvironmentObject var auth: AuthManager
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var loginSuccess: Bool

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
            .padding(.bottom, 40)
            
            Text("Welcome to")
                .font(.title)
                .fontWeight(.bold)
            
            Image("nusNomNomLongLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 80)
                .clipped()
            
            Text("Sign in with email!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Sign in to write reviews for your favourite stores, use NUS NomNom on multiple devices and more!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            TextField("Email", text: $inputEmail)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            SecureField("Password", text: $inputPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            Button("Login") {
                Task {
                    do {
                        try await auth.login(as: inputEmail, with: inputPassword)
                        loginSuccess = true
                    } catch {
                        showLoginErrorAlert = true
                        loginErrorMessage = error.localizedDescription
                    }
                }
            }
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .disabled(inputEmail.isEmpty || inputPassword.isEmpty)
            
            
            Button("Register") {
                showRegisterView = true
            }
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .cornerRadius(12)
            
        }
        .padding()
        .sheet(isPresented: $showRegisterView) {
            RegisterView(registerSuccess: $showRegisterSuccessAlert)
                .environmentObject(auth)
        }
        .alert(
            "Successful Registration",
            isPresented: $showRegisterSuccessAlert
        ) {
            Button("OK", role: .cancel) {}
        }
        .alert(
            "Error",
            isPresented: $showLoginErrorAlert
        ) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(loginErrorMessage)
        }
        Spacer()
    }
}

#Preview {
    LoginView(loginSuccess: .constant(false))
        .environmentObject(AuthManager.shared)
}

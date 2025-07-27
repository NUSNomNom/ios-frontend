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
            headerSection
            
            formSection
            
            actionButtons
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showRegisterView) {
            RegisterView(registerSuccess: $showRegisterSuccessAlert)
                .environmentObject(auth)
        }
        .alert("Successful Registration", isPresented: $showRegisterSuccessAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Error", isPresented: $showLoginErrorAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(loginErrorMessage)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            CancelNavigationHeader {
                dismiss()
            }
            
            welcomeSection
        }
    }
    
    private var welcomeSection: some View {
        VStack(spacing: 16) {
            Text("Welcome to")
                .font(.title)
                .fontWeight(.bold)
            
            Image("nusNomNomLongLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 80)
                .clipped()
            
            VStack(spacing: 8) {
                Text("Sign in with email!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Sign in to write reviews for your favourite stores, use NUS NomNom on multiple devices and more!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 16) {
            StyledTextField(
                placeholder: "Email",
                text: $inputEmail,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )
            
            StyledSecureField(
                placeholder: "Password",
                text: $inputPassword
            )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                title: "Login",
                isDisabled: inputEmail.isEmpty || inputPassword.isEmpty
            ) {
                handleLogin()
            }
            
            SecondaryButton(title: "Register") {
                showRegisterView = true
            }
        }
    }
    
    private func handleLogin() {
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
}

#Preview {
    LoginView(loginSuccess: .constant(false))
        .environmentObject(AuthManager.shared)
}

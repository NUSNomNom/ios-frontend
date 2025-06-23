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
    
    @Binding var loginSuccess: Bool

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.nusBlue, .nusOrange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Welcome")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Image("nusLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 150)
                
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
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .disabled(inputEmail.isEmpty || inputPassword.isEmpty)
                
                
                Button("Register") {
                    showRegisterView = true
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(12)
                
            }
            .padding()
        }
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
    }
}

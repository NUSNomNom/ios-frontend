//
//  RegisterView.swift
//  NUSNomNom
//
//  Created by Kevan Chng on 30/5/25.
//

import SwiftUI

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let success: Bool
    let message: String
}

struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .orange]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Full Name", text: $name)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }

                    Section(header: Text("Password")) {
                        SecureField("Password", text: $password)
                        SecureField("Confirm Password", text: $confirmPassword)
                    }

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }

                    Button("Register") {
                        register()
                    }
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .navigationTitle("Register")
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
            }
        }
    }

    func register() {
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        let requestData = RegisterRequest(name: name, email: email, password: password)

        guard let url = URL(string: "https://your-backend.com/register"),
              let jsonData = try? JSONEncoder().encode(requestData) else {
            errorMessage = "Invalid request"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "Network error"
                }
                return
            }

            if let decoded = try? JSONDecoder().decode(RegisterResponse.self, from: data), decoded.success {
                DispatchQueue.main.async {
                    errorMessage = nil
                    navigateToLogin = true
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Registration failed"
                }
            }
        }.resume()
    }
}


#Preview {
    RegisterView()
}

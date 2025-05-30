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
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var navigateToLogin = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .orange]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Create an Account")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Group {
                        TextField("Full Name", text: $name)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Button("Register") {
                        register()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)

                    Spacer()
                }
                .padding(.top)
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

        let requestData = RegisterRequest(displayName: name, email: email, password: password)

        guard let url = URL(string: "http://68.183.235.200:3000/api/user"),
              let jsonData = try? JSONEncoder().encode(requestData) else {
            errorMessage = "Invalid request"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    errorMessage = "Invalid server response"
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    navigateToLogin = true
                    errorMessage = nil
                    dismiss()
                    
                } else {
                    if let decoded = try? JSONDecoder().decode(RegisterResponse.self, from: data) {
                        errorMessage = decoded.message
                    } else {
                        errorMessage = "Registration failed with status code \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    RegisterView()
}

//
//  LoginView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = AuthViewModel.shared
    @State private var navigateToSignUp = false
    
    
    var body: some View {
       ZStack {
           Color(.systemGray6).ignoresSafeArea()

           VStack(spacing: 0) {
               // Logo
               logoView
                   .padding(.top, 60)

               Spacer()

               // Welcome Text
               welcomeText
                   .padding(.horizontal, 28)

               Spacer()

               // Form
               formView
                   .padding(.horizontal, 28)

               Spacer()

               // Sign In Button
               signInButton
                   .padding(.horizontal, 28)

               Spacer()

              
           }
       }
               
}
    // MARK: - Logo
        private var logoView: some View {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)

                    Image(systemName: "crown")
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(.primary)
                }

                Text("THE ARTISAN'S VITRINE")
                    .font(.system(size: 11, weight: .medium))
                    .tracking(2.5)
                    .foregroundColor(.secondary)
            }
        }

        // MARK: - Welcome Text
        private var welcomeText: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("Welcome")
                    .font(.system(size: 46, weight: .bold))
                    .foregroundColor(.primary)

                Text("back.")
                    .font(.system(size: 46, weight: .light))
                    .italic()
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        // MARK: - Form
        private var formView: some View {
            VStack(spacing: 28) {
                // Email
                VStack(alignment: .leading, spacing: 8) {
                    Text("EMAIL ADDRESS")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(1.5)
                        .foregroundColor(.secondary)

                    TextField("Enter your email", text: $viewModel.loginEmail)
                        .font(.system(size: 16))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding(.bottom, 10)
                        .overlay(alignment: .bottom) {
                            Divider()
                                .background(Color.secondary.opacity(0.4))
                        }
                }

                // Password
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("PASSWORD")
                            .font(.system(size: 11, weight: .medium))
                            .tracking(1.5)
                            .foregroundColor(.secondary)

                        Spacer()

                        Button("FORGOT?") {}
                            .font(.system(size: 11, weight: .medium))
                            .tracking(1.5)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Group {
                            if viewModel.showPassword {
                                TextField("••••••••", text: $viewModel.loginPassword)
                            } else {
                                SecureField("••••••••", text: $viewModel.loginPassword)
                            }
                        }
                        .font(.system(size: 16))
                        .autocapitalization(.none)
                        .autocorrectionDisabled()

                        Button {
                            viewModel.showPassword.toggle()
                        } label: {
                            Image(systemName: viewModel.showPassword ? "eye" : "eye.slash")
                                .foregroundColor(.secondary)
                                .font(.system(size: 16))
                        }
                    }
                    .padding(.bottom, 10)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .background(Color.secondary.opacity(0.4))
                    }
                }

                // Error
                if let error = viewModel.loginError {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }

        // MARK: - Sign In Button
        private var signInButton: some View {
            Button(action: viewModel.login) {
                HStack {
                    if viewModel.isLoginLoading {
                        ProgressView()
                            .tint(.white)
                        
                    } else {
                        Text("Sign In")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(Color.black)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
            }
            .disabled(viewModel.isLoginLoading)
        }
    }

#Preview {
    LoginView()
}

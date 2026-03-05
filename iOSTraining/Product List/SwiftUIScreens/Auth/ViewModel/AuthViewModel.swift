//
//  AuthViewModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import Foundation
import Combine
import UIKit

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    // Login
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    @Published var loginError: String? = nil
    @Published var isLoginLoading: Bool = false
    @Published var isLoggedIn: Bool = false

    // MARK: - Shared
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Login
    func login() {
        loginError = nil

        do {
            try validate(email: loginEmail, password: loginPassword)
        } catch {
            loginError = error.localizedDescription
            return
        }

        isLoginLoading = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isLoginLoading = false
            UserDefaults.standard.set(self.loginEmail, forKey: "email")
            UserDefaults.standard.set(self.loginPassword, forKey: "password")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
           
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.showMainApp(animated: true)
            }
        }
    }

    // MARK: - Logout
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        isLoggedIn = false
        loginEmail = ""
        loginPassword = ""
    }

    // MARK: - Validate
    private func validate(email: String, password: String) throws {
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        guard email.contains("@") && email.contains(".") else { throw AuthError.invalidEmail }
        guard !password.isEmpty else { throw AuthError.emptyPassword }
        guard password.count >= 6 else { throw AuthError.weakPassword }
    }
}


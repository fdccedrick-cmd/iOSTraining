//
//  AuthUser.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import Foundation

struct AuthUser: Codable {
    let email: String
    let password: String
}

enum AuthError: LocalizedError {
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case weakPassword
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail: return "Email address is required"
        case .emptyPassword: return "Password is required"
        case .invalidEmail: return "Please enter a valid email address"
        case .weakPassword: return "Password must be at least 6 characters."

        }
    }
}

//
//  ProfileModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import Foundation
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    static let shared = ProfileViewModel()

    @Published var email: String = ""
    
    let orderCount: Int = 12
    let favoritesCount: Int = 34

    var emailPrefix: String {
        email.components(separatedBy: "@").first?.capitalized ?? "User"
    }

    let settings: [ProfileSetting] = [
        ProfileSetting(icon: "creditcard", title: "Payment Methods", subtitle: "Visa ending in 4242"),
        ProfileSetting(icon: "mappin.and.ellipse", title: "Address Book", subtitle: "2 saved addresses"),
        ProfileSetting(icon: "bell", title: "Notifications", subtitle: "Manage alerts & emails"),
        ProfileSetting(icon: "lock", title: "Privacy & Security", subtitle: "Manage your data"),
        ProfileSetting(icon: "questionmark.circle", title: "Help & Support", subtitle: "FAQs and contact us")
    ]

    init() {
        loadUserData()

        // Sync favorites count from FavoritesViewModel
//        FavoritesViewModel.shared.$favorites
//            .map { $0.count }
//            .assign(to: &$favoritesCount)
    }

    func loadUserData() {
        email = UserDefaults.standard.string(forKey: "email") ?? "user@example.com"
    }

    func logout() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.logout(animated: true)
        }
    }
}

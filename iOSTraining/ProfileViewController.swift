//
//  ProfileViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/26/26.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Profile"
            setupAppearance()
            populateData()
        }

        private func setupAppearance() {
            logoutButton.backgroundColor = .systemRed
            logoutButton.setTitleColor(.white, for: .normal)
            logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            logoutButton.layer.cornerRadius = 14
            logoutButton.layer.masksToBounds = true
        }

        private func populateData() {
            let email = UserDefaults.standard.string(forKey: "email") ?? "No email"
            emailLabel.text = email
        }

        @IBAction func didTapLogout(_ sender: Any) {
            print("Logout tapped")
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.logout(animated: true)
            }
        }
}

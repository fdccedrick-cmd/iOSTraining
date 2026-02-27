//
//  ProfilePageViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/27/26.
//

import UIKit

class ProfilePageViewController: UIViewController {
   
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Profile"
            setupAppearance()
          
      
            logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        }

        private func setupAppearance() {
            logoutButton.isUserInteractionEnabled = true
            logoutButton.backgroundColor = .systemRed
            logoutButton.setTitleColor(.white, for: .normal)
            logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            logoutButton.layer.cornerRadius = 14
            logoutButton.layer.masksToBounds = true
        }

  
    @objc private func didTapLogout() {
        print("Logout tapped")
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.logout(animated: true)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

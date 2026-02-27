//
//  ViewController.swift
//  iOSTraining
//
//  Created by FDC.Eyan-NC-SA-IOS on 2/24/26.
//

import UIKit

class SigninViewController: UIViewController {
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupAppearance()
        }
        
        private func setupAppearance() {
            view.backgroundColor = .systemBackground
            
            // ✅ Navigation bar hidden for clean login look
            navigationController?.setNavigationBarHidden(true, animated: false)
            
            setupTextField(
                emailTextfield,
                placeholder: "Email",
                icon: "envelope.fill",
                keyboardType: .emailAddress
            )
            setupTextField(
                passwordTextfield,
                placeholder: "Password",
                icon: "lock.fill",
                isSecure: true
            )
        }
        
        private func setupTextField(
            _ textField: UITextField,
            placeholder: String,
            icon: String,
            keyboardType: UIKeyboardType = .default,
            isSecure: Bool = false
        ) {
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
            textField.isSecureTextEntry = isSecure
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.returnKeyType = .done
            textField.delegate = self

            // Border & shape
            textField.layer.cornerRadius = 12
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = UIColor.systemGray4.cgColor
            textField.layer.masksToBounds = true
            textField.backgroundColor = .secondarySystemBackground

            // Left icon
            let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            let iconImageView = UIImageView(frame: CGRect(x: 12, y: 12, width: 20, height: 20))
            iconImageView.image = UIImage(systemName: icon)
            iconImageView.tintColor = .systemGray
            iconImageView.contentMode = .scaleAspectFit
            iconContainer.addSubview(iconImageView)
            textField.leftView = iconContainer
            textField.leftViewMode = .always

            // Right: show/hide toggle for password
            if isSecure {
                let toggleButton = UIButton(type: .custom)
                toggleButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
                toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
                toggleButton.tintColor = .systemGray
                toggleButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
                textField.rightView = toggleButton
                textField.rightViewMode = .always
            }

            // Focus highlight
            textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
            textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        }

        // MARK: - Actions

        @objc private func togglePasswordVisibility(_ sender: UIButton) {
            sender.isSelected.toggle()
            passwordTextfield.isSecureTextEntry = !sender.isSelected
        }

    @objc internal func textFieldDidBeginEditing(_ textField: UITextField) {
            UIView.animate(withDuration: 0.2) {
                textField.layer.borderColor = UIColor.systemGreen.cgColor
                textField.layer.borderWidth = 2
                textField.backgroundColor = .systemBackground
            }
        }

    @objc internal func textFieldDidEndEditing(_ textField: UITextField) {
            UIView.animate(withDuration: 0.2) {
                textField.layer.borderColor = UIColor.systemGray4.cgColor
                textField.layer.borderWidth = 1.5
                textField.backgroundColor = .secondarySystemBackground
            }
        }

        @IBAction func didTapLoginButton(_ sender: Any) {
            let email = emailTextfield.text ?? ""
            let pass = passwordTextfield.text ?? ""

            // ✅ Basic validation
            guard !email.isEmpty, !pass.isEmpty else {
                shakeFields()
                return
            }

            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(pass, forKey: "password")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")

            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.showMainApp(animated: true)
            }
        }

        // ✅ Shake animation if fields are empty on login tap
        private func shakeFields() {
            [emailTextfield, passwordTextfield].forEach { field in
                guard let field = field, field.text?.isEmpty == true else { return }
                let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
                shake.timingFunction = CAMediaTimingFunction(name: .linear)
                shake.duration = 0.4
                shake.values = [-10, 10, -8, 8, -5, 5, 0]
                field.layer.add(shake, forKey: "shake")
                field.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
    }

    // MARK: - UITextFieldDelegate
    extension SigninViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailTextfield {
                passwordTextfield.becomeFirstResponder() // ✅ moves to password on return
            } else {
                textField.resignFirstResponder()
            }
            return true
        }
    }

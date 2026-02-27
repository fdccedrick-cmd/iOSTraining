//
//  ProfilePageViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/27/26.
//

import UIKit

class ProfilePageViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Avatar
    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .systemGreen
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // Name & Email
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Info Card
    private lazy var infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Info Rows
    private lazy var emailRowView = makeInfoRow(icon: "envelope.fill", title: "Email", value: "")
    private lazy var memberRowView = makeInfoRow(icon: "calendar", title: "Member Since", value: "February 2026")
    private lazy var ordersRowView = makeInfoRow(icon: "bag.fill", title: "Total Orders", value: "0")

    // Dividers
    private lazy var divider1 = makeDivider()
    private lazy var divider2 = makeDivider()

    // Logout Button
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return button
    }()

    // Version Label
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version 1.0.0"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        populateData()
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemGroupedBackground
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupLayout() {
        // ScrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Avatar
        avatarContainerView.addSubview(avatarImageView)
        contentView.addSubview(avatarContainerView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)

        NSLayoutConstraint.activate([
            avatarContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            avatarContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarContainerView.widthAnchor.constraint(equalToConstant: 100),
            avatarContainerView.heightAnchor.constraint(equalToConstant: 100),

            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.topAnchor.constraint(equalTo: avatarContainerView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        // Info Card
        contentView.addSubview(infoCardView)
        infoCardView.addSubview(emailRowView)
        infoCardView.addSubview(divider1)
        infoCardView.addSubview(memberRowView)
        infoCardView.addSubview(divider2)
        infoCardView.addSubview(ordersRowView)

        NSLayoutConstraint.activate([
            infoCardView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            emailRowView.topAnchor.constraint(equalTo: infoCardView.topAnchor),
            emailRowView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor),
            emailRowView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor),
            emailRowView.heightAnchor.constraint(equalToConstant: 60),

            divider1.topAnchor.constraint(equalTo: emailRowView.bottomAnchor),
            divider1.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            divider1.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            divider1.heightAnchor.constraint(equalToConstant: 0.5),

            memberRowView.topAnchor.constraint(equalTo: divider1.bottomAnchor),
            memberRowView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor),
            memberRowView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor),
            memberRowView.heightAnchor.constraint(equalToConstant: 60),

            divider2.topAnchor.constraint(equalTo: memberRowView.bottomAnchor),
            divider2.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            divider2.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            divider2.heightAnchor.constraint(equalToConstant: 0.5),

            ordersRowView.topAnchor.constraint(equalTo: divider2.bottomAnchor),
            ordersRowView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor),
            ordersRowView.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor),
            ordersRowView.heightAnchor.constraint(equalToConstant: 60),
            ordersRowView.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor)
        ])

        // Logout + Version
        contentView.addSubview(logoutButton)
        contentView.addSubview(versionLabel)

        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 32),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 52),

            versionLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func populateData() {
        let email = UserDefaults.standard.string(forKey: "email") ?? "No email"
        // Use email prefix as display name
        let name = email.components(separatedBy: "@").first?.capitalized ?? "User"
        nameLabel.text = name
        emailLabel.text = email

        // Update email row value
        if let valueLabel = emailRowView.viewWithTag(100) as? UILabel {
            valueLabel.text = email
        }
    }

    // MARK: - Helpers
    private func makeInfoRow(icon: String, title: String, value: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = .systemGreen
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 15, weight: .medium)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .right
        valueLabel.tag = 100 // for dynamic updates
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8)
        ])

        return container
    }

    private func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    // MARK: - Actions
    @objc private func didTapLogout() {
        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.logout(animated: true)
            }
        })
        present(alert, animated: true)
    }
}

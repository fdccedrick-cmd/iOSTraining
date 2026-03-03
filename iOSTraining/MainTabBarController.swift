//
//  MainTabBarController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/26/26.
//
import UIKit
import SwiftUI
import Combine

class MainTabBarController: UITabBarController {

    private let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        setupTabBarStyle()
    }

    private func setupTabBarStyle() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(white: 0.97, alpha: 1.0)

       
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]

        // ✅ Unselected item — medium gray
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(white: 0.6, alpha: 1.0)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(white: 0.6, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 10, weight: .regular)
        ]

        // ✅ Top border line
        _ = UIView()
        let borderColor = UIColor(white: 0.88, alpha: 1.0)
        appearance.shadowColor = borderColor

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = UIColor(white: 0.6, alpha: 1.0)

        // ✅ Subtle shadow on top
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.06
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.masksToBounds = false
    }

    private func setupViewControllers() {
        
        let productListVC = ProductListViewController(
            nibName: String(describing: ProductListViewController.self),
            bundle: nil
        )
        let productsNav = UINavigationController(rootViewController: productListVC)
        productsNav.tabBarItem = UITabBarItem(
            title: "Products",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )

        let favoritesVC = UIHostingController(rootView: FavoritesView() )
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            tag: 1
        )

        let cartVC = UIHostingController(rootView: CartView())
        cartVC.title = "Cart"
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            tag: 2
        )

        let profileVC = UIHostingController(rootView: ProfileView())
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 3
        )

        viewControllers = [productsNav, favoritesNav, cartNav, profileNav]
    }
}

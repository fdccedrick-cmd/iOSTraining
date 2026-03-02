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
        appearance.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBar.isTranslucent = false   // VERY IMPORTANT
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .darkGray
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

        let favoritesVC = FavoritesViewController()
        favoritesVC.view.backgroundColor = .systemBackground
        favoritesVC.title = "Favorites"
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

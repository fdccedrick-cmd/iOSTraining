//
//  MainTabBarController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/26/26.
//
import Combine
import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ✅ Tab 1 - Products (has XIB)
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
        
        // ✅ Tab 2 - Favorites (no XIB)
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
        cartVC.view.backgroundColor = .systemBackground
        cartVC.title = "Cart"
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            tag: 2
        )
        
        // ✅ Tab 4 - Profile (no XIB)
        
        let profileVC = ProfilePageViewController()
        profileVC.title = "Profile"
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 3
        )
        
        viewControllers = [productsNav, favoritesNav, cartNav, profileNav]
        tabBar.tintColor = .systemTeal
    }
}

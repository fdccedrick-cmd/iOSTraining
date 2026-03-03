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
    private var cartObserver: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        setupTabBarStyle()
        setupBadgeObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAllBadges()
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
        
        // ✅ Badge appearance
        appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = .systemRed
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = .systemRed
        appearance.stackedLayoutAppearance.normal.badgeTextAttributes = [
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        appearance.stackedLayoutAppearance.selected.badgeTextAttributes = [
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
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

        let favoritesVC = UIHostingController(rootView:   FavoritesView() )
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            tag: 1
        )

        let cartVC = UIHostingController(rootView: CartView())
        cartVC.tabBarItem = UITabBarItem(
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

        viewControllers = [productsNav, favoritesNav, cartVC, profileNav]
    }
    
    private func setupBadgeObservers() {
        // Observe cart item count changes on main thread
        cartObserver = CartViewModel.shared.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateCartBadge()
            }
        
        // Observe product count updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateProductsBadge(_:)),
            name: NSNotification.Name("ProductsCountUpdated"),
            object: nil
        )
        
        // Observe app becoming active to refresh badges
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // Initial badge update
        updateAllBadges()
    }
    
    @objc private func appDidBecomeActive() {
        updateAllBadges()
    }
    
    @objc private func updateProductsBadge(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        
        DispatchQueue.main.async { [weak self] in
            if count > 0 {
                let badgeValue = count > 99 ? "99+" : "\(count)"
                self?.tabBar.items?[0].badgeValue = badgeValue
            } else {
                self?.tabBar.items?[0].badgeValue = nil
            }
        }
    }
    
    private func updateCartBadge() {
        let count = CartViewModel.shared.itemCount
        
        DispatchQueue.main.async { [weak self] in
            if count > 0 {
                let badgeValue = count > 99 ? "99+" : "\(count)"
                self?.tabBar.items?[2].badgeValue = badgeValue
            } else {
                self?.tabBar.items?[2].badgeValue = nil
            }
        }
    }
    
    private func updateAllBadges() {
        updateCartBadge()
        updateProductsBadgeFromCurrentData()
    }
    
    private func updateProductsBadgeFromCurrentData() {
        // Try to get product count from ProductListViewController
        guard let productsNav = viewControllers?[0] as? UINavigationController,
              let productListVC = productsNav.viewControllers.first as? ProductListViewController else {
            return
        }
        
        let count = productListVC.dummyProducts.count
        
        DispatchQueue.main.async { [weak self] in
            if count > 0 {
                let badgeValue = count > 99 ? "99+" : "\(count)"
                self?.tabBar.items?[0].badgeValue = badgeValue
            } else {
                self?.tabBar.items?[0].badgeValue = nil
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


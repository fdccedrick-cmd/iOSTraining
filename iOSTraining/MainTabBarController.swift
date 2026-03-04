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

    private var cartObserver: AnyCancellable?

    // MARK: - Lifecycle
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup overlay window once view is on screen
        if overlayWindow == nil {
            setupFlashSaleOverlay()
        }
    }

    private var overlayWindow: PassthroughWindow?

    deinit {
        NotificationCenter.default.removeObserver(self)
        overlayWindow = nil
    }

    private func setupFlashSaleOverlay() {
        // Create a new window for the overlay
        guard let windowScene = view.window?.windowScene else { return }
        
        let overlayWindow = PassthroughWindow(windowScene: windowScene)
        overlayWindow.backgroundColor = .clear
        overlayWindow.windowLevel = .normal // Same level as main window
        overlayWindow.isHidden = false
        
        let overlayVC = UIHostingController(rootView: FlashSaleOverlayView())
        overlayVC.view.backgroundColor = .clear
        overlayWindow.rootViewController = overlayVC
        
        self.overlayWindow = overlayWindow
        
        // Listen for modal state changes to adjust window interaction
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(flashSaleModalStateChanged(_:)),
            name: NSNotification.Name("FlashSaleModalStateChanged"),
            object: nil
        )
    }
    
    @objc private func flashSaleModalStateChanged(_ notification: Notification) {
        guard let isShowing = notification.userInfo?["isShowing"] as? Bool else { return }
        // When modal is showing, bring window to front
        if isShowing {
            overlayWindow?.windowLevel = .normal + 1
        } else {
            overlayWindow?.windowLevel = .normal
        }
    }
    
    // MARK: - PassthroughWindow
    class PassthroughWindow: UIWindow {
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            // Get the hit view from the default implementation
            guard let hitView = super.hitTest(point, with: event) else {
                return nil
            }
            
            // If modal is showing, capture ALL touches - don't pass through anything
            if FlashSaleViewModel.shared.showModal {
                return hitView
            }
            
            // Modal is not showing, so we're in passthrough mode for the banner
            // If we hit the root view controller's view or the window itself, pass through
            if hitView == rootViewController?.view || hitView == self {
                return nil
            }
            
            // Check if the hit view is small enough to be the banner or its content
            let hitWidth = hitView.bounds.width
            let hitHeight = hitView.bounds.height
            
            // Banner is 160x60, so if we hit something around that size or smaller, capture it
            if hitWidth <= 180 && hitHeight <= 100 {
                // This is likely the banner or its subviews, capture it
                return hitView
            }
            
            // It's a full-screen container, pass through
            return nil
        }
    }


    // MARK: - Tab Bar Style
    private func setupTabBarStyle() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        appearance.shadowColor = UIColor(white: 0.88, alpha: 1.0)

        // Selected
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]

        // Unselected
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(white: 0.6, alpha: 1.0)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(white: 0.6, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 10, weight: .regular)
        ]

        // Badge
        appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = .systemRed
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = .systemRed
        appearance.stackedLayoutAppearance.normal.badgeTextAttributes = [
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        appearance.stackedLayoutAppearance.selected.badgeTextAttributes = [
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = UIColor(white: 0.6, alpha: 1.0)

        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.06
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.masksToBounds = false
    }

    // MARK: - View Controllers
    private func setupViewControllers() {
        
        
        let homeVC = UIHostingController(rootView: HomeView())
        homeVC.view.backgroundColor = .clear
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 1
            )
        
        
        // Tab 1 - Products (UIKit)
        let productListVC = ProductListViewController(
            nibName: String(describing: ProductListViewController.self),
            bundle: nil
        )
        let productsNav = UINavigationController(rootViewController: productListVC)
        productsNav.tabBarItem = UITabBarItem(
            title: "Products",
            image: UIImage(systemName: "square.grid.2x2"), tag: 2
//            selectedImage: UIImage(systemName: "list.bullet")
        )

        // Tab 2 - Favorites (SwiftUI)
        let favoritesVC = UIHostingController(rootView: FavoritesView())
        favoritesVC.view.backgroundColor = .clear
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        // Tab 3 - Cart (SwiftUI)
        let cartVC = UIHostingController(rootView: CartView())
        cartVC.view.backgroundColor = .clear
        cartVC.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )

        // Tab 4 - Profile (SwiftUI)
        let profileVC = UIHostingController(rootView: ProfileView())
        profileVC.view.backgroundColor = .clear
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [homeNav, productsNav, favoritesNav, cartVC, profileNav]
    }

    // MARK: - Badge Observers
    private func setupBadgeObservers() {
        // Cart badge
        cartObserver = CartViewModel.shared.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateCartBadge()
            }

        // Products badge via NotificationCenter
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateProductsBadge(_:)),
            name: NSNotification.Name("ProductsCountUpdated"),
            object: nil
        )

        // Refresh on app active
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        updateAllBadges()
    }

    @objc private func appDidBecomeActive() {
        updateAllBadges()
    }

    @objc private func updateProductsBadge(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        DispatchQueue.main.async { [weak self] in
            self?.tabBar.items?[1].badgeValue = count > 0
                ? (count > 99 ? "99+" : "\(count)")
                : nil
        }
    }

    private func updateCartBadge() {
        let count = CartViewModel.shared.itemCount
        DispatchQueue.main.async { [weak self] in
            self?.tabBar.items?[3].badgeValue = count > 0
                ? (count > 99 ? "99+" : "\(count)")
                : nil
        }
    }

    private func updateAllBadges() {
        updateCartBadge()
        updateProductsBadgeFromCurrentData()
    }

    private func updateProductsBadgeFromCurrentData() {
        guard let productsNav = viewControllers?[1] as? UINavigationController,
              let productListVC = productsNav.viewControllers.first as? ProductListViewController else { return }

        let count = productListVC.dummyProducts.count
        DispatchQueue.main.async { [weak self] in
            self?.tabBar.items?[1].badgeValue = count > 0
                ? (count > 99 ? "99+" : "\(count)")
                : nil
        }
    }
}

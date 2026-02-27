//
//  MainTabBarController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/26/26.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Tab bar background color
//            tabBar.barTintColor = UIColor.systemGray6
//            tabBar.backgroundColor = UIColor.systemGray6
//
//            // Optional: item color
//            tabBar.tintColor = .systemBlue              // selected icon
//            tabBar.unselectedItemTintColor = .gray

        let productListVC = ProductListViewController()
                let productsVC = UINavigationController(rootViewController: productListVC)
                productsVC.setNavigationBarHidden(false, animated: false)
                productsVC.tabBarItem = UITabBarItem(title: "Products",
                                                     image: UIImage(systemName: "list.bullet"),
                                                     tag: 0)


        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites",
                                              image: UIImage(systemName: "heart"),
                                              tag: 1)

        let cartVC = UINavigationController(rootViewController: CartViewController())
        cartVC.tabBarItem = UITabBarItem(title: "Cart",
                                         image: UIImage(systemName: "cart"),
                                         tag: 2)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person"),
                                            tag: 3)

        viewControllers = [productsVC, favoritesVC, cartVC, profileVC]
    }
}

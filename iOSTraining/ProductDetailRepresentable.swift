//
//  ProductDetailRepresentable.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/5/26.
//

import SwiftUI
import UIKit

struct ProductDetailRepresentable: UIViewControllerRepresentable {
    let product: DummyProduct

    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = ProductDetailViewController(
            nibName: String(describing: ProductDetailViewController.self),
            bundle: nil
        )
        vc.dummyProduct = product
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.tintColor = .systemTeal
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

//
//  HomeModelView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    static let shared = HomeViewModel()

    @Published var featuredProducts: [DummyProduct] = []
    @Published var trendingProducts: [DummyProduct] = []
    @Published var selectedCategory: String = "All"
    @Published var isLoading: Bool = true
    @Published var currentBannerIndex: Int = 0
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()
    private var bannerTimer: AnyCancellable?

    let categories: [HomeCategory] = [
        HomeCategory(name: "All", icon: "square.grid.2x2.fill"),
        HomeCategory(name: "Beauty", icon: "sparkles"),
        HomeCategory(name: "Electronics", icon: "bolt.fill"),
        HomeCategory(name: "Clothing", icon: "tshirt.fill"),
        HomeCategory(name: "Sports", icon: "figure.run"),
        HomeCategory(name: "Home", icon: "house.fill")
    ]

    let banners: [HomeBanner] = [
        HomeBanner(
            title: "New Arrivals",
            subtitle: "Discover the latest products",
            badge: "NEW",
            gradientColors: ["1a1a2e", "16213e"]
        ),
        HomeBanner(
            title: "Flash Sale",
            subtitle: "Up to 50% off today only",
            badge: "SALE",
            gradientColors: ["FF4500", "FF6B00"]
        ),
        HomeBanner(
            title: "Top Rated",
            subtitle: "Customer favorites this week",
            badge: "⭐️ TOP",
            gradientColors: ["0f3460", "533483"]
        )
    ]

    var filteredProducts: [DummyProduct] {
        if selectedCategory == "All" { return featuredProducts }
        return featuredProducts.filter {
            $0.category.lowercased().contains(selectedCategory.lowercased())
        }
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning ☀️"
        case 12..<17: return "Good Afternoon 🌤️"
        default: return "Good Evening 🌙"
        }
    }

    var userName: String {
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        return email.components(separatedBy: "@").first?.capitalized ?? "Guest"
    }

    init() {
        startBannerAutoScroll()
    }

    func loadProducts(_ products: [DummyProduct]) {
        isLoading = false
        featuredProducts = Array(products.prefix(6))
        trendingProducts = products.sorted { $0.rating > $1.rating }
    }

    private func startBannerAutoScroll() {
        bannerTimer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.easeInOut(duration: 0.6)) {
                    self.currentBannerIndex = (self.currentBannerIndex + 1) % self.banners.count
                }
            }
    }
}

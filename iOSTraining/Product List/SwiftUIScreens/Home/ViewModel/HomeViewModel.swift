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

    @Published var allProducts: [DummyProduct] = []
    @Published var featuredProducts: [DummyProduct] = []
    @Published var trendingProducts: [DummyProduct] = []
    @Published var selectedCategory: String = "All"
    @Published var isLoading: Bool = true
    @Published var currentBannerIndex: Int = 0
    @Published var searchText: String = ""
    @Published var currentSort: SortOption = .featured
    @Published var isSearchActive: Bool = false

    enum SortOption: String, CaseIterable {
           case featured      = "Featured"
           case nameAZ        = "Name (A-Z)"
           case priceLowHigh  = "Price (Low to High)"
           case topRated      = "Top Rated"

           var icon: String {
               switch self {
               case .featured:     return "sparkles"
               case .nameAZ:       return "textformat.abc"
               case .priceLowHigh: return "tag.fill"
               case .topRated:     return "star.fill"
               }
           }
       }
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

    var isShowingSearchResults: Bool {
            !searchText.isEmpty
        }
        var displayedProducts: [DummyProduct] {
            var result = allProducts

            // 1. Filter by category
            if selectedCategory != "All" {
                result = result.filter {
                    $0.category.lowercased().contains(selectedCategory.lowercased())
                }
            }

            // 2. Filter by search
            if !searchText.isEmpty {
                result = result.filter {
                    $0.title.lowercased().contains(searchText.lowercased()) ||
                    $0.category.lowercased().contains(searchText.lowercased())
                }
            }

            // 3. Apply sort
            switch currentSort {
            case .featured:
                break // original order
            case .nameAZ:
                result.sort { $0.title < $1.title }
            case .priceLowHigh:
                result.sort { $0.price < $1.price }
            case .topRated:
                result.sort { $0.rating > $1.rating }
            }

            return result
        }

    var searchResultCount: Int { displayedProducts.count }
    
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
        setupSearchDebounce()
        fetchProducts()
    }
    private func setupSearchDebounce() {
            $searchText
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    
    
    func fetchProducts() {
        isLoading = true
        NetworkManager.shared.fetchProducts { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let products):
                self.allProducts = products
                self.featuredProducts = Array(products.prefix(6))
                self.trendingProducts = products.sorted { $0.rating > $1.rating }

                FlashSaleViewModel.shared.loadSaleItems(from: products)

            case .failure(let error):
                print("HomeViewModel fetch error: \(error.localizedDescription)")
            }
        }
    }
    func clearSearch() {
            searchText = ""
            isSearchActive = false
        }

    func applySort(_ sort: SortOption) {
        withAnimation(.spring(response: 0.3)) {
            currentSort = sort
        }
    }
    
    func loadProducts(_ products: [DummyProduct]) {
        isLoading = false
        allProducts = products
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

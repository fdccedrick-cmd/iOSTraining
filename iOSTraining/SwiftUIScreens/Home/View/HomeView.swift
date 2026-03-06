//
//  HomeView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel.shared
    @ObservedObject var flashSaleViewModel = FlashSaleViewModel.shared
    @State private var selectedProduct: DummyProduct? = nil
    @State private var showSearchBar = false
    @State private var animateHeader = false
    @State private var toastMessage: String? = nil
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerSection
                    searchSection
                    if viewModel.isShowingSearchResults {
                        searchResultsSection
                    } else {
                        heroBannerSection
                        categoriesSection
                        featuredSection
                        trendingSection
                    }
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .scrollDismissesKeyboard(.immediately)

            if let message = toastMessage {
                Text("  \(message)  ")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 16)
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedProduct, onDismiss: nil) { product in
                    ProductDetailRepresentable(product: product)
                        .ignoresSafeArea()
                }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateHeader = true
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.greeting)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .opacity(animateHeader ? 1 : 0)
                    .offset(y: animateHeader ? 0 : -10)
                    .animation(.spring(response: 0.5).delay(0.1), value: animateHeader)

                Text(viewModel.userName)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.primary)
                    .opacity(animateHeader ? 1 : 0)
                    .offset(y: animateHeader ? 0 : -10)
                    .animation(.spring(response: 0.5).delay(0.2), value: animateHeader)
            }

            Spacer()

            HStack(spacing: 12) {
                // ✅ Flash Sale Icon - appears when sale is active and user dismissed modal
                if flashSaleViewModel.state == .saleActive && flashSaleViewModel.userDismissedModal {
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            flashSaleViewModel.openModal()
                        }
                    } label: {
                        ZStack {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "FF4500"), Color(hex: "FF6B00")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: Color(hex: "FF4500").opacity(0.4), radius: 8, x: 0, y: 4)
                            
                            // Pulsing indicator
                            Circle()
                                .stroke(Color.yellow, lineWidth: 2)
                                .frame(width: 42, height: 42)
                                .scaleEffect(flashSaleViewModel.isPulsing ? 1.2 : 1.0)
                                .opacity(flashSaleViewModel.isPulsing ? 0.0 : 0.6)
                                .animation(
                                    .easeOut(duration: 1.5)
                                    .repeatForever(autoreverses: false),
                                    value: flashSaleViewModel.isPulsing
                                )
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Notification Icon
                ZStack(alignment: .topTrailing) {
                    Button {} label: {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
                    }

                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .offset(x: 2, y: 2)
                }
            }
            .opacity(animateHeader ? 1 : 0)
            .animation(.spring(response: 0.5).delay(0.3), value: animateHeader)
        }
        .padding(.top, 16)
    }

    private var searchSection: some View {
            HStack(spacing: 10) {
                // ✅ Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(isSearchFocused ? .black : .secondary)
                        .font(.system(size: 15))
                        .animation(.easeInOut, value: isSearchFocused)

                    TextField("Search products, categories...", text: $viewModel.searchText)
                        .font(.system(size: 15))
                        .autocorrectionDisabled()
                        .focused($isSearchFocused)
                        .submitLabel(.search)

                    // ✅ Clear button
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.clearSearch()
                            isSearchFocused = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 15))
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemBackground))
                        .shadow(
                            color: isSearchFocused
                                ? .black.opacity(0.12)
                                : .black.opacity(0.04),
                            radius: isSearchFocused ? 8 : 4,
                            x: 0, y: 2
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isSearchFocused ? Color.black.opacity(0.3) : Color.clear,
                            lineWidth: 1
                        )
                )
                .animation(.easeInOut(duration: 0.2), value: isSearchFocused)

                // ✅ Sort button with menu
                Menu {
                    ForEach(HomeViewModel.SortOption.allCases, id: \.self) { option in
                        Button {
                            viewModel.applySort(option)
                        } label: {
                            HStack {
                                Label(option.rawValue, systemImage: option.icon)
                                if viewModel.currentSort == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(viewModel.currentSort == .featured ? Color.black : Color.black)
                            .frame(width: 46, height: 46)
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 2)

                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)

                        // ✅ Sort active indicator
                        if viewModel.currentSort != .featured {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 8, height: 8)
                                .offset(x: 14, y: -14)
                        }
                    }
                }
            }
            .animation(.spring(response: 0.3), value: viewModel.searchText)
        }

        // MARK: - Search Results
        private var searchResultsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                // Results header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Results for")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Text("\"\(viewModel.searchText)\"")
                            .font(.system(size: 18, weight: .bold))
                    }

                    Spacer()

                    Text("\(viewModel.searchResultCount) found")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                }

                if viewModel.displayedProducts.isEmpty {
                    // ✅ Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(.gray.opacity(0.4))

                        Text("No results found")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)

                        Text("Try a different keyword\nor browse by category")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Button {
                            viewModel.clearSearch()
                        } label: {
                            Text("Clear Search")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .clipShape(Capsule())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    // ✅ Results grid
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(viewModel.displayedProducts, id: \.title) { product in
                            FeaturedProductCard(
                                product: product,
                                selectedProduct: $selectedProduct
                            )
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .animation(.spring(response: 0.4), value: viewModel.searchText)
                }
            }
        }
    private var heroBannerSection: some View {
        HeroBannerView()
    }

    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
//            sectionHeader(title: "Categories", action: "See All")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categories) { category in
                        categoryChip(category)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private func categoryChip(_ category: HomeCategory) -> some View {
        let isSelected = viewModel.selectedCategory == category.name

        return Button {
            withAnimation(.spring(response: 0.3)) {
                viewModel.selectedCategory = category.name
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(category.name)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.black : Color(.systemBackground))
            .clipShape(Capsule())
            .shadow(
                color: isSelected ? .black.opacity(0.2) : .black.opacity(0.04),
                radius: isSelected ? 8 : 4,
                x: 0, y: 2
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Featured", action: "See All")

            if viewModel.isLoading {
                skeletonGrid
            } else if viewModel.filteredProducts.isEmpty {
                Text("No products in this category")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    ForEach(viewModel.filteredProducts, id: \.title) { product in
                        FeaturedProductCard(
                            product: product,
                            selectedProduct: $selectedProduct
                        )
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4), value: viewModel.selectedCategory)
            }
        }
    }
    
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Top Rated", action: "See All")

            VStack(spacing: 10) {
                ForEach(viewModel.trendingProducts.prefix(4), id: \.title) { product in
                    HomeProductRowView(
                        product: product,
                        selectedProduct: $selectedProduct
                    )
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
    }

    private var skeletonGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(0..<4, id: \.self) { _ in
                skeletonCard
            }
        }
    }

    private var skeletonCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
                .frame(height: 160)
                .shimmer()

            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(height: 12)
                .shimmer()

            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: 80, height: 12)
                .shimmer()
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func sectionHeader(title: String, action: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)

            Spacer()

            Button(action: {}) {
                Text(action)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }

    private func showToast(_ message: String) {
        withAnimation { toastMessage = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toastMessage = nil }
        }
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.4),
                        Color.white.opacity(0)
                    ],
                    startPoint: .init(x: phase - 0.3, y: 0.5),
                    endPoint: .init(x: phase + 0.3, y: 0.5)
                )
                .blendMode(.screen)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    phase = 1.3
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}

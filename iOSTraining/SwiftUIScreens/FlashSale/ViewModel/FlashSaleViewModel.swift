//
//  FlashSaleViewModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import Foundation
import Combine
import SwiftUI

class FlashSaleViewModel: ObservableObject {
    static let shared = FlashSaleViewModel()

    // MARK: - Published
    @Published var state: FlashSaleState = .countingDown
    @Published var countdownToSale: TimeInterval = FlashSaleConfig.countdownToSaleSeconds
    @Published var saleTimeRemaining: TimeInterval = FlashSaleConfig.saleDurationSeconds
    @Published var showModal: Bool = false
    @Published var showAllSales: Bool = false
    @Published var saleItems: [FlashSaleItem] = []
    @Published var userDismissedModal: Bool = false  // Track if user closed modal during active sale

    // MARK: - Sway animation
    @Published var swayOffset: CGFloat = 0
    @Published var isPulsing: Bool = false

    private var timer: AnyCancellable?
    private var swayTimer: AnyCancellable?

    // MARK: - Computed
    var formattedCountdownToSale: String { formatTime(countdownToSale) }
    var formattedSaleTimeRemaining: String { formatTime(saleTimeRemaining) }

    var isUrgent: Bool { saleTimeRemaining <= 10 && state == .saleActive }
    var isBannerClickable: Bool { state == .saleActive }

    var bannerLabel: String {
        switch state {
        case .countingDown: return "SALE IN"
        case .saleActive:   return "SALE ENDS"
        case .saleEnded:    return "SALE ENDED"
        }
    }

    var bannerTime: String {
        switch state {
        case .countingDown: return formattedCountdownToSale
        case .saleActive:   return formattedSaleTimeRemaining
        case .saleEnded:    return "00:00:00"
        }
    }

    // MARK: - Init
    init() { startCountdownToSale() }

    // MARK: - Phase 1: Countdown to Sale
    func startCountdownToSale() {
        state = .countingDown
        countdownToSale = FlashSaleConfig.countdownToSaleSeconds
        saleTimeRemaining = FlashSaleConfig.saleDurationSeconds
        isPulsing = false
        showModal = false
        stopSwayAnimation()

        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.countdownToSale > 0 {
                    self.countdownToSale -= 1
                } else {
                    self.timer?.cancel()
                    self.activateSale()
                }
            }
    }

    // MARK: - Phase 2: Sale is Active
    private func activateSale() {
        state = .saleActive
        isPulsing = true
        startSwayAnimation()
        startSaleCountdown()
        
        // ✅ Auto-show modal when sale starts
        userDismissedModal = false
        showModal = true
    }

    private func startSaleCountdown() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.saleTimeRemaining > 0 {
                    self.saleTimeRemaining -= 1
                } else {
                    self.timer?.cancel()
                    self.endSale()
                }
            }
    }

    // MARK: - Phase 3: Sale Ended → Loop
    private func endSale() {
        state = .saleEnded
        isPulsing = false
        stopSwayAnimation()
        showModal = false
        userDismissedModal = false  // Reset for next sale

        // ✅ Restart loop after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.startCountdownToSale()
        }
    }

    // MARK: - Sway Animation
    private func startSwayAnimation() {
        var direction: CGFloat = 1
        var elapsed: TimeInterval = 0
        let swayDuration: TimeInterval = 5

        swayTimer = Timer.publish(every: 0.6, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                elapsed += 0.6

                if elapsed <= swayDuration {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.swayOffset = direction * 8
                        direction *= -1
                    }
                } else {
                    self.stopSwayAnimation()
                }
            }
    }

    private func stopSwayAnimation() {
        swayTimer?.cancel()
        withAnimation { swayOffset = 0 }
    }

    // MARK: - Modal
    func openModal() {
        guard isBannerClickable else { return }
        showModal = true
        userDismissedModal = false  // Reset when manually opened
    }

    func dismissModal() {
        showModal = false
        // Mark that user dismissed during active sale
        if state == .saleActive {
            userDismissedModal = true
        }
    }

    // MARK: - Cart
    func addToCart(_ item: FlashSaleItem) {
        let cartItem = CartItem(
            title: item.product.title,
            price: item.salePrice,
            imageURL: item.product.images.first ?? "",
            quantity: 1,
            isSelected: false,
            isFlashSale: true,
            originalPrice: item.originalPrice,
            productId: item.product.id
        )
        CartViewModel.shared.addItem(cartItem)
    }
    
    // MARK: - Helper to check if product is on sale
    func getSaleInfo(forProductId productId: Int) -> (isOnSale: Bool, salePrice: Double?, originalPrice: Double?) {
        // Only return sale info if sale is currently active
        guard state == .saleActive else {
            return (false, nil, nil)
        }
        
        // Find the product in sale items
        if let saleItem = saleItems.first(where: { $0.product.id == productId }) {
            return (true, saleItem.salePrice, saleItem.originalPrice)
        }
        
        return (false, nil, nil)
    }

    // MARK: - Load
    func loadSaleItems(from products: [DummyProduct]) {
        saleItems = products
            .filter { $0.discountPercentage > 0 }
            .map { FlashSaleItem(product: $0) }
            .sorted { $0.product.discountPercentage > $1.product.discountPercentage }
    }

    // MARK: - Helper
    private func formatTime(_ time: TimeInterval) -> String {
        let h = Int(time) / 3600
        let m = (Int(time) % 3600) / 60
        let s = Int(time) % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}

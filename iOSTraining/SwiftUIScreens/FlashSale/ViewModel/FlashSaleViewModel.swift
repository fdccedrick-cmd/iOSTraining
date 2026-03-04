//
//  FlashSaleViewModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import Foundation
import Combine

class FlashSaleViewModel: ObservableObject {
    static let shared = FlashSaleViewModel()

    @Published var timeRemaining: TimeInterval = FlashSaleConfig.saleDurationSeconds
    @Published var isSaleActive: Bool = false
    @Published var showModal: Bool = false {
        didSet {
            NotificationCenter.default.post(
                name: NSNotification.Name("FlashSaleModalStateChanged"),
                object: nil,
                userInfo: ["isShowing": showModal]
            )
        }
    }
    @Published var showAllSales: Bool = false
    @Published var showBanner: Bool = true
    @Published var saleItems: [FlashSaleItem] = []

    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    var formattedTime: String {
        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var isUrgent: Bool {
        timeRemaining <= 60
    }

    init() {
        startCountdown()
    }

    func startCountdown() {
        timeRemaining = FlashSaleConfig.saleDurationSeconds
        isSaleActive = false
        showBanner = true

        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.cancel()
                    self.triggerFlashSale()
                }
            }
    }

    private func triggerFlashSale() {
        isSaleActive = true
        showBanner = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showModal = true
        }
    }

    func loadSaleItems(from products: [DummyProduct]) {
        saleItems = products
            .filter { $0.discountPercentage > 0}
            .map { FlashSaleItem(product: $0) }
            .sorted { $0.product.discountPercentage > $1.product.discountPercentage}
    }

    func addToCart(_ item: FlashSaleItem) {
        let cartItem = CartItem(
            title: item.product.title,
            price: item.salePrice,
            imageURL: item.product.images.first ?? "",
            quantity: 1
        )
        CartViewModel.shared.addItem(cartItem)
    }

    func dismissModal() {
        showModal = false
    }

    func restartSale() {
        showModal = false
        startCountdown()
    }
}


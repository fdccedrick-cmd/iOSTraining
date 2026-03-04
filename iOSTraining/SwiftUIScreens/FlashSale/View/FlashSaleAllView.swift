//
//  FlashSaleAllProduct.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct FlashSaleAllView: View {
    @ObservedObject var viewModel = FlashSaleViewModel.shared
    @Environment(\.dismiss) var dismiss
    @State private var toastMessage: String? = nil
    @State private var sortByPrice = false

    var sortedItems: [FlashSaleItem] {
        sortByPrice
            ? viewModel.saleItems.sorted { $0.salePrice < $1.salePrice }
            : viewModel.saleItems
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6).ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        HStack(spacing: 6) {
                            Text("⚡️")
                            Text("FLASH SALE")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(Color(hex: "FF4500"))
                                .tracking(2)
                        }

                        Text("Up to \(String(format: "%.0f%% off all items", viewModel.saleItems.map { $0.product.discountPercentage}.max() ?? 0)) off selected items ")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button {
                        withAnimation { sortByPrice.toggle() }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                HStack {
                    Text("\(viewModel.saleItems.count) items on sale")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)

                    Spacer()

                    if sortByPrice {
                        Text("Sorted by price")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "FF4500"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(sortedItems) { item in
                            FlashSaleProductCard(item: item) {
                                viewModel.addToCart(item)
                                showToast("🛒 \(item.product.title) added!")
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }

           
            if let message = toastMessage {
                Text("  \(message)  ")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
    }

    private func showToast(_ message: String) {
        withAnimation { toastMessage = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toastMessage = nil }
        }
    }
}

#Preview {
    FlashSaleAllView()
}

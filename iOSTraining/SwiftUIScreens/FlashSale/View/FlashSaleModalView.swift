//
//  FlashSaleModalView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct FlashSaleModalView: View {
    @ObservedObject var viewModel = FlashSaleViewModel.shared
    @State private var toastMessage: String? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { viewModel.dismissModal() }

            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.systemGray4))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text("⚡️")
                                .font(.system(size: 20))

                            Text("FLASH SALE")
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(Color(hex: "FF4500"))
                                .tracking(2)
                        }

                        Text("Up to \(String(format: "%.0f%%", viewModel.saleItems.map { $0.product.discountPercentage}.max() ?? 0)) off today only!")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button {
                        viewModel.showAllSales = true
                    } label: {
                        Text("Show All")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color(hex: "FF4500"))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 20)

                Divider()
                    .padding(.vertical, 12)

               
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(viewModel.saleItems.prefix(6)) { item in
                            FlashSaleProductCard(item: item) {
                                viewModel.addToCart(item)
                                showToast("🛒 \(item.product.title) added!")
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                .frame(maxHeight: 420)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .ignoresSafeArea(edges: .bottom)

           
            if let message = toastMessage {
                Text("  \(message)  ")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $viewModel.showAllSales) {
            FlashSaleAllView()
        }
    }

    private func showToast(_ message: String) {
        withAnimation { toastMessage = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toastMessage = nil }
        }
    }
}

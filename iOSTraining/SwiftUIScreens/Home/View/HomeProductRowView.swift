//
//  HomeProductRowView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct HomeProductRowView: View {
    let product: DummyProduct
    @Binding var selectedProduct: DummyProduct?

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)

                Text(product.category.capitalized)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    Text(String(format: "★ %.1f", product.rating))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.orange)

                    Text("•")
                        .foregroundColor(.secondary)

                    Text(product.availabilityStatus)
                        .font(.system(size: 11))
                        .foregroundColor(
                            product.availabilityStatus.lowercased().contains("in stock")
                                ? .green : .red
                        )
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(String(format: "₱%.2f", product.price))
                    .font(.system(size: 14, weight: .bold))

                Button {
                    // Check if product is on flash sale
                    let saleInfo = FlashSaleViewModel.shared.getSaleInfo(forProductId: product.id)
                    
                    let item = CartItem(
                        title: product.title,
                        price: saleInfo.isOnSale ? saleInfo.salePrice! : product.price,
                        imageURL: product.images.first ?? "",
                        quantity: 1,
                        isSelected: false,
                        isFlashSale: saleInfo.isOnSale,
                        originalPrice: saleInfo.isOnSale ? saleInfo.originalPrice : nil,
                        productId: product.id
                    )
                    CartViewModel.shared.addItem(item)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        .onTapGesture {
            selectedProduct = product 
        }
    }
}

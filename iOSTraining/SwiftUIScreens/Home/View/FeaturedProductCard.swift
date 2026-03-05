//
//  FeaturedProductCard.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct FeaturedProductCard: View {
    let product: DummyProduct
    @State private var isPressed = false
    @State private var imageLoaded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: product.images.first ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    imageLoaded = true
                                }
                            }
                    case .empty, .failure:
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24))
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 160)
                .clipped()
                .opacity(imageLoaded ? 1 : 0)
                .overlay(
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .opacity(imageLoaded ? 0 : 1)
                        .animation(.easeOut, value: imageLoaded)
                )

                if product.discountPercentage > 0 {
                    Text(String(format: "-%.0f%%", product.discountPercentage))
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding(10)
                }
                
                Button {
                    let item = FavoriteItem(
                        title: product.title,
                        price: product.price,
                        imageURL: product.images.first ?? "",
                        category: product.category,
                        rating: product.rating
                    )
                    FavoritesViewModel.shared.addItem(item)
                } label: {
                    Image(
                        systemName: FavoritesViewModel.shared.isItemFavorited(product.title)
                            ? "heart.fill" : "heart"
                    )
                    .font(.system(size: 14))
                    .foregroundColor(
                        FavoritesViewModel.shared.isItemFavorited(product.title)
                            ? .pink : .white
                    )
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(10)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                HStack {
                    Text(String(format: "₱%.2f", product.price))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)

                    Spacer()

                    Text(String(format: "★ %.1f", product.rating))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Button {
                    let item = CartItem(
                        title: product.title,
                        price: product.price,
                        imageURL: product.images.first ?? "",
                        quantity: 1
                    )
                    CartViewModel.shared.addItem(item)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 11))
                        Text("Add")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation { isPressed = false }
            }
        }
    }
}

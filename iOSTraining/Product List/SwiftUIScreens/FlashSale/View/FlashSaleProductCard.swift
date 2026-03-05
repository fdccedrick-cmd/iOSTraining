//
//  FlashSaleProductCard.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import SwiftUI

struct FlashSaleProductCard: View {
    let item: FlashSaleItem
    let onAddToCart: () -> Void
    
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: item.product.images.first ?? "")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.12))
                    }
                    .frame(height: 140)
                    .clipped()

                    Text(item.discountLabel)
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "FF4500"))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding(8)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.product.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    HStack(alignment: .bottom, spacing: 6) {
                        Text(item.formattedSalePrice)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "FF4500"))

                        Text(item.formattedOriginalPrice)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .strikethrough()
                    }

                    Button(action: onAddToCart) {
                        HStack(spacing: 4) {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 11))
                            Text("Add to Cart")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color(hex: "FF4500"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(10)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
        }
    }

//#Preview {
//    FlashSaleProductCard()
//}

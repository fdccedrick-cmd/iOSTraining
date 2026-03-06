//
//  FavoritesRowView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/3/26.
//

import SwiftUI

struct FavoritesRowView: View {
    let item: FavoriteItem
    let onRemove: () -> Void
    let onAddToCart: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                
                AsyncImage(url: URL(string: item.imageURL)) {image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.12))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading,spacing: 4) {
                            //Category badge
                            Text(item.category.uppercased())
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            
                            Text(item.title)
                                .font(.system(size:15, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Button(action: onRemove) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.pink)
                        }
                    }
                    
                    HStack {
                        
                        Text(item.formattedPrice)
                            .font(.system(size:16, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(item.formattedRating)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Button(action: onAddToCart) {
                            HStack(spacing: 4) {
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 11))
                                
                                Text("Add")
                                    .font(.system(size: 12, weight:. semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black)
                            .clipShape(Capsule())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(16)
            
            Divider()
                .padding(.horizontal, 16)
        }
    }
}
//#Preview {
//    FavoritesRowView(item: 1, onRemove: <#T##() -> Void#>, onAddToCart: <#T##() -> Void#>)
//}



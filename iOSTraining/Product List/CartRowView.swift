//
//  CartRowView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import SwiftUI

struct CartRowView: View {
    let item: CartItem
    let index: Int
    @ObservedObject var viewModel: CartViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 14){
                
                // Checkbox
                Button {
                    viewModel.toggleItemSelection(at: index)
                } label: {
                    Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(item.isSelected ? .black : .gray)
                }
                
                //Image
                AsyncImage(url: URL(string: item.imageURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.12))
                }
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            // Flash Sale Badge
                            if item.isFlashSale {
                                HStack(spacing: 4) {
                                    Image(systemName: "bolt.fill")
                                        .font(.system(size: 9))
                                    Text("FLASH SALE")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    LinearGradient(
                                        colors: [Color(red: 1.0, green: 0.27, blue: 0.0), Color(red: 1.0, green: 0.42, blue: 0.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                            }
                        }
                        
                        Spacer()
                        
                        //Trash
                        Button {
                            viewModel.removeItem(at: index)
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    
                    }
                    
                    Text(item.title)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Price with strikethrough for flash sale items
                    if item.isFlashSale, let originalPrice = item.formattedOriginalPrice {
                        HStack(spacing: 8) {
                            Text(item.formattedPrice)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color(red: 1.0, green: 0.27, blue: 0.0))
                            
                            Text(originalPrice)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                                .strikethrough(true, color: .secondary)
                        }
                    } else {
                        Text(item.formattedPrice)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.primary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button {
                            viewModel.decreaseQuantity(at: index)
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 13, weight: .medium))
                                .frame(width: 28, height: 28)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                                .foregroundColor(.primary)
                        }
                        
                        Text("\(item.quantity)")
                            .font(.system(size: 15, weight: .medium))
                            .frame(minWidth: 20)
                        
                        Button {
                            viewModel.increaseQuantity(at: index)
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 13, weight: .medium))
                                .frame(width: 28, height: 28)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                                .foregroundColor(.primary)
                        }
                        
                       
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




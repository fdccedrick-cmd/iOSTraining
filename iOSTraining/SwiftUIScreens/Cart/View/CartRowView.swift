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
                
                //Image
                AsyncImage(url: URL(string: item.imageURL)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.12))
                }
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Text(item.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
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




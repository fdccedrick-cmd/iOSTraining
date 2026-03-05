//
//  GridTraining.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/3/26.
//

import SwiftUI
import Combine

struct GridTraining: View {
    @StateObject var viewModel: GridViewModel = .init()
    //
    
    private var items: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    
    var body: some View {
        ZStack{
            ScrollView {
                LazyVGrid(columns: items ){
                    ForEach(viewModel.allData, id: \.self){ item in
                        Text("\(item)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.red)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .onTapGesture {
                                viewModel.getTextString(item: "Print Item: -> \(item)")
                            }
                        
                    }
                }
                LazyVGrid(columns: items ){
                    ForEach(1...50, id: \.self){
                        Text("\($0)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.red)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                    }
                }
            }
            .onAppear {
                
            }
        }
        
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//
final class GridViewModel: ObservableObject {
    
    @Published var text: String = "Hello World"
    @Published var allData: [Int] = [1,2,3,4,5,6,7,8,9]
    func testing() {
        print(222)
    }
    func getTextString(item: String){
        print(item)
    }
   
    
    
}
#Preview {
    GridTraining()
}

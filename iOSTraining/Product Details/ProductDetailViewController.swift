//
//  ProductDetailViewCellViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/25/26.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // Product property to receive data from ProductListViewController
    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigation title to the product name
        if let product = product {
            self.title = product.name
            
            // You can also use the product data here to populate your detail view
            print("Product Details:")
            print("Name: \(product.name)")
            print("Price: ₱\(product.price)")
            print("Description: \(product.description)")
        }

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ProductDetailViewCellViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/25/26.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productDetailImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    
    @IBOutlet weak var productPrice: UILabel!
    

    @IBOutlet weak var productDescription: UILabel!
    
    
    // Product property to receive data from ProductListViewController
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
                self.title = product.name
                
                // Display product name and price
                productName.text = product.name
                productPrice.text = "₱\(product.price)"
                productDescription.text = product.description
                displayProductImage()
            }
        
        // Do any additional setup after loading the view.
    }
    private func displayProductImage() {
        guard let product = product, let imageName = product.image else {
            print("No image available for this product.")
            return 
        }
        
        // Load and display the product image
        if let image = UIImage(named: imageName) {
            productDetailImage.image = image
            productDetailImage.contentMode = .scaleAspectFit
        } else {
            print("Image named \(imageName) could not be loaded.")
            productDetailImage.image = nil
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
}

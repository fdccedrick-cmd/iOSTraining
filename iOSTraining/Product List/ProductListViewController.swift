//
//  ProductListViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/25/26.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var productSearch: UISearchBar!
    
    private let cellIdentifier = "ProductListTableViewCell"
    var products: [Product] = [
        Product(image: "monitor", name: "Computer Monitor", price: 2000, description: "High-resolution display with stunning color accuracy and wide viewing angles"),
        Product(image: "keyboard", name: "Keyboard", price: 1000, description: "Mechanical keyboard with RGB lighting and customizable keys"),
        Product(image: "tshirt", name: "T-Shirt", price: 500, description: "Premium cotton fabric with comfortable fit and modern design"),
        Product(image: "headphone", name: "Headphone", price: 3000, description: "Noise-cancelling headphones with premium sound quality"),
        Product(image: "earbuds", name: "Wireless Earbuds", price: 1500, description: "True wireless earbuds with long battery life and crystal clear audio"),
        Product(image: "tshirt", name: "T-Shirt", price: 500, description: "Premium cotton fabric with comfortable fit and modern design"),
        Product(image: "headphone", name: "Headphone", price: 3000, description: "Noise-cancelling headphones with premium sound quality"),
//        Product(image: "earbuds", name: "Wireless Earbuds", price: 1500, description: "True wireless earbuds with long battery life and crystal clear audio")
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Products"
        
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Modern cell height configuration
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.separatorStyle = .none // Remove separators for card style
        tableView.backgroundColor = .systemGroupedBackground
        
        // Do any additional setup after loading the view.
        
    }
    @objc func didTapSort() {
        print(#function)
    }

//    @IBAction func didTapDismiss(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
//
//    @IBAction func didTapGoBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProductListTableViewCell {
            cell.product = products[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("YOU TAPPED PRODUCT INDEX \(indexPath.row)")
        
        // Get the selected product
        let selectedProduct = products[indexPath.row]
        
        // Create detail view controller and pass the product
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = selectedProduct
        
        // Navigate to detail view
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    
    
}

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
    
    
    
    @IBOutlet weak var productSort: UIButton!
    
    var filteredProducts: [Product] = []
    var isSearching: Bool = false
    var currentSortOption: SortOption = .featured
    
    enum SortOption {
        case featured
        case nameAZ
        case priceLowToHigh
        case topRated
    }
    
    
    private var originalProducts: [Product] = []
    private let cellIdentifier = "ProductListTableViewCell"
//    var products: [Product] = [
//        Product(image: "monitor", name: "Computer Monitor", price: 2000, description: "This monitor is designed to deliver a smooth and immersive viewing experience with a high-resolution display that produces sharp details and vibrant colors, making it ideal for work, gaming, and entertainment, while its fast refresh rate and low response time reduce motion blur for fluid visuals, and its slim, modern design with adjustable stand ensures comfort during long hours of use, complemented by multiple connectivity options for easy setup with laptops, PCs, and consoles."),
//        Product(image: "keyboard", name: "Keyboard", price: 1000, description: "Mechanical keyboard with RGB lighting and customizable keys"),
//        Product(image: "tshirt", name: "T-Shirt", price: 500, description: "Premium cotton fabric with comfortable fit and modern design"),
//        Product(image: "headphone", name: "Headphone", price: 3000, description: "Noise-cancelling headphones with premium sound quality"),
//        Product(image: "earbuds", name: "Wireless Earbuds", price: 1500, description: "True wireless earbuds with long battery life and crystal clear audio"),
//        Product(image: "tshirt", name: "T-Shirt", price: 500, description: "Premium cotton fabric with comfortable fit and modern design"),
//        Product(image: "headphone", name: "Headphone", price: 3000, description: "Noise-cancelling headphones with premium sound quality"),
////        Product(image: "earbuds", name: "Wireless Earbuds", price: 1500, description: "True wireless earbuds with long battery life and crystal clear audio")
//        
//    ]
    var products: [Product] = [
        Product(
            images: ["monitor", "keyboard", "headphone"],
            name: "Computer Monitor",
            price: 2000,
            description: "This monitor is designed to deliver a smooth and immersive viewing experience..."
        ),
        Product(
            images: ["keyboard", "monitor", "earbuds"],
            name: "Keyboard",
            price: 1000,
            description: "Mechanical keyboard with RGB lighting and customizable keys"
        ),
        Product(
            images: ["tshirt", "headphone", "keyboard"],
            name: "T-Shirt",
            price: 500,
            description: "Premium cotton fabric with comfortable fit and modern design"
        ),
        Product(
            images: ["headphone", "earbuds", "monitor"],
            name: "Headphone",
            price: 3000,
            description: "Noise-cancelling headphones with premium sound quality"
        ),
        Product(
            images: ["earbuds", "headphone", "tshirt"],
            name: "Wireless Earbuds",
            price: 1500,
            description: "True wireless earbuds with long battery life and crystal clear audio"
        ),
        Product(
            images: ["tshirt", "earbuds", "keyboard"],
            name: "T-Shirt",
            price: 500,
            description: "Premium cotton fabric with comfortable fit and modern design"
        ),
        Product(
            images: ["headphone", "tshirt", "monitor"],
            name: "Headphone",
            price: 3000,
            description: "Noise-cancelling headphones with premium sound quality"
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Products"
        originalProducts = products
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductListTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Modern cell height configuration
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.separatorStyle = .none // Remove separators for card style
        tableView.backgroundColor = .systemGroupedBackground
        
        productSearch.delegate = self
        // Do any additional setup after loading the view.
        setupSortButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        productSort.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        
    }
    @objc func didTapSort() {
        
    }
    
    private func setupSortButton() {
        let featured = UIAction(
            title: "Featured",
            image: UIImage(systemName: "sparkles"),
            state: currentSortOption == .featured ? .on : .off
        ) { _ in
            self.applySortOption(.featured)
        }

        let nameAZ = UIAction(
            title: "Name (A-Z)",
            image: UIImage(systemName: "textformat.abc"),
            state: currentSortOption == .nameAZ ? .on : .off
        ) { _ in
            self.applySortOption(.nameAZ)
        }

        let priceLowHigh = UIAction(
            title: "Price (Low to High)",
            image: UIImage(systemName: "tag.fill"),
            state: currentSortOption == .priceLowToHigh ? .on : .off
        ) { _ in
            self.applySortOption(.priceLowToHigh)
        }

        let topRated = UIAction(
            title: "Top Rated",
            image: UIImage(systemName: "star.fill"),
            state: currentSortOption == .topRated ? .on : .off
        ) { _ in
            self.applySortOption(.topRated)
        }

        let menu = UIMenu(
            title: "Sort Products",
            options: .displayInline,
            children: [featured, nameAZ, priceLowHigh, topRated]
        )

        productSort.menu = menu
        productSort.showsMenuAsPrimaryAction = true
    }

    private func applySortOption(_ option: SortOption) {
        currentSortOption = option

        switch option {
        case .featured:
            // Static — reset to original order
           
            products = originalProducts

        case .nameAZ:
            products.sort { $0.name < $1.name }

        case .priceLowToHigh:
            products.sort { $0.price < $1.price }

        case .topRated:
            break // Static — no reordering
        }

        if isSearching, let text = productSearch.text {
            filteredProducts = products.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
        }

        // Rebuild menu to update checkmarks
        setupSortButton()
        tableView.reloadData()
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
        return isSearching ? filteredProducts.count : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProductListTableViewCell {
            cell.product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = selectedProduct
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    
}
extension ProductListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredProducts = []
        } else {
            isSearching = true
            filteredProducts = products.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredProducts = []
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // dismisses keyboard on Search tap
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

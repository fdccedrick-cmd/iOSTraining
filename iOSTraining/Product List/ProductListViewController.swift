//
//  ProductListViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/25/26.
//

import UIKit


protocol ProductListViewDelegate: AnyObject {
    
    func userHasTriggerSomething()
    
    func didTapProductName(_ product: Product)
}

class ProductListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var productSearch: UISearchBar!
    
    
    
    @IBOutlet weak var productSort: UIButton!
    
    var filteredProducts: [Product] = []
    var isSearching: Bool = false
    var currentSortOption: SortOption = .featured
    
    
    var dummyProducts: [DummyProduct] = []
    var filteredDummyProducts: [DummyProduct] = []
    
    
    enum SortOption {
        case featured
        case nameAZ
        case priceLowToHigh
        case topRated
    }
    
    private var originalProducts: [Product] = []
    private let cellIdentifier = "ProductListTableViewCell"
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
//    func fetchProducts(completionHandler: (() -> Void)? = nil) {
//        guard let url = URL(string: "https://dummyjson.com/products") else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                completionHandler?()
//                return
//            }
//            guard let data = data else {
//                print("No data")
//                completionHandler?()
//                return
//            }
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            do {
//                let productResponse = try decoder.decode(ProductResponse.self, from: data)
//                guard let firstProduct = productResponse.products.first else{
//                    completionHandler?()
//                    return
//                }
//                print("First Product: ", firstProduct.id , firstProduct.title, firstProduct.price)
//            }catch{
//                print(error.localizedDescription)
//            }
//            completionHandler?()
//        }.resume()
//    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        originalProducts = products
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        productSearch.delegate = self
        setupSortButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        productSort.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .all
        
        NetworkManager.shared.delegate = self
        NetworkManager.shared.fetchProducts()
            
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc func onRefresh() {
        NetworkManager.shared.fetchProducts()
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
//        return isSearching ? filteredProducts.count : products.count
        return isSearching ? filteredDummyProducts.count : dummyProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProductListTableViewCell {
//            cell.product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
//            return cell
//        }
//        return UITableViewCell()
        
        guard let cell = tableView.dequeueReusableCell(
                   withIdentifier: cellIdentifier
               ) as? ProductListTableViewCell else {
                   return UITableViewCell()
               }

               let product = isSearching
                   ? filteredDummyProducts[indexPath.row]
                   : dummyProducts[indexPath.row]

               // Map DummyProduct → your cell
               cell.dummyProduct = product

               return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedProduct = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
//        let productDetailVC = ProductDetailViewController()
//        productDetailVC.delegate = self
//        productDetailVC.product = selectedProduct
//        productDetailVC.delegate = self
//        self.navigationController?.pushViewController(productDetailVC, animated: true)
        let selected = isSearching
                    ? filteredDummyProducts[indexPath.row]
                    : dummyProducts[indexPath.row]

                let productDetailVC = ProductDetailViewController()
                productDetailVC.dummyProduct = selected // pass DummyProduct instead
                self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    
}
extension ProductListViewController: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            isSearching = false
//            filteredProducts = []
//        } else {
//            isSearching = true
//            filteredProducts = products.filter { product in
//                product.name.lowercased().contains(searchText.lowercased())
//            }
//        }
//        tableView.reloadData()
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        isSearching = false
//        filteredProducts = []
//        tableView.reloadData()
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                isSearching = false
                filteredDummyProducts = []
            } else {
                isSearching = true
                filteredDummyProducts = dummyProducts.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            }
            tableView.reloadData()
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            isSearching = false
            filteredDummyProducts = []
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
    
    // Swipe LEFT → Add to Cart
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let addToCartAction = UIContextualAction(style: .normal, title: "Cart") { (_, _, completion) in
            
            let product = self.isSearching
                ? self.filteredProducts[indexPath.row]
                : self.products[indexPath.row]

            print("🛒 Added to cart: \(product.name)")
            
            // TODO: call your addToCart logic here
            
            completion(true)
        }

        addToCartAction.backgroundColor = .systemGreen
        addToCartAction.image = UIImage(systemName: "cart.fill")

        return UISwipeActionsConfiguration(actions: [addToCartAction])
    }
    
    // Swipe RIGHT → Add to Favorites
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (_, _, completion) in
            
            let product = self.isSearching
                ? self.filteredProducts[indexPath.row]
                : self.products[indexPath.row]

            print("❤️ Added to favorites: \(product.name)")
            
            // TODO: call your addToFavorites logic here
            
            completion(true)
        }

        favoriteAction.backgroundColor = .systemPink
        favoriteAction.image = UIImage(systemName: "heart.fill")

        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}

extension ProductListViewController: ProductListViewDelegate {
    func userHasTriggerSomething() {
        print("User triggered something in the product list view")
    }
    func didTapProductName(_ product: Product) {
        // For now, just log and optionally navigate back to list or present details
        print("Tapped product name: \(product.name)")
    }
}

extension ProductListViewController: NetworkManagerDelegate {

    func didFetchProducts(_ products: [DummyProduct]) {
        dummyProducts = products
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    func didFailWithError(_ error: Error) {
        tableView.refreshControl?.endRefreshing()
        print("Failed to fetch products: \(error.localizedDescription)")
        // Optionally show an alert to the user
    }
}

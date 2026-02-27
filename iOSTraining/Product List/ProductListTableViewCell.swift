//
//  ProductListTableTableViewCell.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/25/26.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    private var isUISetup = false
    private var gradientLayer: CAGradientLayer?
    private var imageBackgroundGradient: CAGradientLayer?
    
    // Programmatically created UI elements
    private let categoryStackView = UIStackView()
    private let ratingStockStackView = UIStackView()
    private let ratingLabel = UILabel()
    private let stockLabel = UILabel()
    private let gradientBackgroundView = UIView()
    
//    var product: Product? {
//        didSet {
//            displayData()
//        }
//    }
    
    var dummyProduct: DummyProduct? {
        didSet {
            displayData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add margin between cells for card effect
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        
        if !isUISetup {
            setupUI()
            isUISetup = true
        }
        
        // Update gradient frame when bounds change
        imageBackgroundGradient?.frame = gradientBackgroundView.bounds
    }
    
    private func setupUI() {
        guard productImageView != nil, productNameLabel != nil, productPriceLabel != nil, productDescription != nil else {
            return
        }
        
        // Card-style container
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = .systemBackground
        
        // Add gradient background container behind the image
        gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(gradientBackgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            gradientBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientBackgroundView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        // Create green-to-teal gradient layer
        if imageBackgroundGradient == nil {
            let gradient = CAGradientLayer()
            // Green (#10B981) to Teal (#14B8A6) gradient
            gradient.colors = [
                UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1.0).cgColor,
                UIColor(red: 20/255, green: 184/255, blue: 166/255, alpha: 1.0).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.frame = CGRect(x: 0, y: 0, width: 120, height: contentView.bounds.height)
            gradient.cornerRadius = 12
            gradient.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] // Only round left corners
            gradientBackgroundView.layer.addSublayer(gradient)
            imageBackgroundGradient = gradient
        }
        
        // Image styling - rounded square with gradient overlay
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.backgroundColor = .clear
        
        // Name label styling - will be pushed down by category badges
        productNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        productNameLabel.textColor = .label
        productNameLabel.numberOfLines = 1
        
        // Description label styling
        productDescription.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        productDescription.textColor = .secondaryLabel
        productDescription.numberOfLines = 2
        
        // Price label styling
        productPriceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        productPriceLabel.textColor = .label
        
        // Setup category badges ABOVE the name label
        setupCategoryBadgesLayout()
        
        // Setup rating and stock BELOW the price label
        setupRatingAndStockLayout()
    }
    
    
    private func setupCategoryBadgesLayout() {
        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 6
        categoryStackView.alignment = .leading
        categoryStackView.distribution = .fillProportionally
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryStackView)
        
        NSLayoutConstraint.activate([
            categoryStackView.bottomAnchor.constraint(equalTo: productNameLabel.topAnchor, constant: -6),
            categoryStackView.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
            categoryStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // ✅ Layout only — called once in setupUI
    private func setupRatingAndStockLayout() {
        ratingStockStackView.axis = .horizontal
        ratingStockStackView.spacing = 12
        ratingStockStackView.alignment = .center
        ratingStockStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingStockStackView)
        
        ratingLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        ratingLabel.textColor = .label
        
        stockLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        ratingStockStackView.addArrangedSubview(ratingLabel)
        ratingStockStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            ratingStockStackView.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8),
            ratingStockStackView.leadingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor),
            ratingStockStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: ratingStockStackView.bottomAnchor, constant: 12)
        ])
    }
//    private func setupCategoryBadges() {
//        categoryStackView.axis = .horizontal
//        categoryStackView.spacing = 6
//        categoryStackView.alignment = .leading
//        categoryStackView.distribution = .fillProportionally
//        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(categoryStackView)
//        
//        // Static badges (hardcoded for design)
//        let categories = ["FEATURED", "WEARABLE"]
//        
//        for category in categories {
//            let badge = createBadge(text: category)
//            categoryStackView.addArrangedSubview(badge)
//        }
//        
//        // Position badges ABOVE the existing name label from storyboard
//        NSLayoutConstraint.activate([
//            categoryStackView.bottomAnchor.constraint(equalTo: productNameLabel.topAnchor, constant: -6),
//            categoryStackView.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
//            categoryStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
//            categoryStackView.heightAnchor.constraint(equalToConstant: 20)
//        ])
//    }
    private func setupCategoryBadges(category: String, discountPercentage: Double) {
        // Clear old badges first (important for cell reuse)
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let categoryBadge = createBadge(
            text: category.uppercased(),
            color: .systemGray5,
            textColor: .secondaryLabel
        )
        categoryStackView.addArrangedSubview(categoryBadge)

        // Only show discount badge if discount > 0
        if discountPercentage > 0 {
            let discountBadge = createBadge(
                text: String(format: "-%.0f%%", discountPercentage),
                color: UIColor.systemRed.withAlphaComponent(0.15),
                textColor: .systemRed
            )
            categoryStackView.addArrangedSubview(discountBadge)
        }
    }
    private func createBadge(text: String, color: UIColor, textColor: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = color
        container.layer.cornerRadius = 4
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -3),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            container.heightAnchor.constraint(equalToConstant: 20)
        ])
        return container
    }
//    private func createBadge(text: String) -> UIView {
//        let container = UIView()
//        container.backgroundColor = UIColor.systemGray5
//        container.layer.cornerRadius = 4
//        container.translatesAutoresizingMaskIntoConstraints = false
//        
//        let label = UILabel()
//        label.text = text
//        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
//        label.textColor = .secondaryLabel
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        container.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 3),
//            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -3),
//            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
//            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
//            container.heightAnchor.constraint(equalToConstant: 20)
//        ])
//        
//        return container
//    }
//    
//    private func setupRatingAndStock() {
//        // Create horizontal stack for rating and stock
//        ratingStockStackView.axis = .horizontal
//        ratingStockStackView.spacing = 12
//        ratingStockStackView.alignment = .center
//        ratingStockStackView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(ratingStockStackView)
//        
//        // Rating label with star
//        ratingLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
//        ratingLabel.textColor = .label
//        ratingLabel.text = "★ 4.9 • 1.1K"
//        
//        // Stock label
//        stockLabel.text = "In Stock"
//        stockLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        stockLabel.textColor = .systemGreen
//        
//        ratingStockStackView.addArrangedSubview(ratingLabel)
//        ratingStockStackView.addArrangedSubview(stockLabel)
//        
//        // Position BELOW the price label from storyboard
//        NSLayoutConstraint.activate([
//            ratingStockStackView.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8),
//            ratingStockStackView.leadingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor),
//            ratingStockStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
//            // Add bottom constraint to ensure cell height includes this element
//            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: ratingStockStackView.bottomAnchor, constant: 12)
//        ])
//    }
    private func setupRatingAndStock(rating: Double, availabilityStatus: String) {
        ratingLabel.text = String(format: "★ %.1f", rating)

        stockLabel.text = availabilityStatus
        stockLabel.textColor = availabilityStatus.lowercased().contains("in stock")
            ? .systemGreen
            : .systemRed
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    private func displayData() {
//        guard let product = dummyProduct else { return }
//
//        productNameLabel.text = product.title
//        productDescription.text = product.description
//        productPriceLabel.text = String(format: "₱%.2f", product.price)
//
//        // Load first image from URL
//        if let urlString = product.images.first, let url = URL(string: urlString) {
//            loadImage(from: url)
//        } else {
//            productImageView.image = UIImage(systemName: "photo")
//        }
//    }
    private func displayData() {
        guard let product = dummyProduct else { return }

        productNameLabel.text = product.title
        productPriceLabel.text = String(format: "₱%.2f", product.price)
        productDescription.text = product.description

        // Load image from URL
        if let urlString = product.images.first, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }

        // ✅ Wire real data into existing UI
        setupCategoryBadges(
            category: product.category,
            discountPercentage: product.discountPercentage
        )
        setupRatingAndStock(
            rating: product.rating,
            availabilityStatus: product.availabilityStatus
        )
    }

    private func loadImage(from url: URL) {
        productImageView.image = UIImage(systemName: "photo") // placeholder

        NetworkManager.shared.fetchImage(from: url) { [weak self] image in
            self?.productImageView.image = image ?? UIImage(systemName: "photo")
        }
    }
    
}

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
    
    // Programmatically created UI elements
    private let categoryStackView = UIStackView()
    private let ratingStockStackView = UIStackView()
    private let ratingLabel = UILabel()
    private let stockLabel = UILabel()
    
    var product: Product? {
        didSet {
            displayData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
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
        
        // Image styling - rounded square with gradient overlay
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.backgroundColor = .systemGray5
        
        // Add subtle gradient overlay to image
        if gradientLayer == nil {
            let gradient = CAGradientLayer()
            gradient.colors = [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.15).cgColor
            ]
            gradient.locations = [0.0, 1.0]
            gradient.frame = productImageView.bounds
            gradient.cornerRadius = 12
            productImageView.layer.addSublayer(gradient)
            gradientLayer = gradient
        }
        
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
        setupCategoryBadges()
        
        // Setup rating and stock BELOW the price label
        setupRatingAndStock()
    }
    
    private func setupCategoryBadges() {
        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 6
        categoryStackView.alignment = .leading
        categoryStackView.distribution = .fillProportionally
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryStackView)
        
        // Static badges (hardcoded for design)
        let categories = ["FEATURED", "WEARABLE"]
        
        for category in categories {
            let badge = createBadge(text: category)
            categoryStackView.addArrangedSubview(badge)
        }
        
        // Position badges ABOVE the existing name label from storyboard
        NSLayoutConstraint.activate([
            categoryStackView.bottomAnchor.constraint(equalTo: productNameLabel.topAnchor, constant: -6),
            categoryStackView.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
            categoryStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func createBadge(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray5
        container.layer.cornerRadius = 4
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .secondaryLabel
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
    
    private func setupRatingAndStock() {
        // Create horizontal stack for rating and stock
        ratingStockStackView.axis = .horizontal
        ratingStockStackView.spacing = 12
        ratingStockStackView.alignment = .center
        ratingStockStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingStockStackView)
        
        // Rating label with star
        ratingLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        ratingLabel.textColor = .label
        ratingLabel.text = "★ 4.9 • 1.1K"
        
        // Stock label
        stockLabel.text = "In Stock"
        stockLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        stockLabel.textColor = .systemGreen
        
        ratingStockStackView.addArrangedSubview(ratingLabel)
        ratingStockStackView.addArrangedSubview(stockLabel)
        
        // Position BELOW the price label from storyboard
        NSLayoutConstraint.activate([
            ratingStockStackView.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8),
            ratingStockStackView.leadingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor),
            ratingStockStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
            // Add bottom constraint to ensure cell height includes this element
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: ratingStockStackView.bottomAnchor, constant: 12)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func displayData() {
        productNameLabel.text = product?.name
        
        // Format price without decimal places for cleaner look
        if let price = product?.price {
            let formattedPrice = String(format: "₱%.0f", price)
            productPriceLabel.text = formattedPrice
        } else {
            productPriceLabel.text = "₱0"
        }
        
        // Display description from product model
        productDescription.text = product?.description
        
        if let imageName = product?.image {
            productImageView.image = UIImage(named: imageName)
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
    }
    
}

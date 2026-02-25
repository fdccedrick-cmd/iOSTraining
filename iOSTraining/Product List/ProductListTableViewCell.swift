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
    @IBOutlet weak var containerView: UIView!
    
    var product: Product? {
        didSet {
            displayData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator // pang arrow
        self.selectionStyle = .none // Remove selection highlight for cleaner look
        self.backgroundColor = .clear // Transparent background for card effect
        setupUI()
    }
    
    private func setupUI() {
        // Card-style container
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.backgroundColor = .systemBackground
        
        // Image styling
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        
        // Name label styling
        productNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        productNameLabel.textColor = .label
        productNameLabel.numberOfLines = 2
        
        // Price label styling
        productPriceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        productPriceLabel.textColor = .systemGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func displayData() {
        productNameLabel.text = product?.name
        
        // Format price with currency
        if let price = product?.price {
            productPriceLabel.text = "₱\(String(format: "%.2f", price))"
        } else {
            productPriceLabel.text = "₱0.00"
        }
        
        if let imageName = product?.image {
            productImageView.image = UIImage(named: imageName)
        } else {
            productImageView.image = UIImage(systemName: "photo") // Placeholder image if no image name is provided
            
        }
    }
    
}

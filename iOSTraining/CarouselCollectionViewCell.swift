//
//  CarouselCollectionViewCell.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/26/26.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "CarouselCollectionViewCell"
        
        override func awakeFromNib() {
            super.awakeFromNib()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        
        func configure(with imageName: String) {
            imageView.image = UIImage(named: imageName)
        }
    
//testtt
    

}

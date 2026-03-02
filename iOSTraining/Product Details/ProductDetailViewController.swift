//
//  ProductDetailViewCellViewController.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 2/25/26.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productWearableLabel: UILabel!
    @IBOutlet weak var productFeaturedButton: UILabel!

    
    @IBOutlet weak var buyNowButton: UIButton!
    
    
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    weak var delegate: ProductListViewDelegate?
    
    
    var dummyProduct: DummyProduct?
    var product: Product?
    private var selectedImageURL: URL?
    
    
    @objc private func didTapProductName() {
        delegate?.userHasTriggerSomething()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageTapGesture()

        setupCarousel()
        setupAppearance()
        populateData()
        
        carouselCollectionView.isScrollEnabled = true
        carouselCollectionView.isUserInteractionEnabled = true
        scrollView.canCancelContentTouches = false

        // Add tap gesture to product name label
        productName.isUserInteractionEnabled = true
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(didTapProductName))
        productName.addGestureRecognizer(nameTap)

//        if let product = product {
//            self.title = product.name
//            productName.text = product.name
//            productPrice.text = "₱\(product.price)"
//            productDescription.text = product.description
//            pageControl.numberOfPages = product.images.count
//            pageControl.currentPage = 0
//            pageControl.currentPageIndicatorTintColor = .systemGreen
//            pageControl.pageIndicatorTintColor = .systemGray3
//            carouselCollectionView.reloadData()
//        }
        if let product = dummyProduct {
                    self.title = product.title
                    productName.text = product.title
                    productPrice.text = String(format: "₱%.2f", product.price)
                    productDescription.text = product.description
                    pageControl.numberOfPages =  product.paddedImages.count
                    pageControl.currentPage = 0
                    pageControl.currentPageIndicatorTintColor = .systemGreen
                    pageControl.pageIndicatorTintColor = .systemGray3
                    carouselCollectionView.reloadData()
                }
        

        pageControl.addTarget(self,
            action: #selector(pageControlTapped),
            for: .valueChanged)
        
        // Style the back button color to match your theme
            navigationController?.navigationBar.tintColor = .systemTeal
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProductName))
        productDescription.isUserInteractionEnabled = true
        productDescription.addGestureRecognizer(tapGesture)
                                                                                                
   
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        carouselCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    private func setupImageTapGesture() {
        // Tap is on the carouselCollectionView since it holds the images
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
        carouselCollectionView.addGestureRecognizer(tap)
        carouselCollectionView.isUserInteractionEnabled = true
    }

    @objc private func didTapProductImage() {
        // Get current visible image URL based on current page
        let currentIndex = pageControl.currentPage
        guard let urlString = dummyProduct?.paddedImages[currentIndex],
              let url = URL(string: urlString) else { return }
        
        presentImageViewer(url)
    }

    private func presentImageViewer(_ url: URL) {
        // Fullscreen overlay
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        overlayView.alpha = 0
        overlayView.tag = 999

        // Image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo") // placeholder

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissImageViewer), for: .touchUpInside)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        closeButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)

        overlayView.addSubview(imageView)
        overlayView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: 0.6),

            closeButton.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 55),
            closeButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20)
        ])

        // Add to window so it covers everything including nav bar
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else { return }

        window.addSubview(overlayView)

        // Animate in
        UIView.animate(withDuration: 0.25) {
            overlayView.alpha = 1
        }

        // Load image
        NetworkManager.shared.fetchImage(from: url) { image in
            UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve) {
                imageView.image = image ?? UIImage(systemName: "photo")
            }
        }

        // Tap outside to dismiss
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissImageViewer))
        overlayView.addGestureRecognizer(tapToDismiss)
    }

    @objc private func dismissImageViewer() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first,
              let overlay = window.viewWithTag(999) else { return }

        UIView.animate(withDuration: 0.25, animations: {
            overlay.alpha = 0
        }, completion: { _ in
            overlay.removeFromSuperview()
        })
    }
    
    private func setupAppearance() {
        [productCategory, productWearableLabel, productFeaturedButton].forEach { label in
               label?.font = .systemFont(ofSize: 11, weight: .semibold)
               label?.textColor = .systemGreen
               label?.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
               label?.layer.cornerRadius = 6
               label?.layer.masksToBounds = true
               label?.textAlignment = .center
           }
//        
//        buyNowButton.backgroundColor = .systemGreen
            buyNowButton.setTitleColor(.white, for: .normal)
            buyNowButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            buyNowButton.layer.cornerRadius = 14
            buyNowButton.layer.masksToBounds = true
//            buyNowButton.backgroundColor = .systemGreen
            
        
        addToCartButton.backgroundColor = .clear
            addToCartButton.setTitleColor(.systemGreen, for: .normal)
            addToCartButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            addToCartButton.layer.cornerRadius = 14
            addToCartButton.layer.borderWidth = 1.5
            addToCartButton.layer.borderColor = UIColor.systemGray.cgColor
    }
    private func populateData() {
        guard let product = dummyProduct else { return }

        productCategory.text = "  \(product.category.uppercased())  "
        productWearableLabel.text = "  WEARABLE  "   // static for now
        productFeaturedButton.text = "  FEATURED  "  // static for now
    }
    
    private func setupCarousel() {
        let nib = UINib(nibName: "CarouselCollectionViewCell", bundle: nil)
        carouselCollectionView.register(
            nib,
            forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier
        )
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.isPagingEnabled = true
        carouselCollectionView.bounces = true
        carouselCollectionView.decelerationRate = .fast
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.showsVerticalScrollIndicator = false

        if let layout = carouselCollectionView.collectionViewLayout
            as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero        // ← ADDED
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = carouselCollectionView.collectionViewLayout
            as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(
                width: carouselCollectionView.frame.width,
                height: carouselCollectionView.frame.height
            )
            layout.invalidateLayout()          // ← ADDED
        }
    }
}

// MARK: - CollectionView DataSource
extension ProductDetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
//        return product?.images.count ?? 0
        return dummyProduct?.paddedImages.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselCollectionViewCell.identifier,
            for: indexPath
        ) as! CarouselCollectionViewCell

//        if let imageName = product?.images[indexPath.item] {
//            cell.configure(with: imageName)
//        }
        // ✅ Load image from URL string
        if let urlString = dummyProduct?.paddedImages[indexPath.item], // ✅
               let url = URL(string: urlString) {
                cell.configureWithURL(url)
            }
        return cell
    }
}

// MARK: - CollectionView Delegate
extension ProductDetailViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == carouselCollectionView,   // ← ADDED guard
              scrollView.frame.width > 0 else { return }
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {   // ← ADDED
        guard scrollView == carouselCollectionView else { return }
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {  // ← ADDED
        guard scrollView == carouselCollectionView else { return }
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}

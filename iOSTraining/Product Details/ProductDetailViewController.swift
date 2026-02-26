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

    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCarousel()

        carouselCollectionView.isScrollEnabled = true
        carouselCollectionView.isUserInteractionEnabled = true
        scrollView.canCancelContentTouches = false

        if let product = product {
            self.title = product.name
            productName.text = product.name
            productPrice.text = "₱\(product.price)"
            productDescription.text = product.description
            pageControl.numberOfPages = product.images.count
            pageControl.currentPage = 0
            pageControl.currentPageIndicatorTintColor = .systemGreen
            pageControl.pageIndicatorTintColor = .systemGray3
            carouselCollectionView.reloadData()
        }

        pageControl.addTarget(self,
            action: #selector(pageControlTapped),
            for: .valueChanged)
    }

    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        carouselCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
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
        return product?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselCollectionViewCell.identifier,
            for: indexPath
        ) as! CarouselCollectionViewCell

        if let imageName = product?.images[indexPath.item] {
            cell.configure(with: imageName)
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

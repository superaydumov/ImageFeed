//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 24.07.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var singleImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Public properties
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(activityItems: [image ?? UIImage.self], applicationActivities: nil)
        present(share, animated: true)
    }
    
}

    // MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            self.rescaleAndCenterImageInScrollView(image: image)
        }
    }
}

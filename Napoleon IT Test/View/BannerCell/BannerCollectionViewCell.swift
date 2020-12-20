//
//  BannerCollectionViewCell.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    static let cellID = "bannerCard"
    
    var imageDownloadTask: URLSessionDownloadTask?
    
    var item: BannerModel! {
        didSet {
            if let title = item.title, let bannerDescription = item.desc {
                titleLabel.text = title
                descriptionLabel.text = bannerDescription
                blurView.isHidden = false
                titleLabel.isHidden = false
                descriptionLabel.isHidden = false
            } else {
                if let title = item.title {
                    titleLabel.text = title
                    blurView.isHidden = false
                    titleLabel.isHidden = false
                } else if let bannerDescription = item.desc {
                    titleLabel.text = bannerDescription
                    blurView.isHidden = false
                    titleLabel.isHidden = false
                }
            }
            
            guard let imageUrlString = item.image, let imageUrl = URL(string: imageUrlString) else {
                return
            }
            
            imageActivityIndicator.startAnimating()
            imageDownloadTask = bannerImage.loadImage(url: imageUrl, complition: {
                self.imageActivityIndicator.stopAnimating()
                self.imageActivityIndicator.isHidden = true
            })
        }
    }
    
    // MARK: UI elements
    let imageActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let bannerImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: effect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.isHidden = true
        return visualEffectView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bannerImage.image = nil
        imageActivityIndicator.isHidden = false
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        blurView.isHidden = true
        titleLabel.isHidden = true
        descriptionLabel.isHidden = true
    }
    
    // MARK: Initializers
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        
        contentView.addSubview(bannerImage)
        contentView.addSubview(blurView)
        bannerImage.addSubview(imageActivityIndicator)
        
        blurView.contentView.addSubview(titleLabel)
        blurView.contentView.addSubview(descriptionLabel)
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: Constraints
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            bannerImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.heightAnchor.constraint(equalToConstant: 60),
            
            // TODO: Check title & description constraints
            titleLabel.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -8),
            
            imageActivityIndicator.centerYAnchor.constraint(equalTo: bannerImage.centerYAnchor),
            imageActivityIndicator.centerXAnchor.constraint(equalTo: bannerImage.centerXAnchor)
        ])
        
        super.updateConstraints()
    }
}

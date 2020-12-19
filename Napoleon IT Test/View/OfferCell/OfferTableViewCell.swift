//
//  OfferTableViewCell.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let cellID = "offerCell"
    
    var imageDownloadTask: URLSessionDownloadTask?
    
    // MARK: - Outlets
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerName: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var offerPrice: UILabel!
    @IBOutlet weak var offerSale: UILabel!
    @IBOutlet weak var imageActivity: UIActivityIndicatorView!
    
    // MARK: - Configure cell
    var item: OfferModel! {
        didSet {
            offerName.text = item.name
            offerDescription.text = item.desc
            
            if item.type == .product {
                if let price = item.price {
                    offerPrice.isHidden = false
                    offerPrice.text = "\(Int(price))₽"
                    
                    if let sale = item.discount {
                        offerSale.isHidden = false
                        offerSale.text = "-\(Int(sale * 100.0))%"
                        
                        let salePrice = Int(price * (1.0 - sale))
                        
                        let priceText = "\(Int(price)) ₽"
                        let salePriceText = "\(salePrice) ₽"
                        
                        let finalLabel = NSString(string: priceText + "\n" + salePriceText)
                        
                        let rangePrice = finalLabel.range(of: priceText)
                        let rangeSale = finalLabel.range(of: salePriceText)
                        
                        let attributerPriceLabel = NSMutableAttributedString(string: finalLabel as String)
                        
                        // Set price lable color & strikethrough original price
                        attributerPriceLabel.addAttributes([.strikethroughStyle: NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)], range: rangePrice)
                        attributerPriceLabel.addAttributes([.foregroundColor: UIColor.darkGray], range: rangePrice)
                        attributerPriceLabel.addAttributes([.foregroundColor: UIColor.saleRed], range: rangeSale)
                        
                        offerPrice.attributedText = attributerPriceLabel
                    }
                }
            }
            
            guard let imageUrlString = item.image, let imageUrl = URL(string: imageUrlString) else {
                return
            }
            
            imageActivity.startAnimating()
            imageDownloadTask = offerImage.loadImage(url: imageUrl) { [weak self] in
                self?.imageActivity.stopAnimating()
                self?.imageActivity.isHidden = true
            }
        }
    }
    
    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
                
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        offerImage?.image = nil
        imageActivity.isHidden = false
        offerSale.isHidden = true
        offerPrice.isHidden = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        offerImage.layer.cornerRadius = 5.0
        offerImage.contentMode = .scaleToFill
        offerSale.layer.masksToBounds = true
        offerSale.layer.cornerRadius = offerSale.frame.height / 2.0
        offerSale.isHidden = true
        offerPrice.isHidden = true
    }
    
}

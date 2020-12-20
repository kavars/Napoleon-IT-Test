//
//  BannerTableViewCell.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let cellID = "bannerCell"

    let bannerWidth = UIScreen.main.bounds.width * 0.66

    var item: [BannerModel]! {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - UI elements
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.cellID)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
                
        return collectionView
    }()
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: Constraints
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        super.updateConstraints()
    }
}

// MARK: - UICollectionView methods
extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.cellID, for: indexPath) as? BannerCollectionViewCell else {
            fatalError()
        }

        cell.item = item[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bannerWidth, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - Scroll methods for paging
extension BannerTableViewCell {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        targetContentOffset.pointee = scrollView.contentOffset
        
        let currentCell = self.indexOfCurrentCell(xVelocity: velocity.x)
        
        let indexPath = IndexPath(row: currentCell, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func indexOfCurrentCell(xVelocity: CGFloat) -> Int {
        let proportionalOffset = collectionView.contentOffset.x / bannerWidth
        
        let floatPart = proportionalOffset.truncatingRemainder(dividingBy: 1.0)

        let index = Int(round(proportionalOffset))
        var safeIndex = max(0, min(item.count - 1, index))
                
        if xVelocity > 0 { // Forward
            if floatPart > 0.15 && floatPart < 0.5 {
                safeIndex += 1
            }
        } else { // Backward
            if floatPart > 0.5 && floatPart < 0.85 {
                safeIndex -= 1
            }
        }

        return safeIndex
    }
}

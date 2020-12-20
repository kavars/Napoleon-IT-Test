//
//  MainTableViewController.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    lazy var networkService: Network = NetworkService()
    
    // Banners
    var banners: [BannerModel] = []
    
    // Offers
    var offersByCategories: [String: [OfferModel]] = [:]
    var categoryKeys: [String] = []
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: BannerTableViewCell.cellID)
        tableView.register(UINib(nibName: "OfferTableViewCell", bundle: nil), forCellReuseIdentifier: OfferTableViewCell.cellID)

        loadOffers()
        loadBanners()
    }
    
    // MARK: - Helpers
    func loadBanners() {
        networkService.getBanners { (banners) in
            
            self.banners = banners
            
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        } failure: { (error) in
            self.createAndPresentErrorAlert(with: error)
        }

    }
    
    func loadOffers() {
        networkService.getOffers { (offers) in
            self.offersByCategories = [:]
            self.categoryKeys = []
            
            for offer in offers {
                if self.offersByCategories[offer.groupName] == nil {
                    // Create category & add key
                    self.offersByCategories[offer.groupName] = [offer]
                    self.categoryKeys.append(offer.groupName)
                } else {
                    self.offersByCategories[offer.groupName]?.append(offer)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } failure: { (error) in
            self.createAndPresentErrorAlert(with: error)
        }
    }
    
    func createAndPresentErrorAlert(with message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertVC.addAction(okAction)
            
            self.present(alertVC, animated: true)
        }
    }

    // MARK: - UITableView methods

    // Section 0 is banners cell
    // Next sections are offers cells
    override func numberOfSections(in tableView: UITableView) -> Int {
        return offersByCategories.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let key = categoryKeys[section-1]
            // If the key exists, we can guarantee that the category exists
            return offersByCategories[key]!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        return categoryKeys[section-1]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220.0
        } else {
            return 110.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // For banner cell
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.cellID, for: indexPath) as? BannerTableViewCell else {
                fatalError()
            }
            
            cell.item = banners
            cell.selectionStyle = .none
            
            return cell
        }
        
        // For offer cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.cellID, for: indexPath) as? OfferTableViewCell else {
            fatalError()
        }
        
        let key = categoryKeys[indexPath.section - 1]
        // If the key exists, we can guarantee that the category exists
        let category = offersByCategories[key]!
        
        cell.item = category[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: Delete offers methods
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
        }
    }

}

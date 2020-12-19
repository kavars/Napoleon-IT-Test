//
//  MainTableViewController.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    let bannerCellID = "bannerCell"

    lazy var networkService: Network = NetworkService()
    
    var offersByCategories: [String: [OfferModel]] = [:]
    var categoryKeys: [String] = []
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.register(UINib(nibName: "OfferTableViewCell", bundle: nil), forCellReuseIdentifier: OfferTableViewCell.cellID)

        loadOffers()
    }
    
    // MARK: - Helpers
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return offersByCategories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = categoryKeys[section]
        // If the key exists, we can guarantee that the category exists
        return offersByCategories[key]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryKeys[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.cellID, for: indexPath) as? OfferTableViewCell else {
            fatalError()
        }

        let key = categoryKeys[indexPath.section]
        // If the key exists, we can guarantee that the category exists
        let category = offersByCategories[key]!
        
        cell.item = category[indexPath.row]
        cell.selectionStyle = .none
        

        return cell
    }
        
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
        }
    }

}

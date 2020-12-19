//
//  NetworkService.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import Foundation

protocol Network {
    func getBanners(complition: @escaping ([BannerModel]) -> Void, failure: @escaping (String) -> Void)
    func getOffers(complition: @escaping ([OfferModel]) -> Void, failure: @escaping (String) -> Void)
}

class NetworkService: Network {
    
    // MARK: - Properties
    private let scheme = "https"
    private let host = "s3.eu-central-1.amazonaws.com"
    private let basePath = "/sl.files"
    
    // MARK: - Network protocol
    func getBanners(complition: @escaping ([BannerModel]) -> Void, failure: @escaping (String) -> Void) {
        createDataTask(path: "/banners.json", failure: failure) { (data) in
            do {
                let banners = try JSONDecoder().decode([BannerModel].self, from: data)
                complition(banners)
            } catch {
                do {
                    let error = try JSONDecoder().decode(ErrorModel.self, from: data)
                    failure(error.message + " \(error.code)")
                } catch {
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    func getOffers(complition: @escaping ([OfferModel]) -> Void, failure: @escaping (String) -> Void) {
        createDataTask(path: "/offers.json", failure: failure) { (data) in
            do {
                let offers = try JSONDecoder().decode([OfferModel].self, from: data)
                complition(offers)
            } catch {
                do {
                    let error = try JSONDecoder().decode(ErrorModel.self, from: data)
                    failure(error.message + " \(error.code)")
                } catch {
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Helper method
    private func createDataTask(path: String, failure: @escaping (String) -> Void, parseHandler: @escaping (Data) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + path
        
        guard let url = urlComponents.url else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                failure("Client error: " + error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                failure("Server error")
                return
            }
                        
            guard let data = data else {
                failure("Data is nil")
                return
            }
            
            parseHandler(data)
        }
        
        dataTask.resume()
    }
}

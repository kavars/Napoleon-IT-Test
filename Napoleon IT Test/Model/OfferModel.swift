//
//  OfferModel.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import Foundation

struct OfferModel: Decodable {
    var id: String
    var name: String
    var desc: String?
    var groupName: String
    var type: OfferType
    var image: String?
    var price: Float?
    var discount: Float?
    
    enum OfferType: String, Decodable {
        case item
        case product
    }
}

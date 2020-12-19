//
//  BannerModel.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import Foundation

struct BannerModel: Decodable {
    var id: String
    var title: String?
    var desc: String?
    var image: String?
}

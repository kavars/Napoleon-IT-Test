//
//  ErrorModel.swift
//  Napoleon IT Test
//
//  Created by Kirill Varshamov on 19.12.2020.
//

import Foundation

struct ErrorModel: Decodable {
    var message: String
    var code: Int
}

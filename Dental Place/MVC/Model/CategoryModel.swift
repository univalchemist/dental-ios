//
//  CategoryModel.swift
//  Dental Place
//
//  Created by AMARENDRA on 01/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct CategoryModel : Codable {
    
    let code : String?
    let data : [CatDatum]?
    let status : String?
    let message:String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case status = "status"
        case message = "message"

        
    }
    
}


struct CatDatum : Codable {
    
    let categoryName : String?
    let categorySlug : String?
    let createAt : String?
    let id : String?
    let status : String?
    let updateAt : String?
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "title"
        case categorySlug = "categorySlug"
        case createAt = "create_at"
        case id = "id"
        case status = "status"
        case updateAt = "update_at"
    }
    

    
}

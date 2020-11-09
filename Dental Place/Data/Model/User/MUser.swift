//
//  MUser.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct MUser : Codable {
    
    let id : Int?
    let userName : String?
    let userEmail : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case userEmail = "user_email"
    }
    
}
 

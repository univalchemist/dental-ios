//
//  UserSession.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct UserSession : Codable {
    
    let userId : Int?
    let apiToken : String?
    let id : Int?
    let userData: MUser?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case apiToken = "api_token"
        case id = "id"
        case userData = "userData"
    }
    
}

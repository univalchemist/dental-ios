//
//  LogoutModel.swift
//  Dental Place
//
//  Created by AMARENDRA on 01/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct LogoutModel : Codable {
    
    let code : String?
    let message : String?
    let status : String?
    let otp : String?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case status = "status"
        case otp = "otp"
    }
    
    
}

//
//  ForgotModel.swift
//  Dental Place
//
//  Created by AMARENDRA on 31/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct ForgotModel : Codable {
    
    let code : Int?
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


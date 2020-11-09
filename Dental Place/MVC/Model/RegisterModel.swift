//
//  RegisterModel.swift
//  Dental Place
//
//  Created by AMARENDRA on 25/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct RegisterModel : Codable
{
    
    let statusCode : String?
    let message : String?
    let errorLog : String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message = "message"
        case errorLog = "errorLog"
    }
    
}

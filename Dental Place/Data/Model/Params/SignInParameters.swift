//
//  SignInParameters.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct SignInParameters: Codable, ParametersInput {
    
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "user_email"
        case password
    }
    
}

struct SignInResult: Codable {
    let message: String?
    let statusCode: String?
    let data: UserSession?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}
   
   

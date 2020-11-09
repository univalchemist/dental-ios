//
//  SignupParameters.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

class SignUpParameters: Codable, ParametersInput {

    
    var title = ""
    var firstName = ""
    var lastName = ""
    var dateOfBirth = ""
    var phoneNumber = ""
    
    var country = ""
    var postcode = ""
    var flatNumber = ""
    var buildingNumber = ""
    var buildingName = ""
    var street = ""
    var cityTown = ""
    
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    var referralcode = ""
    
}

struct SignUpResult: Codable {
    let message: String?
    let statusCode: String?
    let data: UserSession?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}

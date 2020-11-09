//
//  FacebookLoginModel.swift
//  Dental Place
//
//  Created by AMARENDRA on 03/04/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation
struct FacebookLoginModel : Codable {

        let statusCode : String?
        let message : String?
        let data : FacebokLoginDatum?

        enum CodingKeys: String, CodingKey {
                case statusCode = "status_code"
                case message = "message"
                case data = "data"
        }
    
}
struct FacebokLoginDatum : Codable {

        let id : Int?
        let userName : String?
        let userEmail : String?
        let profileImage : String?
        let level : String?
        let categoryId : String?
        let datetime : String?
        let otp : String?
        let source : String?
        let facebookId : String?
        let googleId : String?
        let status : String?
        let benStart : String?
        let benEnd : String?
        let createdAt : String?
        let updatedAt : String?
    let profile_status : String?
    let tokens : [FacebookLoginToken]?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case userName = "user_name"
                case userEmail = "user_email"
                case profileImage = "profile_image"
                case level = "level"
                case categoryId = "categoryId"
                case datetime = "datetime"
                case otp = "otp"
                case source = "source"
                case facebookId = "facebook_id"
                case googleId = "google_id"
                case status = "status"
                case benStart = "ben_start"
                case benEnd = "ben_end"
                case createdAt = "created_at"
                case updatedAt = "updated_at"
                case tokens = "tokens"
                case profile_status = "profile_status"
            
        } 
}

struct FacebookLoginToken : Codable {

        let id : Int?
        let userId : String?
        let deviceId : String?
        let deviceType : String?
        let apiToken : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case userId = "user_id"
                case deviceId = "device_id"
                case deviceType = "device_type"
                case apiToken = "api_token"
        }
    
}

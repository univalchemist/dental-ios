//
//  ViewProfileModel.swift
//  Dental Place
//
//  Created by AMARENDRA on 30/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation
struct ViewProfileModel : Codable {
    
    let data : viewProfileData?
    let message : String?
    let statusCode : String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case statusCode = "status_code"
    }
    
}

struct viewProfileData : Codable {
    
    let apiToken : String?
    let benEnd : String?
    let benStart : String?
    let createdAt : String?
    let datetime : String?
    let deviceId : String?
    let deviceType : String?
    let facebookId : String?
    let googleId : String?
    let id : Int?
    let level : String?
    let otp : String?
    let source : String?
    let status : String?
    let updatedAt : String?
    let userEmail : String?
    let userName : String?
    let last_name : String?
    let profile_image : String?
    let userDetail : ViewProfileUserDetail?
    
    enum CodingKeys: String, CodingKey {
        case apiToken = "api_token"
        case benEnd = "ben_end"
        case benStart = "ben_start"
        case createdAt = "created_at"
        case datetime = "datetime"
        case deviceId = "device_id"
        case deviceType = "device_type"
        case facebookId = "facebook_id"
        case googleId = "google_id"
        case id = "id"
        case level = "level"
        case otp = "otp"
        case source = "source"
        case status = "status"
        case updatedAt = "updated_at"
        case userEmail = "user_email"
        case userName = "user_name"
        case last_name = "last_name"
        case userDetail = "userDetail"
        case profile_image = "profile_image"
        
    }

}

struct ViewProfileUserDetail : Codable {
    
    let address : String?
    let address1 : String?
    let city : String?
    let contact : String?
    let country : String?
    let createdAt : String?
    let dob : String?
    let gender : String?
    let id : Int?
    let latitude : String?
    let longitude : String?
    let updatedAt : String?
    let userid : String?
    let zipcode : String?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case address1 = "address1"
        case city = "city"
        case contact = "contact"
        case country = "country"
        case createdAt = "created_at"
        case dob = "dob"
        case gender = "gender"
        case id = "id"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case updatedAt = "updated_at"
        case userid = "userid"
        case zipcode = "zipcode"
    }
    
}

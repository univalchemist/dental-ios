//
//  LoginModel.swift
//  Dental Place
//
//  Created by AMARENDRA on 25/03/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

struct LoginModel : Codable {
    
    let statusCode : String?
    let message : String?
    let data : LoginUserData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message = "message"
        case data = "data"
    }
    
}

struct LoginUserData : Codable {
    
    let userId : Int?
//    let deviceId : String?
    let apiToken : String?
//    let deviceType : String?
    let id : Int?
    let userData : LoginUserDetal?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case apiToken = "api_token"
//        case deviceId = "device_id"
//        case deviceType = "device_type"
        case id = "id"
        case userData = "userData"
    }
    
}

struct LoginUserDetal : Codable {
    
    let id : Int?
    let userName : String?
    let userEmail : String?
//    let level : Int?
//    let datetime : String?
//    let otp : String?
//    let source : String?
//    let status : String?
//    let benStart : String?
//    let benEnd : String?
//    let profile_status : String?
//    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "user_name"
        case userEmail = "user_email"
//        case level = "level"
//        case datetime = "datetime"
//        case otp = "otp"
//        case source = "source"
//        case status = "status"
//        case benStart = "ben_start"
//        case benEnd = "ben_end"
//        case updated_at = "updated_at"
//        case profile_status = "profile_status"
        
        
    }
    
}



/*
    data =     {
        "api_token" = "eyJpdiI6IlVCR2FcL1Y5VTN4NDNzR3JFXC9ZR0xlUT09IiwidmFsdWUiOiJhVWRaU0FwbUdlZFVXT1E5MktuRStYQkZXZHBqZHNFWjlRMnhRblNVclhiSytYbWhpN1NFZFJiQ1ZCbHBudUlpb0JsYWdSVHlnZFpGUkR1NzRZbm5CNVlNbitmNGZPd1h4K09tc3poWlVVMUNDNXVMUnh3dmM4YTlIdCs2VjRQV3F4dVU4ZEZcL1hcL3QzWHlyY29KMTZmdkZYSytTQzRNa1dpczRsbmM3TlJiMGtodWRDc2xcL0xGVVFKd1FCb21xK2wiLCJtYWMiOiI4MWUyMjRhYmEyMmZlNTRkYTAzYzA5MWQyZjZjNWE0MmY0ZWY5MWUzODAwZTdiYTJmM2RhODk1ZTYzZjhmZDNhIn0=";
        "device_id" = 123456;
        "device_type" = iOS;
        id = 738;
        userData =         {
            "apple_id" = "<null>";
            "ben_end" = "<null>";
            "ben_start" = "<null>";
            "created_at" = "2020-07-22 11:47:50";
            datetime = "2020-07-08 14:40:53";
            "facebook_id" = "<null>";
            "full_name" = "Quang Pham";
            "google_id" = "<null>";
            id = 383;
            "last_name" = Pham;
            level = 1;
            "online_status" = 0;
            otp = 586;
            "profile_image" = "";
            "profile_status" = 1;
            source = E;
            status = 1;
            "updated_at" = "2020-07-22 11:47:50";
            "user_email" = "quanky@digiruu.com";
            "user_name" = Quang;
        };
        "user_id" = 383;
    };
    message = "User logged in successfully";
    "status_code" = 200;
 */

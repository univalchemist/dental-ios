//
//  API Handler.swift
//  Moocher
//
//  Created by eWeb on 5/15/19.
//  Copyright © 2019 administrator. All rights reserved.
//

import Foundation
import Alamofire
import IQKeyboardManagerSwift

enum ApiMethod
{
    case GET
    case POST
    case PUT
}
class ApiHandler: NSObject
{
    
    
    static func  ModelPostMethod(url: String , withParameters parameters:[String:AnyObject], success:@escaping ([String:Any])->(), failure: @escaping (String)->(),headers: [String:String])
{
    Alamofire.request("", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
        print("Resposnse in api =\(response)")
        
        let statusCode = response.response?.statusCode
        //                let json = JSON(data: response.data!)
        
        do {
            
            let json = try JSON(data: response.data!)
            
            
            switch response.result
            {
                
            case .success(_):
                if(statusCode==200)
                {
                    if let data = response.result.value
                    {
                        print (data)
                        DispatchQueue.main.async
                            {
                success(response.result.value as! [String:Any])
                        }
                        
                    }
                }
                else{
                    if let data = response.result.value{
                        let dict=data as! NSDictionary
                        
                        
                        if statusCode == 593{
                            DispatchQueue.main.async {
                                failure("Forgot Password")
                            }
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                failure(dict.value(forKey: "error_description") as! String)
                            }
                            
                        }
                        
                    }
                }
        
            case .failure(_):
                failure("JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format.")
                // Error handling
            }
    
    
}
catch _ {
            failure("JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format.")
            // Error handling
        }
    }// ClassClose
}
}

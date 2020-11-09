//
//  Utils.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

class DentalHelpers {
    static func handlePromiseError( _ error: Error) -> ErrorMessage {
        if let apiError = error as? BaseAPIError {
            switch apiError {
            case .unknown:
                return ErrorMessage.UnknownError
            case .remoteError(let msg):
                return ErrorMessage(title: "", message: msg)
            }
        } else {
            return ErrorMessage.UnknownError
        }
    }
    
}

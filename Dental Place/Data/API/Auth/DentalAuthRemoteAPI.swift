//
//  DentalAuthRemoteAPI.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import PromiseKit

class DentalAuthRemoteAPI: AuthRemoteAPI {
    func signUp(account: SignUpParameters) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            PrivateManagerAPI.sharedInstance.run(request: AuthServicesFactory().signUpRequest(), input: account, completionHandler: { (response) in
                switch response {
                case .success(let signUpResult):
                    if let userSession = signUpResult.data {
                        seal.fulfill(userSession)
                    } else {
                        seal.reject(BaseAPIError.unknown)
                    }
                case .failure(let error):
                    seal.reject(BaseAPIError.remoteError(error.error))
                }
            })
        }
    }
    
    func signIn(account: SignInParameters) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            PrivateManagerAPI.sharedInstance.run(request: AuthServicesFactory().loginRequest(), input: account, completionHandler: { (response) in
                switch response {
                case .success(let signInResult):

                    if let userSession = signInResult.data {
                        seal.fulfill(userSession)
                    } else {
                        seal.reject(BaseAPIError.unknown)
                    }
                case .failure(let error):
                    seal.reject(BaseAPIError.remoteError(error.error))
                }
            })
            
        }
    }
    
    
}

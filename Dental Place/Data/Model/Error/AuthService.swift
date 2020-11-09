//
//  AuthService.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import Foundation

class AuthServicesFactory: BaseServiceFactory {
    func loginRequest() -> BaseRequest<SignInParameters, SignInResult> {
        let request = urlRequest(path: "/login", method: .post)
        return BaseRequest<SignInParameters, SignInResult>(request: request)
    }
    
    func signUpRequest() -> BaseRequest<SignUpParameters, SignUpResult> {
        let request = urlRequest(path: "/register", method: .post)
        return BaseRequest<SignUpParameters, SignUpResult>(request: request)
    }
}

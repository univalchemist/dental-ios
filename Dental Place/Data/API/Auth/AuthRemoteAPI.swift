//
//  AuthRemoteAPI.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//

import PromiseKit

protocol AuthRemoteAPI {
    func signUp(account: SignUpParameters) -> Promise<UserSession>
    func signIn(account: SignInParameters) -> Promise<UserSession>
}

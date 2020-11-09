//
//  APIParameters.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//


import UIKit

protocol ParametersInput {
    func toJSON() -> [String: Any]
}

struct APIResultOutput {
    let data: [String: Any]
    let error: Error
}

extension ParametersInput where Self: Codable {
    func toJSON() -> [String : Any] {
        return self.parametersObject
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var parametersObject: [String: Any] {
        return dictionary ?? [:]
    }
}

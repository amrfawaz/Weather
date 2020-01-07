//
//  RequestParamters.swift
//  Weather
//
//  Created by Amr Fawaz on 1/7/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import UIKit

protocol RequestParamters: Codable {
    func getParamsAsJson() -> [String: Any]
}

extension RequestParamters {
    func getParamsAsJson() -> [String: Any] {
        let jsonEncoder = JSONEncoder()

        guard let jsonData = try? jsonEncoder.encode(self) else {
            return [:]
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            return [:]
        }

//        print(dictionary)
        return dictionary
    }
}

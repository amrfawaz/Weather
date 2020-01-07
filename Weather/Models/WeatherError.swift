//
//  TripViewModel.swift
//  Weather
//
//  Created by Amr Fawaz on 1/7/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation
import UIKit

class WeatherError: Error {
    var code: String?
    var message: String?
    var title: String?

    init(code: String?, message: String?, title: String?) {
        self.code = code
        self.message = message
        self.title = title
    }

    init(code: String?, message: String?) {
        self.code = code
        self.message = message
        title = "Something went wrong"
    }

    static func getError(error: Error) -> WeatherError {
        let weatherError = WeatherError(code: error.code, message: error.message)
        if let newError = error as? WeatherError {
            weatherError.message = newError.message
        }
        return weatherError
    }
}

extension Error {
    /**
     Error code
     */
    var code: String {
        return (self as? WeatherError)?.code ?? ""
    }

    /**
     Error message
     */
    var message: String {
        return (self as? WeatherError)?.message ?? localizedDescription
    }
}

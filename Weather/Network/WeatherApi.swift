//
//  WeatherApi.swift
//  Weather
//
//  Created by AmrFawaz on 1/9/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Alamofire
import PromiseKit
import UIKit


class WeatherApi: Api {
    enum APIRouter: Requestable {
        
        case getCityWeather(WeatherApi)

        var path: String {
            switch self {
            case .getCityWeather:
                return "/forecast"
            }
        }

        var baseUrl: URL {
            return Configurations.rootWeatherUrl
        }

        var method: HTTPMethod {
            switch self {
            case .getCityWeather:
                return .get
            }
        }
        
        
        var parameters: Parameters? {
            switch self {
            case let .getCityWeather(api):
                return api.params?.getParamsAsJson()
            }
        }
    }
}


extension WeatherApi {
    

    func getCityWeather() -> Promise<GetCityWeatherResponse> {
        return fireRequestWithSingleResponse(requestable: APIRouter.getCityWeather(self))
    }

}

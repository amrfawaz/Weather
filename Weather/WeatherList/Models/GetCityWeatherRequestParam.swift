//
//  GetCityWeatherRequestParam.swift
//  Weather
//
//  Created by AmrFawaz on 1/9/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation


class GetCityWeatherRequestParam: RequestParamters {
    var cityId: String?
    var appId = ServerKeys.appId
    var tempUnit = "metric"
    
    
    
    enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case appId = "appid"
        case tempUnit = "units"
    }

}

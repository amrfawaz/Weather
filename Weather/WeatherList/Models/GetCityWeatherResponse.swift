//
//  GetCityResponse.swift
//  Weather
//
//  Created by AmrFawaz on 1/9/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation



class GetCityWeatherResponse: Codable {
    var list: [WeatherResponse]?
    var city: CityRealm?

}


class WeatherResponse: Codable {
    var weather: Weather?
    var date: String?
    
    private enum CodingKeys: String, CodingKey {
        case weather = "main"
        case date = "dt_txt"
    }
    
    
    required init(from decoder: Decoder) throws {
        let mainContrainer = try decoder.container(keyedBy: CodingKeys.self)
        
        
        weather = (try? mainContrainer.decode(Weather.self, forKey: .weather))
        
        let parsedDate = (try? mainContrainer.decode(String.self, forKey: .date))
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTime = dateformater.date(from: parsedDate!)
        dateformater.dateFormat = "EEEE"
        date = dateformater.string(from: dateTime!)
        
        weather?.date = date


    }
}

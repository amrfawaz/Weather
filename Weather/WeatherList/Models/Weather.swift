
//
//  Weather.swift
//  Weather
//
//  Created by AmrFawaz on 1/9/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation





class Weather: Codable {
    var temp: Double?
    var minTemp: Double?
    var maxTemp: Double?
    var humidity: Int?
    var date: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case humidity = "humidity"
    }
    
    
    required init(from decoder: Decoder) throws {
        let mainContrainer = try decoder.container(keyedBy: CodingKeys.self)
            
        temp = (try? mainContrainer.decode(Double.self, forKey: .temp))?.rounded(.up)
        minTemp = (try? mainContrainer.decode(Double.self, forKey: .minTemp))?.rounded(.up)
        maxTemp = (try? mainContrainer.decode(Double.self, forKey: .maxTemp))?.rounded(.up)
        humidity = (try? mainContrainer.decode(Int.self, forKey: .humidity))
    }

}

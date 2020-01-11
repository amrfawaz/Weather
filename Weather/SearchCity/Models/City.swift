//
//  City.swift
//  Weather
//
//  Created by MyAList on 1/8/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation
import RealmSwift




class CityRealm: Object, Codable {
    @objc dynamic var cityId: Int
    @objc dynamic var name: String?
    @objc dynamic var country: String?
    dynamic var isSelected: Bool = false
    dynamic var daysWeather: [WeatherResponse]?
    @objc dynamic var coord: CoordinateRealm?
    
    private enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case name
        case country
        case coord
    }

}

class CoordinateRealm: Object, Codable {
    @objc dynamic var lon: Double = 0.0
    @objc dynamic var lat: Double = 0.0
}


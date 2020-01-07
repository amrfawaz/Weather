//
//  City.swift
//  Weather
//
//  Created by MyAList on 1/8/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation

class City: Codable {
    let id: Int?
    let name: String?
    let country: String?
    let coord: Coordinate?
    
}


struct Coordinate: Codable {
    let lon: Double?
    let lat: Double?
}

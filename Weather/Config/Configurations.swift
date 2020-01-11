//
//  Configurations.swift
//  Weather
//
//  Created by Amr Fawaz on 1/7/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import UIKit

enum ProjectMode: String {
    case development
    case stage
    case production
}

enum ConnectionStatus: String {
    case connected
    case disconnected
}

class Configurations: NSObject {
    static var mode: ProjectMode = .stage
    static var connectionStatus: ConnectionStatus?
    

    static var rootWeatherUrl: URL {
        if Configurations.mode == .development {
            return URL(string: "http://api.openweathermap.org/data/2.5")!
        } else if Configurations.mode == .production {
            return URL(string: "http://api.openweathermap.org/data/2.5")!
        } else {
            return URL(string: "http://api.openweathermap.org/data/2.5")!
        }
    }

    
}

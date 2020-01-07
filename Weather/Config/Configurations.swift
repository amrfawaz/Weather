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
    

    static var UserBaseUrl: URL {
        if Configurations.mode == .development {
            return URL(string: "http://www.fly365dev.com/")!
        } else if Configurations.mode == .production {
            return URL(string: "https://www.fly365.com/")!
        } else {
            return URL(string: "https://www.fly365stage.com/")!
        }
    }

    
}

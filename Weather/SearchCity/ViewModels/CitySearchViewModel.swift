//
//  CitySearchViewModel.swift
//  Weather
//
//  Created by AmrFawaz on 1/8/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation
import RealmSwift

class CitySearchViewModel {
    let selectedCityCellIdentifire = "CityCell"
    let realm = try! Realm()
    lazy var allCities: [CityRealm] = Array(realm.objects(CityRealm.self))

    lazy var searchCities = [CityRealm]()
        
}

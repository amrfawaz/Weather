//
//  WeatherListViewModel.swift
//  Weather
//
//  Created by AmrFawaz on 1/8/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherListViewModel {
    
    let selectedCityCellIdentifire = "SelectedCityCell"
    
    lazy var selectedCities = [CityRealm]()
    var selectedCity: CityRealm?
    
    func getWeather(withCityId cityId: String, complition: @escaping (_ error: WeatherError?, _ daysWeather: [WeatherResponse]?) -> Void) {
        
        let weatherParams = GetCityWeatherRequestParam()
        weatherParams.cityId = cityId
        let weatherApi = WeatherApi()
        weatherApi.params = weatherParams
        weatherApi.requestsId = String(describing: self)

        weatherApi.getCityWeather().get { response in
            var daysWeather = [WeatherResponse]()
            let daysList = response.list
            for day in daysList! {
                if !(daysWeather.contains(where: { $0.date == day.date })) {
                    daysWeather.append(day)
                    print(day.date!)
                }
            }
            
            self.selectedCity = response.city
            complition(nil, daysWeather)
        }.catch { error in
            complition(error as? WeatherError, nil)
        }
    }
    
    
    func saveCityId(cityId: Int) {
        var cityIds = UserDefaults.standard.value(forKey: "SelectedCities") as? [Int]
        if cityIds == nil {
            cityIds = [Int]()
        }
        cityIds?.append(cityId)
        UserDefaults.standard.set(cityIds, forKey: "SelectedCities")
    }
    
    func removeCity(cityId: Int) {
        var cityIds = UserDefaults.standard.value(forKey: "SelectedCities") as? [Int]
        cityIds?.removeAll(where: { $0 == cityId })
        UserDefaults.standard.set(cityIds, forKey: "SelectedCities")
    }
    
    func getSavedCities() -> [Int]? {
        return UserDefaults.standard.value(forKey: "SelectedCities") as? [Int]
    }
}

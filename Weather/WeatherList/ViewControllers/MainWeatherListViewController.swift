//
//  MainWeatherListViewController.swift
//  Weather
//
//  Created by AmrFawaz on 1/8/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import UIKit

class MainWeatherListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var weatherListViewModel = WeatherListViewModel()
    var citySearchViewModel = CitySearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        addAddCityButton()
        registerCells()
        getSavedCities()
    }
    
    
    func registerCells() {
        tableView.register(UINib(nibName: weatherListViewModel.selectedCityCellIdentifire, bundle: nil), forCellReuseIdentifier: weatherListViewModel.selectedCityCellIdentifire)
    }
    
    func addAddCityButton() {
        guard weatherListViewModel.selectedCities.count < 3 else { return }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        self.navigationItem.rightBarButtonItem = addButton
    }

    @objc func addCity() {
        let storyboard = UIStoryboard(name: "SearchCity", bundle: nil)
        let citySearchViewController = storyboard.instantiateInitialViewController() as? CitySearchViewController
        citySearchViewController?.delegate = self
        self.navigationController?.pushViewController(citySearchViewController!, animated: true)
    }
    
    func checkNumberOfCities() -> Int {
        return weatherListViewModel.selectedCities.count
    }
    
    func getSavedCities() {
        if let cityIds = weatherListViewModel.getSavedCities(), cityIds.count > 0 {
            let selectedCities = citySearchViewModel.allCities.filter { cityIds.contains($0.cityId) }
            for city in selectedCities {
                weatherListViewModel.getWeather(withCityId: "\(city.cityId)") { [weak self] error, daysWeather in
                    guard let strongSelf = self else { return }
                    if error == nil {
                        city.daysWeather = daysWeather
                        strongSelf.weatherListViewModel.selectedCities.append(city)
                        
                        strongSelf.tableView.reloadData()
                    }
                }
            }
        } else {
            weatherListViewModel.saveCityId(cityId: 360630)
            getSavedCities()
        }
    }
    
}


extension MainWeatherListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModel.selectedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = weatherListViewModel.selectedCities[indexPath.row]
        let cityCell = tableView.dequeueReusableCell(withIdentifier: weatherListViewModel.selectedCityCellIdentifire) as? SelectedCityCell
        cityCell?.delegate = self
        if indexPath.row == 0 {
            cityCell?.buttonRemoveCity.isHidden = true
        } else {
            cityCell?.buttonRemoveCity.isHidden = false
        }
        cityCell?.buttonRemoveCity.tag = indexPath.row
        
        cityCell?.labelCityName.text = city.name
        
        cityCell?.labelTodayTemp.text = city.daysWeather?[0].weather?.temp?.toString()
        
        cityCell?.labelDay2MinTemp.text = city.daysWeather?[1].weather?.minTemp?.toString()
        cityCell?.labelDay2MaxTemp.text = city.daysWeather?[1].weather?.maxTemp?.toString()
        
        cityCell?.labelDay3MinTemp.text = city.daysWeather?[2].weather?.minTemp?.toString()
        cityCell?.labelDay3MaxTemp.text = city.daysWeather?[2].weather?.maxTemp?.toString()
        
        cityCell?.labelDay4MinTemp.text = city.daysWeather?[3].weather?.minTemp?.toString()
        cityCell?.labelDay4MaxTemp.text = city.daysWeather?[3].weather?.maxTemp?.toString()
        
        cityCell?.labelDay5MinTemp.text = city.daysWeather?[4].weather?.minTemp?.toString()
        cityCell?.labelDay5MaxTemp.text = city.daysWeather?[4].weather?.maxTemp?.toString()
        
        if city.daysWeather?.count ?? 0 > 5 {
            cityCell?.labelDay6MinTemp.text = city.daysWeather?[5].weather?.minTemp?.toString()
            cityCell?.labelDay6MaxTemp.text = city.daysWeather?[5].weather?.maxTemp?.toString()
            cityCell?.labelDay6.text = city.daysWeather?[5].date
        } else {
            cityCell?.labelDay6MinTemp.text = ""
            cityCell?.labelDay6MaxTemp.text = ""
            cityCell?.labelDay6.text = ""

        }

        
        cityCell?.labelDay2.text = city.daysWeather?[1].date
        cityCell?.labelDay3.text = city.daysWeather?[2].date
        cityCell?.labelDay4.text = city.daysWeather?[3].date
        cityCell?.labelDay5.text = city.daysWeather?[4].date

        return cityCell!
    }
    
}


extension MainWeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}

extension MainWeatherListViewController: SelectedCityCellDelegate {
    
    func didPressRemove(button: UIButton) {
        weatherListViewModel.removeCity(cityId: self.weatherListViewModel.selectedCities[button.tag].cityId)
        self.weatherListViewModel.selectedCities.remove(at: button.tag)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: button.tag, section: 0)], with: .left)
        tableView.endUpdates()
        
        
        self.tableView.reloadData()
    }
}


extension MainWeatherListViewController: CitySearchDelegate {
    func didSelectCity(city: CityRealm) {
        weatherListViewModel.selectedCities.append(city)
        weatherListViewModel.saveCityId(cityId: city.cityId)
        self.tableView.reloadData()
        if checkNumberOfCities() == 3 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
    }
}

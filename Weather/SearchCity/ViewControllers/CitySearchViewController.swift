//
//  CitySearchViewController.swift
//  Weather
//
//  Created by AmrFawaz on 1/8/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import UIKit

protocol CitySearchDelegate: class {
    func didSelectCity(city: CityRealm)
}

class CitySearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var citySearchViewModel = CitySearchViewModel()
    let weatherListViewModel = WeatherListViewModel()

    weak var delegate: CitySearchDelegate?
    var savedCityIds: [Int]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select City"
        self.searchBar.becomeFirstResponder()
        registerCells()
        loadCities()
        savedCityIds = weatherListViewModel.getSavedCities()
    }
    
    
    func loadCities() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.citySearchViewModel.searchCities = self.citySearchViewModel.allCities
                self.tableView.reloadData()
            }
        }

    }
    
    
    func registerCells() {
        tableView.register(UINib(nibName: citySearchViewModel.selectedCityCellIdentifire, bundle: nil), forCellReuseIdentifier: citySearchViewModel.selectedCityCellIdentifire)
    }
    
}



extension CitySearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citySearchViewModel.searchCities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = citySearchViewModel.searchCities[indexPath.row]
        let cityCell = tableView.dequeueReusableCell(withIdentifier: citySearchViewModel.selectedCityCellIdentifire) as? CityCell
        cityCell?.delegate = self
        cityCell?.labelCityName.text = (city.name ?? "") + " - " + (city.country ?? "")
        if city.isSelected {
            if savedCityIds?.contains(city.cityId) ?? false {
                cityCell?.buttonAddCity.isHidden = true
            } else {
                cityCell?.buttonAddCity.isHidden = false
            }
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
            
        } else {
            cityCell?.labelTodayTemp.text = ""
            
            cityCell?.labelDay2MinTemp.text = ""
            cityCell?.labelDay2MaxTemp.text = ""
            
            cityCell?.labelDay3MinTemp.text = ""
            cityCell?.labelDay3MaxTemp.text = ""
            
            cityCell?.labelDay4MinTemp.text = ""
            cityCell?.labelDay4MaxTemp.text = ""
            
            cityCell?.labelDay5MinTemp.text = ""
            cityCell?.labelDay5MaxTemp.text = ""
            
            cityCell?.labelDay6MinTemp.text = ""
            cityCell?.labelDay6MaxTemp.text = ""
            
            cityCell?.labelDay2.text = ""
            cityCell?.labelDay3.text = ""
            cityCell?.labelDay4.text = ""
            cityCell?.labelDay5.text = ""
            cityCell?.labelDay6.text = ""

        }
        return cityCell!

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let city = citySearchViewModel.searchCities[indexPath.row]
        if city.isSelected {
            return 225
        } else {
            return 44
        }

    }
    
}

extension CitySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = citySearchViewModel.searchCities[indexPath.row]
        
        if !selectedCity.isSelected {
            
            if let lastSelectedIndex = citySearchViewModel.searchCities.firstIndex(where: { $0.isSelected == true }) {
                citySearchViewModel.searchCities[lastSelectedIndex].isSelected = false
                tableView.reloadRows(at: [IndexPath(row: lastSelectedIndex, section: 0)], with: .automatic)
            }
            activityIndicator.startAnimating()
            weatherListViewModel.getWeather(withCityId: "\(selectedCity.cityId)") { [weak self] error, daysWeather in
                guard let strongSelf = self else { return }
                strongSelf.activityIndicator.stopAnimating()
                if let error = error {
                    print(error.message ?? "")
                } else {
                    selectedCity.daysWeather = daysWeather
                    selectedCity.isSelected = true
                    strongSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        } else {
            selectedCity.isSelected = false
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            citySearchViewModel.searchCities = citySearchViewModel.allCities
        } else {
            citySearchViewModel.searchCities = citySearchViewModel.searchCities.filter({ ($0.name?.contains(searchText) ?? true) })
        }
        tableView.reloadData()
        print(searchText)
    }

}



extension CitySearchViewController: CityCellDelegate {
    func didPressAddCity() {
        
        if let selectedCity = citySearchViewModel.searchCities.first(where: { $0.isSelected == true }) {
            delegate?.didSelectCity(city: selectedCity)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//
//  CityCell.swift
//  Weather
//
//  Created by AmrFawaz on 1/8/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import UIKit


enum CellState {
    case collapsed
    case expanded
}

protocol CityCellDelegate: class {
    func didPressAddCity()
}

class CityCell: UITableViewCell {

    
    var state: CellState = .collapsed
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTodayTemp: UILabel!
    @IBOutlet weak var labelDay2: UILabel!
    @IBOutlet weak var labelDay3: UILabel!
    @IBOutlet weak var labelDay4: UILabel!
    @IBOutlet weak var labelDay5: UILabel!
    @IBOutlet weak var labelDay6: UILabel!
    
    
    @IBOutlet weak var labelDay2MinTemp: UILabel!
    @IBOutlet weak var labelDay2MaxTemp: UILabel!
    
    @IBOutlet weak var labelDay3MinTemp: UILabel!
    @IBOutlet weak var labelDay3MaxTemp: UILabel!
    
    @IBOutlet weak var labelDay4MinTemp: UILabel!
    @IBOutlet weak var labelDay4MaxTemp: UILabel!
    
    @IBOutlet weak var labelDay5MinTemp: UILabel!
    @IBOutlet weak var labelDay5MaxTemp: UILabel!
    
    @IBOutlet weak var labelDay6MinTemp: UILabel!
    @IBOutlet weak var labelDay6MaxTemp: UILabel!
    
    @IBOutlet weak var buttonAddCity: UIButton!
    
    weak var delegate: CityCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didPressAddButton(_ sender: Any) {
        
        delegate?.didPressAddCity()
    }
}

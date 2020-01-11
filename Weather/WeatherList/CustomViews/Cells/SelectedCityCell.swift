//
//  SelectedCityCell.swift
//  Weather
//
//  Created by AmrFawaz on 1/10/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//

import UIKit


protocol SelectedCityCellDelegate: class {
    func didPressRemove(button: UIButton)
}
class SelectedCityCell: UITableViewCell {

    
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
    
    @IBOutlet weak var buttonRemoveCity: UIButton!
    
    weak var delegate: SelectedCityCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didPressRemoveButton(_ sender: UIButton) {
        delegate?.didPressRemove(button: sender)
    }
}

//
//  DayCell.swift
//  WeekWeather
//
//  Created by Egor on 18/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {

    @IBOutlet var currentTempLabel: UILabel!
    
    @IBOutlet var dayNightTempLabel: UILabel!
    
    @IBOutlet var feelsTempLabel: UILabel!
    
    @IBOutlet var weatherDescriptLabel: UILabel!
    
    @IBOutlet var windLabel: UILabel!
    
    @IBOutlet var weatherIconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with dayForecast: DayForecast){
//        currentTempLabel.text = dayForecast.temp.day
        let dayTemp = LocString.today + String(dayForecast.temp.day) + AppConstants.Celsius
        let nigthTemp = LocString.tonight + String(dayForecast.temp.night) + AppConstants.Celsius
        dayNightTempLabel.text = dayTemp + AppConstants.dot + nigthTemp
//        feelsTempLabel.text = LocString.feelsLike + String(dayForecast.feelsLike.day) + AppConstants.Celsius
        weatherDescriptLabel.text = dayForecast.weather.first?.description
        windLabel.text = LocString.wind + String(dayForecast.windSpeed) + LocString.metersInSec
    }
    
}

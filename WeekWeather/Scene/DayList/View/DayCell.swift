//
//  DayCell.swift
//  WeekWeather
//
//  Created by Egor on 18/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {

    @IBOutlet private var currentTempLabel: UILabel!
    
    @IBOutlet private var dayNightTempLabel: UILabel!
    
    @IBOutlet private var feelsTempLabel: UILabel!
    
    @IBOutlet private var weatherDescriptLabel: UILabel!
    
    @IBOutlet private var windLabel: UILabel!
    
    @IBOutlet private var weekDay: UILabel!
    
    @IBOutlet private var weatherIconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with dayForecast: DayForecast){
        currentTempLabel.text = String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius
        let dayTemp = LocString.today + String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius
        let nigthTemp = LocString.tonight + String(format: "%.0f", dayForecast.temp.night) + AppConstants.celsius
        dayNightTempLabel.text = dayTemp + AppConstants.dot + nigthTemp
        feelsTempLabel.text = LocString.feelsLike + String(dayForecast.feelsLike.day) + AppConstants.celsius
        weatherDescriptLabel.text = dayForecast.weather.first?.description
        windLabel.text = LocString.wind + String(format: "%.1f", dayForecast.windSpeed) + LocString.metersInSec
        weekDay.text = getDate(unixTime: dayForecast.dt)
        
        guard let ico = dayForecast.weather.first?.icon else { return }
        let stringURL = "https://openweathermap.org/img/wn/" + ico + "@2x.png"
        ImageDownloader.downloadImage(stringURL: stringURL) { (imageData) in

            DispatchQueue.main.async {
                self.weatherIconImage.image = UIImage(data: imageData)
            }

        }
    }
    
    func configureFirstCell(with weekForecast: WeekForecast){
        let dayForecast = weekForecast.daily.first!
        let currentWeather = weekForecast.current
        
        currentTempLabel.text = String(format: "%.0f", currentWeather.temp) + AppConstants.celsius
        let dayTemp = LocString.today + String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius
        let nigthTemp = LocString.tonight + String(format: "%.0f", dayForecast.temp.night) + AppConstants.celsius
        dayNightTempLabel.text = dayTemp + AppConstants.dot + nigthTemp
        feelsTempLabel.text = LocString.feelsLike + String(currentWeather.feelsLike) + AppConstants.celsius
        weatherDescriptLabel.text = currentWeather.weather.first?.description
        windLabel.text = LocString.wind + String(format: "%.1f", currentWeather.windSpeed) + LocString.metersInSec
        weekDay.text = getDate(unixTime: currentWeather.dt)
        
        guard let ico = dayForecast.weather.first?.icon else { return }
        let stringURL = "https://openweathermap.org/img/wn/" + ico + "@2x.png"
        ImageDownloader.downloadImage(stringURL: stringURL) { (imageData) in

            DispatchQueue.main.async {
                self.weatherIconImage.image = UIImage(data: imageData)
            }

        }
    }
    
    private func getDate(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEEE, dd MMM"
        dateFormatter.locale = .current
        
        let locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages.first!)
        dateFormatter.locale = locale as Locale?
        let localDate = dateFormatter.string(from: date as Date)
        
        return localDate
    }
    
}

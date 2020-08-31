//
//  DayCell.swift
//  WeekWeather
//
//  Created by Egor on 18/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

protocol DayCellDelegate {
    var imageArray: [String : UIImage] { get set }
    var newIconsArray: [String : UIImage]  { get set }
    var useNewIcons: Bool { get set }
}

class DayCell: UITableViewCell {
    
    @IBOutlet private var currentTempLabel: UILabel!
    @IBOutlet private var dayNightTempLabel: UILabel!
    @IBOutlet private var feelsTempLabel: UILabel!
    @IBOutlet private var weatherDescriptLabel: UILabel!
    @IBOutlet private var windLabel: UILabel!
    @IBOutlet private var weekDay: UILabel!
    @IBOutlet private var weatherIconImage: UIImageView!
    
    var delegate: DayCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        currentTempLabel.backgroundColor = .clear
        dayNightTempLabel.backgroundColor = .clear
        feelsTempLabel.backgroundColor = .clear
        weatherDescriptLabel.backgroundColor = .clear
        windLabel.backgroundColor = .clear
        weekDay.backgroundColor = .clear
        weatherIconImage.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with dayForecast: DayForecast?){
        guard let dayForecast = dayForecast else { return }
        self.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9411764706, alpha: 1)
        
        currentTempLabel.text = String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius
        let dayTemp = LocString.Cell.day + String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius
        let nigthTemp = LocString.Cell.night + String(format: "%.0f", dayForecast.temp.night) + AppConstants.celsius
        dayNightTempLabel.text = dayTemp + AppConstants.dot + nigthTemp
        feelsTempLabel.text = LocString.Cell.feelsLike + String(format: "%.0f", dayForecast.feelsLike.day) + AppConstants.celsius
        weatherDescriptLabel.text = dayForecast.weather.first?.description
        windLabel.text = "🚩 " /*LocString.Cell.wind*/ + String(format: "%.1f", dayForecast.windSpeed) + LocString.Cell.metersInSec
        weekDay.text = getDate(unixTime: dayForecast.dt)
        
        setImage(weather: dayForecast.weather)
    }
    
    
    func configureFirstCell(with weekForecast: WeekForecast?){
        guard let weekForecast = weekForecast else { return }
        
        guard let dayForecast = weekForecast.daily.first else { return }
        let currentWeather = weekForecast.current
        self.backgroundColor = #colorLiteral(red: 0.9394798801, green: 0.9772186925, blue: 1, alpha: 1)
        
        currentTempLabel.text = String(format: "%.0f", currentWeather.temp) + AppConstants.celsius
        let dayTemp = LocString.Cell.today + String(format: "%.0f", dayForecast.temp.day) + AppConstants.celsius
        let nigthTemp = LocString.Cell.tonight + String(format: "%.0f", dayForecast.temp.night) + AppConstants.celsius
        dayNightTempLabel.text = dayTemp + AppConstants.dot + nigthTemp
        feelsTempLabel.text = LocString.Cell.feelsLike + String(format: "%.0f", currentWeather.feelsLike) + AppConstants.celsius
        weatherDescriptLabel.text = dayForecast.weather.first?.description //currentWeather.weather.first?.description
        windLabel.text = "🚩 " /*LocString.Cell.wind*/ + String(format: "%.1f", currentWeather.windSpeed) + LocString.Cell.metersInSec
        weekDay.text = getDate(unixTime: currentWeather.dt)
        
        setImage(weather: dayForecast.weather)
    }
    
    private func setImage(weather: [Weather]) {
        
        if let weather = weather.first, let image = delegate?.imageArray[weather.description] {
            DispatchQueue.main.async {
                self.weatherIconImage.image = image
            }
            return
        }
        
        guard let ico = weather.first?.icon else { return }
        let stringURL = "https://openweathermap.org/img/wn/" + ico + "@2x.png"
        ImageDownloader.downloadImage(stringURL: stringURL) { (imageData) in
            
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)// ?? UIImage()
                self.delegate?.imageArray[weather.first!.description] = image
                self.weatherIconImage.image = image
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

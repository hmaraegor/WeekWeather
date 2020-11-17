//
//  ThirdCell.swift
//  WeekWeather
//
//  Created by Egor on 03.11.2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

extension ThirdCell {
    private func setNewIcons(weather: [Weather]) {
        DispatchQueue.main.async {
            self.weatherIconImage.image = self.delegate?.newIconsArray[weather.first!.icon]
        }
    }
    
    //MARK: For use new icons
    
    private func setImage(weather: [Weather]) {
        
        if (delegate?.useNewIcons)! {
            setNewIcons(weather: weather)
            return
        }
        
        if let weather = weather.first, let image = delegate?.imageArray[weather.icon/*weather.description*/] {
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
                if self.delegate.oldIconsUrlWasPassed {
                    self.delegate?.imageArray[weather.first!.icon/*weather.first!.description*/] = image
                    
                }
                self.weatherIconImage.image = image
            }
            
        }
    }
    
}

class ThirdCell: UITableViewCell {
    
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var dayNightTempLabel: UILabel!
    @IBOutlet var feelsTempLabel: UILabel!
    @IBOutlet var weatherDescriptLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var weekDay: UILabel!
    @IBOutlet var weatherIconImage: UIImageView!
    
    static let cellXib = "ThirdDayCell" // "NewDayCell"   //"DayCell"
    static let cell = "ThirdCell" // "NewCell"         //"Cell"
    
    var delegate: DayCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentTempLabel.backgroundColor = .clear
        dayNightTempLabel.backgroundColor = .clear
        feelsTempLabel.backgroundColor = .clear
        weatherDescriptLabel.backgroundColor = .clear
        windLabel.backgroundColor = .clear
        weekDay.backgroundColor = .clear
        guard let weatherImage = weatherIconImage else { return }
        weatherImage.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static func getNib(nibName: String = DayCell.cellXib) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    func setSystemIcon(strIcon: String) {
        let sysIcon2 = ["sun.max.fill", "cloud.sun", "cloud",
                       "cloud.fill", "cloud.rain", "cloud.sun.rain",
                       "cloud.bolt", "snow", "cloud.fog",
                       
                       "moon.stars", "cloud.moon", "cloud",
                       "cloud.fill", "cloud.rain.fill", "cloud.moon.rain.fill",
                       "cloud.moon.bolt.fill", "snow", "cloud.fog"]
        
        let sysIcon = ["sun.max", "cloud.sun", "cloud",
                       "cloud", "cloud.rain", "cloud.sun.rain",
                       "cloud.bolt", "snow", "cloud.fog",
                       
                       "moon.stars", "cloud.moon", "cloud",
                       "cloud", "cloud.rain", "cloud.moon.rain",
                       "cloud.moon.bolt", "snow", "cloud.fog"]
        
        let weatherIcon = ["01d", "02d", "03d",
                           "04d", "09d", "10d",
                           "11d", "13d", "50d",
                           
                           "01n", "02n", "03n",
                           "04n", "09n", "10n",
                           "11n", "13n", "50n"]
        
        for i in 0...weatherIcon.count - 1 {
            guard weatherIcon[i] == strIcon else { continue }
            DispatchQueue.main.async {
                self.weatherIconImage.image = UIImage(systemName: sysIcon[i])
            }
        }
    }
    
    func configure(with dayForecast: DayForecast?){
        guard let dayForecast = dayForecast else { return }
        self.backgroundColor = #colorLiteral(red: 0.8765466371, green: 0.8765466371, blue: 0.8765466371, alpha: 0)
        currentTempLabel.font = currentTempLabel.font.withSize(60)
        //self.backgroundColor = #colorLiteral(red: 0.9327142923, green: 0.9359927306, blue: 0.9458280457, alpha: 0)
        
        currentTempLabel.text = tempToString(temp: dayForecast.temp.day)
        let dayTemp = LocString.Cell.day + tempToString(temp: dayForecast.temp.day)
        let nigthTemp = LocString.Cell.night + tempToString(temp: dayForecast.temp.night)
        dayNightTempLabel.text = dayTemp + AppConstants.dot + nigthTemp
        feelsTempLabel.text = LocString.Cell.feels_like + tempToString(temp: dayForecast.feelsLike.day)
        weatherDescriptLabel.text = dayForecast.weather.first?.description
        windLabel.text = "🚩 " /*LocString.Cell.wind*/ + String(format: "%.1f", dayForecast.windSpeed) + LocString.Cell.meters_in_sec
        
        let time12oclock = dayForecast.dt - AppConstants.twelveHoursInSeconds
        weekDay.text = DateService.getDate(unixTime: time12oclock, dateFormat: "EEEE, dd MMM")
        
        if delegate.useSystemIcons {
            setSystemIcon(strIcon: dayForecast.weather.first?.icon ?? "")
        } else {
            setImage(weather: dayForecast.weather)
        }
    }
    
    
    func configureFirstCell(with weekForecast: WeekForecast?){
        guard let weekForecast = weekForecast else { return }
        
        guard let dayForecast = weekForecast.daily.first else { return }
        let currentWeather = weekForecast.current
        self.backgroundColor = #colorLiteral(red: 0.9327142923, green: 0.9359927306, blue: 0.9458280457, alpha: 0)
        currentTempLabel.font = currentTempLabel.font.withSize(70)
        
        //self.backgroundColor = #colorLiteral(red: 0.9394798801, green: 0.9772186925, blue: 1, alpha: 1)
        //self.layer.contents = UIImage(named: "clouds.png")?.cgImage//#imageLiteral(resourceName: "clouds")
        
        currentTempLabel.text = tempToString(temp: currentWeather.temp)
        let dayTemp = LocString.Cell.today + tempToString(temp: dayForecast.temp.day)
        let nigthTemp = LocString.Cell.tonight + tempToString(temp: dayForecast.temp.night)
        dayNightTempLabel.text = dayTemp + AppConstants.dot + nigthTemp
        feelsTempLabel.text = LocString.Cell.feels_like + tempToString(temp: currentWeather.feelsLike)
        weatherDescriptLabel.text = currentWeather.weather.first?.description //dayForecast.weather.first?.description
        windLabel.text = "🚩 " /*LocString.Cell.wind*/ + String(format: "%.1f", currentWeather.windSpeed) + LocString.Cell.meters_in_sec
        
        weekDay.text = DateService.getDate(unixTime: currentWeather.dt, dateFormat: "EEEE, dd MMM")
        
        if delegate.useSystemIcons {
            setSystemIcon(strIcon: currentWeather.weather.first?.icon ?? "")
        } else {
            setImage(weather: currentWeather.weather) //setImage(weather: dayForecast.weather)
        }
    }
    
    func tempToString(temp: Double) -> String {
        var tempStr = String(format: "%.0f", temp)
        if tempStr == "-0" { tempStr = "0" }
        return tempStr + AppConstants.celsius
    }
    
//    private func setImage(weather: [Weather]) {
//
//
//        if let weather = weather.first, let image = delegate?.imageArray[weather.description] {
//            DispatchQueue.main.async {
//                self.weatherIconImage.image = image
//            }
//            return
//        }
//
//        guard let ico = weather.first?.icon else { return }
//        let stringURL = "https://openweathermap.org/img/wn/" + ico + "@2x.png"
//        ImageDownloader.downloadImage(stringURL: stringURL) { (imageData) in
//
//            DispatchQueue.main.async {
//                let image = UIImage(data: imageData)// ?? UIImage()
//                if let weather = weather.first {
//                    self.delegate?.imageArray[weather.description] = image
//                }
//                self.weatherIconImage.image = image
//            }
//
//        }
//    }
    
}

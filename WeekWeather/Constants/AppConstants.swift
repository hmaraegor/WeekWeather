//
//  Constants.swift
//  WeekWeather
//
//  Created by Egor on 20/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    static let dot = "・"
    static let celsius = "°C"
    static let twelveHoursInSeconds: Double = 28800
}

struct ColorScheme___ {
    struct Day {
        struct Image {
            let background = UIImage(imageLiteralResourceName: "clouds")
        }
        
        struct Color {
            let background: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let humidityIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let humidityLabel: UIColor = .darkGray
            let preasureIcon: UIColor = .gray
            let preasureLabel: UIColor = .darkGray
            let sunriseIcon: UIColor = #colorLiteral(red: 1, green: 0.7834197891, blue: 0, alpha: 0.6987639127)
            let sunriseLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let sunsetIcon: UIColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 0.6951519692)
            let sunsetLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let descriptLabel: UIColor = .darkGray
            let mornTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.4745098039, blue: 0, alpha: 1)
            let mornIcon: UIColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.5)
            let mornDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let dayTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.3607843137, blue: 0, alpha: 1)
            let dayIcon: UIColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.7441673801)
            let dayDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let eveTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.1215686275, blue: 0, alpha: 1)
            let eveIcon: UIColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 0.5241063784)
            let eveDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let nightTemp: UIColor = #colorLiteral(red: 0, green: 0.2352941176, blue: 0.4980392157, alpha: 1)
            let nightIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let nightDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        }
        
        struct Opacity {
            let background = 0.3
        }
    }
    
    struct Morning {
        let backgroundImage = UIImage(imageLiteralResourceName: "cloudsMorning")
        
    }
    
    struct Evening {
        let backgroundImage = UIImage(imageLiteralResourceName: "cloudsEvening")
        
    }
    
    struct Night {
        struct Image {
            let background1 = UIImage(imageLiteralResourceName: "stars")
            let background2 = UIImage(imageLiteralResourceName: "cloudsStarsNight")
        }
        
        struct Color {
            let background: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let humidityIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let humidityLabel: UIColor = .darkGray
            let preasureIcon: UIColor = .gray
            let preasureLabel: UIColor = .darkGray
            let sunriseIcon: UIColor = #colorLiteral(red: 1, green: 0.7834197891, blue: 0, alpha: 0.6987639127)
            let sunriseLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let sunsetIcon: UIColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 0.6951519692)
            let sunsetLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let descriptLabel: UIColor = .darkGray
            let mornTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.4745098039, blue: 0, alpha: 1)
            let mornIcon: UIColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.5)
            let mornDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let dayTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.3607843137, blue: 0, alpha: 1)
            let dayIcon: UIColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 0.7441673801)
            let dayDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let eveTemp: UIColor = #colorLiteral(red: 0.4980392157, green: 0.1215686275, blue: 0, alpha: 1)
            let eveIcon: UIColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 0.5241063784)
            let eveDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let nightTemp: UIColor = #colorLiteral(red: 0, green: 0.2352941176, blue: 0.4980392157, alpha: 1)
            let nightIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let nightDescr: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        }
        
        struct Opacity {
            let background1 = 1.0
        }
    }
}

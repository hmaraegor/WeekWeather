//
//  SchemeClasses.swift
//  WeekWeather
//
//  Created by Egor on 28/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

protocol BacisColorScheme {
    
        var backgroundImg: UIImage { get }
        
        var firstCellBgColor: UIColor { get }
        var cellBgColor: UIColor { get }
        var listTitleColor: UIColor { get }
        var extendInfoTitleColor: UIColor { get }
        var viewColor: UIColor { get }
        var tempLabel: UIColor { get }
        var descrLabel: UIColor { get }
        var humidityIcon: UIColor { get }
        var humidityLabel: UIColor { get }
        var preasureIcon: UIColor { get }
        var preasureLabel: UIColor { get }
        var sunriseIcon: UIColor { get }
        var sunriseLabel: UIColor { get }
        var sunsetIcon: UIColor { get }
        var sunsetLabel: UIColor { get }
        var mornTemp: UIColor { get }
        var mornIcon: UIColor { get }
        var mornDescr: UIColor { get }
        var dayTemp: UIColor { get }
        var dayIcon: UIColor { get }
        var dayDescr: UIColor { get }
        var eveTemp: UIColor { get }
        var eveIcon: UIColor { get }
        var eveDescr: UIColor { get }
        var nightTemp: UIColor { get }
        var nightIcon: UIColor { get }
        var nightDescr: UIColor { get }
    
        var backgroundImgOpacity: Double  { get }
}


class ClassColorSchemes {
    
    class Day: BacisColorScheme {
            let backgroundImg = UIImage(imageLiteralResourceName: "clouds")
       
            let firstCellBgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            let cellBgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            let listTitleColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            let extendInfoTitleColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            let viewColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let tempLabel: UIColor = .darkGray
            let descrLabel: UIColor = .darkGray
            let humidityIcon: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.5)
            let humidityLabel: UIColor = .darkGray
            let preasureIcon: UIColor = .gray
            let preasureLabel: UIColor = .darkGray
            let sunriseIcon: UIColor = #colorLiteral(red: 1, green: 0.7834197891, blue: 0, alpha: 0.6987639127)
            let sunriseLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            let sunsetIcon: UIColor = #colorLiteral(red: 1, green: 0.4352941176, blue: 0, alpha: 0.6951519692)
            let sunsetLabel: UIColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
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
        
        
        let backgroundImgOpacity = 0.3
    }
    
}


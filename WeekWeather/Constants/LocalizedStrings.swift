//
//  LocalizedStrings.swift
//  WeekWeather
//
//  Created by Egor on 20/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

struct LocString {
    
    struct Cell {
        static let day = NSLocalizedString("day ", comment: "day")
        static let today = NSLocalizedString("today ", comment: "today")
        static let tonight = NSLocalizedString("night ", comment: "night")
        static let night = NSLocalizedString("tonight ", comment: "tonight")
        static let wind = NSLocalizedString("wind: ", comment: "wind")
        static let metersInSec = NSLocalizedString("m/s", comment: "m/s")
        static let feelsLike = NSLocalizedString("feels like ", comment: "feels like")
    }
    
    struct Alert {
        static let locationError = NSLocalizedString("The current location cannot be displayed", comment: "Location error")
        static let locationAccessTitle = NSLocalizedString("Allow Location Access", comment: "Location error")
        static let locationAccessMessage = NSLocalizedString("WeekWeather needs access to your location. Turn on Location Services in your device settings.", comment: "Needs access")
        static let settings = NSLocalizedString("settings", comment: "settings")
    }
    
    struct Title {
        static let undefinedLocalion = NSLocalizedString("Undefine Place", comment: "Undefine Place")
    }
}

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
        static let today = NSLocalizedString("today ", comment: "today")
        static let tonight = NSLocalizedString("tonight ", comment: "tonight")
        static let wind = NSLocalizedString("wind: ", comment: "wind")
        static let metersInSec = NSLocalizedString("m/s", comment: "m/s")
        static let feelsLike = NSLocalizedString("Feels like ", comment: "Feels like")
    }
    
    struct Alert {
        static let locationError = NSLocalizedString("The current location cannot be displayed", comment: "Location error")
        static let locationAccessTitle = NSLocalizedString("Allow Location Access", comment: "Location error")
        static let locationAccessMessage = NSLocalizedString("WeekWeather needs access to your location. Turn on Location Services in your device settings.", comment: "Needs access")
        static let settings = NSLocalizedString("settings", comment: "settings")
    }
}

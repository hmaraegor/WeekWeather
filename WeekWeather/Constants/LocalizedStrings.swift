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
        static let tonight = NSLocalizedString("tonight ", comment: "tonight")
        static let night = NSLocalizedString("night ", comment: "night")
        static let wind = NSLocalizedString("wind: ", comment: "wind")
        static let meters_in_sec = NSLocalizedString("m/s", comment: "m/s")
        static let feels_like = NSLocalizedString("feels like ", comment: "feels like")
    }
    
    struct Alert {
        static let location_error = NSLocalizedString("The current location cannot be displayed", comment: "Location error")
        static let location_access_title = NSLocalizedString("Allow Location Access", comment: "Location error")
        static let location_access_message = NSLocalizedString("WeekWeather needs access to your location. Turn on Location Services in your device settings.", comment: "Needs access")
        static let settings = NSLocalizedString("settings", comment: "settings")
    }
    
    struct Title {
        static let undefined_localion = NSLocalizedString("Undefine Place", comment: "Undefine Place")
    }
    
    struct WeatherInfo {
        static let morning = NSLocalizedString("morning", comment: "morning")
        static let day = NSLocalizedString("day", comment: "day")
        static let evening = NSLocalizedString("evening", comment: "evening")
        static let night = NSLocalizedString("night", comment: "night")
    }
}

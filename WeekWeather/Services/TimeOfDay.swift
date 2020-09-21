//
//  TimeOfDay.swift
//  WeekWeather
//
//  Created by Egor on 14/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

enum TimeOfDay {
    case morning
    case day
    case evening
    case night
    
    static var timeOfDay: TimeOfDay {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if (6..<12).contains(hour){
            return .morning
        }
        else if (12..<17).contains(hour) {
            return .day
        }
        else if (17..<22).contains(hour) {
            return .evening
        }
        else if (22..<6).contains(hour) {
            return .night
        }
    }
    
    static func getCurrentTemp(temp: Temp?) -> Double {
        guard let temp = temp else { return 0 }
        switch timeOfDay {
        case .morning:
            return temp.morn
        case .day:
            return temp.day
        case .evening:
            return temp.eve
        case .night:
            return temp.night
        }
    }
}

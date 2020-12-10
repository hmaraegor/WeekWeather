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
        let hour = DateService.currentHours()
//        print("Hour: ", hour)
        
        if (6..<12).contains(hour){
            return .morning
        }
        else if (12..<17).contains(hour) {
            return .day
        }
        else if (17..<22).contains(hour) {
            return .evening
        }
        else if (22...23).contains(hour) || (0..<6).contains(hour) {
            return .night
        }
        return .day
    }
    
    static func timeOfDayFromSun(sunrise: Double, sunset: Double) -> TimeOfDay {
        //let time = Date().timeIntervalSince1970
        let time = DateService.currentHours() * 60 + DateService.currentMinutes()
        
        //print("sunrise:", DateService.hours(fromUnix: sunrise), ":", DateService.minutes(fromUnix: sunrise))
        let sunrise /*sunriseInMinutes*/ = DateService.hours(fromUnix: sunrise) * 60 + DateService.minutes(fromUnix: sunrise)
        
        //print("sunset:", DateService.hours(fromUnix: sunset), ":", DateService.minutes(fromUnix: sunset))
        var newSunset: Int
        if DateService.hours(fromUnix: sunset) != 0 {
            newSunset /*sunriseInMinutes*/ = DateService.hours(fromUnix: sunset) * 60 + DateService.minutes(fromUnix: sunset)
        } else {
            newSunset = 24 * 60 + DateService.minutes(fromUnix: sunset)
        }
        //let sunset /*sunsetInMinutes*/ = DateService.hours(fromUnix: sunset) * 60 + DateService.minutes(fromUnix: sunset)
        //print("Time:", DateService.currentHours(), ":", DateService.currentMinutes())
        if (time < sunrise){
            return .night
        }
        else if (time > sunrise) && (time < newSunset) {
            return .day
        }
        else if (time > newSunset) {
            return .night
        }
        return .day
    }
    
    static func getCurrentTemp(temp: Temp?) -> Double {
        guard let temp = temp else { return 0 }
        //print("timeOfDay: ", timeOfDay)
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

//
//  DateService.swift
//  WeekWeather
//
//  Created by Egor on 14/09/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

class DateService {
    static func getDate(unixTime: Double, dateFormat: String?) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.full //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.full //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = dateFormat
        
        let locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages.first!)
        dateFormatter.locale = locale as Locale?
        let localDate = dateFormatter.string(from: date as Date)
        
        return localDate
    }
    
    static func currentHours() -> Int  {
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        return hours
    }
    
    static func currentMinutes() -> Int  {
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        return minutes
    }
    
    static func hours(fromUnix unixTime: Double) -> Int  {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date(fromUnix: unixTime))
        return hours
    }
    
    static func minutes(fromUnix unixTime: Double) -> Int {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date(fromUnix: unixTime))
        return minutes
    }
    
    static func date(fromUnix unixTime: Double) -> Date {
        let date = Date(timeIntervalSince1970: unixTime)
        return date
    }
    
    static func unix(fromDate date: Date) -> Double {
        let unixTime = date.timeIntervalSince1970
        return unixTime
    }
}



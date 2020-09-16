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
}



//
//  TemperatureService.swift
//  WeekWeather
//
//  Created by Egor on 26.01.2021.
//  Copyright © 2021 Egor. All rights reserved.
//

import Foundation

typealias TempS = TemperatureService

class TemperatureService {
    static func tempToString(temp: Double) -> String {
        var tempStr = String(format: "%.0f", temp)
        if tempStr == "-0" { tempStr = "0" }
        return tempStr + AppConstants.celsius
    }
}

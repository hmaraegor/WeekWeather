//
//  WeekForecast.swift
//  WeekWeather
//
//  Created by Egor on 19/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

struct WeekForecast: Codable {
    let daily: [DayForecast]
    let current: Current
    
    init() {
        daily = [DayForecast]()
        current = Current()
    }
}

struct Current: Codable {
    let dt: Double
    let temp: Double
    let feelsLike: Double
    let weather: [Weather]
    let windSpeed: Double
    
    init() {
        dt = 0
        temp = 0
        feelsLike = 0
        windSpeed = 0
        weather = [Weather]()
    }
}

struct DayForecast: Codable {
    let dt: Double
    let temp: Temp
    let feelsLike: Temp
    let windSpeed: Double
    let weather: [Weather]
    
    init() {
        dt = 0
        temp = Temp()
        feelsLike = Temp()
        windSpeed = 0
        weather = [Weather]()
    }
}

struct Temp: Codable {
    let day: Double
    let night: Double
    
    init() {
        day = 0
        night = 0
    }
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
    
    init() {
        main = ""
        description = ""
        icon = ""
    }
}

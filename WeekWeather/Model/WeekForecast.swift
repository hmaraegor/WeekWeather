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
}

struct DayForecast: Codable {
    let temp: Temp
    let feelsLike: Temp
    let windSpeed: Double
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case weather
    }
    
}

struct Temp: Codable {
    let day: Double
    let night: Double
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

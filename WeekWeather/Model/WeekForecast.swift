//
//  WeekForecast.swift
//  WeekWeather
//
//  Created by Egor on 19/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

struct WeekForecast: Codable {
    var daily: [DayForecast]
    var current: CurrentWeather
}

struct CurrentWeather: Codable {
    let dt: Double
    let temp: Double
    let feelsLike: Double
    let windSpeed: Double
    let weather: [Weather]
    let sunrise: Double
    let sunset: Double
    let pressure: Double
    let humidity: Double
}

struct DayForecast: Codable {
    let dt: Double
    let temp: Temp
    let feelsLike: Temp
    let windSpeed: Double
    var weather: [Weather]
    let sunrise: Double
    let sunset: Double
    let pressure: Double
    let humidity: Double
}

struct Temp: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct Weather: Codable {
    let main: String
    let description: String
    var icon: String
}

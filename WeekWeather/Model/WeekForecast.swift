//
//  WeekForecast.swift
//  WeekWeather
//
//  Created by Egor on 19/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

struct WeekForecast: Codable {
    //let
    var daily: [DayForecast]
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let dt: Double
    let temp: Double
    let feelsLike: Double
    let weather: [Weather]
    let windSpeed: Double
}

struct DayForecast: Codable {
    let dt: Double
    let temp: Temp
    let feelsLike: Temp
    let windSpeed: Double
    //let
    var weather: [Weather]
}

struct Temp: Codable {
    let day: Double
    let night: Double
}

struct Weather: Codable {
    let main: String
    let description: String
    //let
    var icon: String
}

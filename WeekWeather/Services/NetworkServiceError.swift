//
//  NetworkServiceError.swift
//  WeekWeather
//
//  Created by Egor on 19/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
    case badURL
    case noResponse
    case noData
    case jsonDecoding
    case networkError
    case badResponse
}

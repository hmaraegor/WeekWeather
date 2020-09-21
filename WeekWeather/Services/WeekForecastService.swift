//
//  WeekForecastService.swift
//  WeekWeather
//
//  Created by Egor on 19/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreLocation

class WeekForecastService {
    private let networkService = NetworkService()
           
    func getForecast(params: [String: Any]?, completionHandler:
    @escaping (WeekForecast?, Error?) -> ()) {
        let url = "https://api.openweathermap.org/data/2.5/onecall"
        let locale = String(Locale.preferredLanguages[0].prefix(2))//Locale.current.languageCode!
        
        var parameters = ["exclude":"minutely,hourly", "units":"metric", "appid":"2ff71b60a20dc621c22b68a665801ccf", "lang":locale] as [String : Any]
        guard let inputParams = params else {
            completionHandler(nil, LocationServiceError.badLocation)
            return
        }
        
        parameters.merge(dict: inputParams)
        
        let completion = { (result: Result<WeekForecast, NetworkServiceError>) in
            switch result {
            case .success(let returnedContentList):
                completionHandler(returnedContentList, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
        networkService.get(url: url, params: parameters, completion)
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

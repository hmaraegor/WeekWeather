//
//  DownloadService.swift
//  WeekWeather
//
//  Created by Egor on 25/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

class DownloadService {
    private let networkService = NetworkService()
           
    func getForecast<T: Codable>(url: String, params: [String: Any]?, completionHandler:
    @escaping (T?, Error?) -> ()) {
        
        let completion = { (result: Result<T, NetworkServiceError>) in
            switch result {
            case .success(let returnedContentList):
                completionHandler(returnedContentList, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
        networkService.get(url: url, params: params, completion)
    }
}

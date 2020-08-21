//
//  NetworkService.swift
//  WeekWeather
//
//  Created by Egor on 19/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

class NetworkService {
    
    typealias Completion<T: Codable> = (Result<T, NetworkServiceError>) -> ()
    
    func get<T: Codable>(url: String, params: [String: Any]?, _ completion: @escaping Completion<T>) {
        performHTTPRequest(url: url, method: "GET", params: params, completion)
    }
    
    // MARK: - Private
    private func performHTTPRequest<T: Codable>(url: String, method: String, params inputParams: [String: Any]?, _ completion: @escaping Completion<T>) {
        
        let strUrl = url
       guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        var items = [URLQueryItem]()
        var myURL = URLComponents(string: strUrl)
        
        var parameters = [String: Any]()
        if inputParams != nil { parameters = inputParams! }
        
        for (key,value) in parameters {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        myURL?.queryItems = items
        let request =  URLRequest(url: (myURL?.url)!)
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response else {
                completion(.failure(.noResponse))
                return }
            guard let data = data else {
                completion(.failure(.noData))
                return }
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.badResponse))
                    print("Status code: ", (response as? HTTPURLResponse)?.statusCode)
                    return
            }
            
            // MARK: - Decoding data and return object
            DecodeService().decodeData(data: data, completionHandler: completion)
            
        }.resume()
    }
}

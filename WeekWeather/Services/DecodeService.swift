//
//  DecodeService.swift
//  WeekWeather
//
//  Created by Egor on 19/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

class DecodeService {
    
    func decodeData<T: Codable>(data: Data, completionHandler:
        @escaping (Result<T, NetworkServiceError>) -> ()) {
        
        
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print("json\n", json)
//                    } catch {
//                        print("json error")
//                    }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
            do {
                let daylyWeather = try decoder.decode(T.self, from: data)
                completionHandler(.success(daylyWeather))
            } catch {
                completionHandler(.failure(.jsonDecoding))
            }
        
    }
    
}

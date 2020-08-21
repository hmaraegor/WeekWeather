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
        
        
            do {
                let gistList = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(gistList))
            } catch {
                completionHandler(.failure(.jsonDecoding))
            }
        
    }
    
}

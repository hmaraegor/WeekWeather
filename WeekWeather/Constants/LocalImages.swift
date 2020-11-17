//
//  LocalImages.swift
//  WeekWeather
//
//  Created by Egor on 16.11.2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

struct  LocalImages {
    
    private static let localImages: [String : String] = [ "04n": "cloudsBrokenNight", "03n": "cloudsNight", "02n" : "moonClouds", "01n" : "moonLighter", "13n" : "cloudSnowflakeNight", "11n" : "lightningCloudNight", "50n" : "cloudsNight", "09n" : "happyRainCloudNight", "10n" : "moonRainClouds", "04d": "cloudsBroken", "03d": "happyCloud", "02d": "sunClouds", "01d": "sun", "13d": "cloudSnowflake", "50d": "cloudsDay", "10d": "rainClounsSun", "09d": "happyRainCloud" ]
    
    static func getImage(by icon: String) -> UIImage {
        guard let imageName = localImages[icon] else { return UIImage() }
        return UIImage(imageLiteralResourceName: imageName)
    }
}

//
//  Icons.swift
//  WeekWeather
//
//  Created by Egor on 23.01.2021.
//  Copyright © 2021 Egor. All rights reserved.
//

import Foundation

//MARK: ________________________ Json model ________________________

class Icons: Codable {
    var useNewIcons: Bool!
    var folder: String!
    var dayIcons: [String : String]!
    var nightIcons: [String : String]!
    var showPreasureHumidity: Bool!
    var showSunPhases: Bool!
    
    init(useNewIcons: Bool, folder: String, dayIcons: [String : String], nightIcons: [String : String],
         showPreasureHumidity: Bool = true, showSunPhases: Bool = true) {
        self.useNewIcons = useNewIcons
        self.folder = folder
        self.dayIcons = dayIcons
        self.nightIcons = nightIcons
        self.showPreasureHumidity = showPreasureHumidity
        self.showSunPhases = showSunPhases
    }
}

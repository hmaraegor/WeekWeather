//
//  WeatherMO+CoreDataProperties.swift
//  WeekWeather
//
//  Created by Egor on 31/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreData

extension WeatherMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherMO> {
        return NSFetchRequest<WeatherMO>(entityName: "WeatherMO")
    }
    
    @NSManaged public var main: String
    @NSManaged public var descript: String
    @NSManaged public var icon: String

}

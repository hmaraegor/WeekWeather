//
//  DayForecastMO+CoreDataProperties.swift
//  WeekWeather
//
//  Created by Egor on 31/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreData


extension DayForecastMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayForecastMO> {
        return NSFetchRequest<DayForecastMO>(entityName: "DayForecastMO")
    }
    
    @NSManaged public var dt: Double
    @NSManaged public var temp: TempMO
    @NSManaged public var feelsLike: TempMO
    @NSManaged public var windSpeed: Double
    @NSManaged public var weather: WeatherMO

}

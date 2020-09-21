//
//  WeatherMO+CoreDataClass.swift
//  WeekWeather
//
//  Created by Egor on 31/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreData

@objc(WeatherMO)
public class WeatherMO: NSManagedObject {
    
    convenience init() {
        let entity = CoreDataManager.shared.entityForName(entityName: "WeatherMO")
        self.init(entity: entity, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
     }
}

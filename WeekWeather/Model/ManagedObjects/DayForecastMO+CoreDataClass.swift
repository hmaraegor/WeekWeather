//
//  DayForecastMO+CoreDataClass.swift
//  WeekWeather
//
//  Created by Egor on 31/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreData

@objc(DayForecastMO)
public class DayForecastMO: NSManagedObject {
    
    convenience init() {
        let entity = CoreDataManager.shared.entityForName(entityName: "DayForecastMO")
        self.init(entity: entity, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
     }
}

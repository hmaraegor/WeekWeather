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
         // Описание сущности
        let entity = CoreDataManager.shared.entityForName(entityName: "WeatherMO")
        //let entity = NSEntityDescription.entity(forEntityName: "Temperature", in: CoreDataManager.shared.persistentContainer.viewContext)
    
         // Создание нового объекта
        self.init(entity: entity!, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
     }
}

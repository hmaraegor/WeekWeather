//
//  TempMO+CoreDataProperties.swift
//  WeekWeather
//
//  Created by Egor on 31/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreData

extension TempMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TempMO> {
        return NSFetchRequest<TempMO>(entityName: "TempMO")
    }
    
    @NSManaged public var day: Double
    @NSManaged public var night: Double
    @NSManaged public var eve: Double
    @NSManaged public var morn: Double

}

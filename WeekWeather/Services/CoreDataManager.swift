//
//  CoreDataManager.swift
//  WeekWeather
//
//  Created by Egor on 31/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Singleton
    static let shared = CoreDataManager()
    
    private init() {}
    
    // Entity for Name
    func entityForName(entityName: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.persistentContainer.viewContext)
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "WeekWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("ERROR\nERROR\nERROR\nsaveContext:\n")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

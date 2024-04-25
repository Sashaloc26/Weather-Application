//
//  AppDelegate.swift
//  Weather
//
//  Created by Саша Тихонов on 06/12/2023.
//

import UIKit
import CoreData

@main
    class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataManager.shared.addCity(1, name: "Minsk")
        CoreDataManager.shared.addCity(2, name: "Lodz")
        CoreDataManager.shared.addCity(3, name: "Moscow")
        CoreDataManager.shared.addCities(CitiesData().citiesData)
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { description, error in
            if let error {
                print(error.localizedDescription)
            } else {
                print("DB url - ", description.url?.absoluteString as Any)
            }
        }
        
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

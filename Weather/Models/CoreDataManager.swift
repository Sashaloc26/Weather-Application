import Foundation
import CoreData
import UIKit

public final class CoreDataManager {
    public static let shared = CoreDataManager()
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func addCity(_ id: Int16, name: String) {
        guard let cityEntityDescriptiron = NSEntityDescription.entity(forEntityName: "CitiesEntity", in: context) else {
            return
        }
        let city = CitiesEntity(entity: cityEntityDescriptiron, insertInto: context)
        city.id = id
        city.name = name
        
        appDelegate.saveContext()
    }
    
    public func addCities(_ cities: [(id: Int16, name: String)]) {
        guard let cityEntityDescription = NSEntityDescription.entity(forEntityName: "CitiesEntity", in: context) else {
            return
        }
        
        for cityData in cities {
            let city = CitiesEntity(entity: cityEntityDescription, insertInto: context)
            city.id = cityData.id
            city.name = cityData.name
        }
        
        appDelegate.saveContext()
    }
    
    public func lastChoicedCity(lastChoicedCity: String) {
        guard let cityEntityDescription = NSEntityDescription.entity(forEntityName: "CitiesEntity", in: context) else {
            return
        }
        
        if let existingLastChoicedCity = fetchLastChoicedCity() {
            context.delete(existingLastChoicedCity)
        }
        
        let city = CitiesEntity(entity: cityEntityDescription, insertInto: context)
        city.lastChoicedCity = lastChoicedCity
        
        appDelegate.saveContext()
    }
    
    public func fetchLastChoicedCity() -> CitiesEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        fetchRequest.predicate = NSPredicate(format: "lastChoicedCity != nil")
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first as? CitiesEntity
        } catch {
            print("Error fetching last choiced city: \(error)")
            return nil
        }
    }
    
    public func fetchCities() -> [CitiesEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        do {
            return (try? context.fetch(fetchRequest) as? [CitiesEntity]) ?? []
        }
    }
    
    public func deleteLastChoicedCity() {
        if let existingLastChoicedCity = fetchLastChoicedCity() {
            do {
                context.delete(existingLastChoicedCity)
                try context.save()
            } catch {
                print("Error deleting last choiced city: \(error.localizedDescription)")
            }
        }
    }
    
    public func fetchCity(with  id: Int16) -> CitiesEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        //        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let citites = try? context.fetch(fetchRequest) as? [CitiesEntity]
            return citites?.first(where: {$0.id == id} )
        }
    }
    
    public func fetchCitiesWithName(with name: String) -> [CitiesEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        fetchRequest.predicate = NSPredicate(format: "name BEGINSWITH[cd] %@", name)
        
        do {
            if let cities = try context.fetch(fetchRequest) as? [CitiesEntity] {
                let uniqueAndMatchingCities = cities
                    .reduce(into: [CitiesEntity]()) { result, city in
                        if !result.contains(where: { $0.name == city.name }) {
                            result.append(city)
                        }
                    }
                    .prefix(5)
                
                return Array(uniqueAndMatchingCities)
            }
        } catch {
            print("Error fetching cities: \(error)")
        }
        
        return []
    }
    
    public func updateCity(with id: Int16, newName: String? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            guard let citites = try? context.fetch(fetchRequest) as? [CitiesEntity],
                  let city = citites.first/*(where: {$0.id == id} )*/ else { return }
            city.name = newName
        }
        
        appDelegate.saveContext()
    }
    
    public func deleteCity(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let citites = try? context.fetch(fetchRequest) as? [CitiesEntity],
                  let city = citites.first/*(where: {$0.id == id})*/ else { return }
            context.delete(city)
        }
        appDelegate.saveContext()
    }
    
    func searchCity(withName cityName: String) -> CitiesEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", cityName)
        
        do {
            let citites = try? context.fetch(fetchRequest) as? [CitiesEntity]
            return citites?.first/*(/*where: {$0.id == id} )*/*/
        }
    }
    
    func cityExists(withName name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CitiesEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error fetching data: \(error)")
            return false
        }
    }
}

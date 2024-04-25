//
//  CitiesEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Саша Тихонов on 30/12/2023.
//
//

import Foundation
import CoreData

@objc(CitiesEntity)
public class CitiesEntity: NSManagedObject {

}

extension CitiesEntity {
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var lastChoicedCity: String?


}

extension CitiesEntity : Identifiable {}

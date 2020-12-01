//
//  BusStop+CoreDataProperties.swift
//  Navigem
//
//  Created by Ryan The on 1/12/20.
//
//

import Foundation
import CoreData


extension BusStop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusStop> {
        return NSFetchRequest<BusStop>(entityName: "BusStop")
    }

    @NSManaged public var busStopCode: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var roadDesc: String?
    @NSManaged public var roadName: String?

}

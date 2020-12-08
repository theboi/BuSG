//
//  BusStop+CoreDataProperties.swift
//  BuSG
//
//  Created by Ryan The on 7/12/20.
//
//

import Foundation
import CoreData


extension BusStop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusStop> {
        return NSFetchRequest<BusStop>(entityName: "BusStop")
    }

    @NSManaged public var busStopCode: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var roadDesc: String
    @NSManaged public var roadName: String
    @NSManaged public var busRoutes: NSSet?

}

// MARK: Generated accessors for busRoutes
extension BusStop {

    @objc(addBusRoutesObject:)
    @NSManaged public func addToBusRoutes(_ value: BusRoute)

    @objc(removeBusRoutesObject:)
    @NSManaged public func removeFromBusRoutes(_ value: BusRoute)

    @objc(addBusRoutes:)
    @NSManaged public func addToBusRoutes(_ values: NSSet)

    @objc(removeBusRoutes:)
    @NSManaged public func removeFromBusRoutes(_ values: NSSet)

}

extension BusStop : Identifiable {

}

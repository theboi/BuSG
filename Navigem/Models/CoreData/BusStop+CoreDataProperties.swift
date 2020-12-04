//
//  BusStop+CoreDataProperties.swift
//  Navigem
//
//  Created by Ryan The on 4/12/20.
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
    @NSManaged public var busRoute: NSSet

}

// MARK: Generated accessors for busRoute
extension BusStop {

    @objc(addBusRouteObject:)
    @NSManaged public func addToBusRoute(_ value: BusRoute)

    @objc(removeBusRouteObject:)
    @NSManaged public func removeFromBusRoute(_ value: BusRoute)

    @objc(addBusRoute:)
    @NSManaged public func addToBusRoute(_ values: NSSet)

    @objc(removeBusRoute:)
    @NSManaged public func removeFromBusRoute(_ values: NSSet)

}

extension BusStop : Identifiable {

}

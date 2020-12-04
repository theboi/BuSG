//
//  BusService+CoreDataProperties.swift
//  Navigem
//
//  Created by Ryan The on 4/12/20.
//
//

import Foundation
import CoreData


extension BusService {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusService> {
        return NSFetchRequest<BusService>(entityName: "BusService")
    }

    @NSManaged public var amOffpeakFreq: String
    @NSManaged public var amPeakFreq: String
    @NSManaged public var destinationCode: String
    @NSManaged public var direction: Int64
    @NSManaged public var loopDesc: String
    @NSManaged public var originCode: String
    @NSManaged public var pmOffpeakFreq: String
    @NSManaged public var pmPeakFreq: String
    @NSManaged public var rawCategory: String
    @NSManaged public var rawServiceOperator: String
    @NSManaged public var serviceNo: String
    @NSManaged public var busRoute: NSSet

}

// MARK: Generated accessors for busRoute
extension BusService {

    @objc(addBusRouteObject:)
    @NSManaged public func addToBusRoute(_ value: BusRoute)

    @objc(removeBusRouteObject:)
    @NSManaged public func removeFromBusRoute(_ value: BusRoute)

    @objc(addBusRoute:)
    @NSManaged public func addToBusRoute(_ values: NSSet)

    @objc(removeBusRoute:)
    @NSManaged public func removeFromBusRoute(_ values: NSSet)

}

extension BusService : Identifiable {

}

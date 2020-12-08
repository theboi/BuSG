//
//  BusService+CoreDataProperties.swift
//  BuSG
//
//  Created by Ryan The on 7/12/20.
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
    @NSManaged public var busRoutes: NSSet?

}

// MARK: Generated accessors for busRoutes
extension BusService {

    @objc(addBusRoutesObject:)
    @NSManaged public func addToBusRoutes(_ value: BusRoute)

    @objc(removeBusRoutesObject:)
    @NSManaged public func removeFromBusRoutes(_ value: BusRoute)

    @objc(addBusRoutes:)
    @NSManaged public func addToBusRoutes(_ values: NSSet)

    @objc(removeBusRoutes:)
    @NSManaged public func removeFromBusRoutes(_ values: NSSet)

}

extension BusService : Identifiable {

}

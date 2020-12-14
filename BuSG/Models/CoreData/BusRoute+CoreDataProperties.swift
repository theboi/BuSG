//
//  BusRoute+CoreDataProperties.swift
//  BuSG
//
//  Created by Ryan The on 14/12/20.
//
//

import Foundation
import CoreData


extension BusRoute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRoute> {
        return NSFetchRequest<BusRoute>(entityName: "BusRoute")
    }

    @NSManaged public var busStopCode: String
    @NSManaged public var direction: Int64
    @NSManaged public var distance: Double
    @NSManaged public var rawServiceOperator: String
    @NSManaged public var rawSatFirstBus: String
    @NSManaged public var rawSatLastBus: String
    @NSManaged public var serviceNo: String
    @NSManaged public var stopSequence: Int64
    @NSManaged public var rawSunFirstBus: String
    @NSManaged public var rawSunLastBus: String
    @NSManaged public var rawWdFirstBus: String
    @NSManaged public var rawWdLastBus: String
    @NSManaged public var busService: BusService?
    @NSManaged public var busStop: BusStop?

}

extension BusRoute : Identifiable {

}

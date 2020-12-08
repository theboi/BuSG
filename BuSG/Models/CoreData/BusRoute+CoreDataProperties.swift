//
//  BusRoute+CoreDataProperties.swift
//  BuSG
//
//  Created by Ryan The on 7/12/20.
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
    @NSManaged public var satFirstBus: String
    @NSManaged public var satLastBus: String
    @NSManaged public var serviceNo: String
    @NSManaged public var stopSequence: Int64
    @NSManaged public var sunFirstBus: String
    @NSManaged public var sunLastBus: String
    @NSManaged public var wdFirstBus: String
    @NSManaged public var wdLastBus: String
    @NSManaged public var busService: BusService?
    @NSManaged public var busStop: BusStop?

}

extension BusRoute : Identifiable {

}

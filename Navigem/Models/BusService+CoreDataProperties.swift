//
//  BusService+CoreDataProperties.swift
//  Navigem
//
//  Created by Ryan The on 1/12/20.
//
//

import Foundation
import CoreData


extension BusService {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusService> {
        return NSFetchRequest<BusService>(entityName: "BusService")
    }

    @NSManaged public var serviceNumber: String?
    @NSManaged public var busOperator: String?
    @NSManaged public var category: String?
    @NSManaged public var direction: String?
    @NSManaged public var originCode: String?
    @NSManaged public var destinationCode: String?
    @NSManaged public var amPeakFreq: String?
    @NSManaged public var pmPeakFreq: String?
    @NSManaged public var amOffpeakFreq: String?
    @NSManaged public var pmOffpeakFreq: String?
    @NSManaged public var loopDesc: String?

}

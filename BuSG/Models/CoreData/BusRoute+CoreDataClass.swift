//
//  BusRoute+CoreDataClass.swift
//   BuSG
//
//  Created by Ryan The on 4/12/20.
//
//

import Foundation
import CoreData

@objc(BusRoute)
public class BusRoute: NSManagedObject {
    
    public var busService: BusService? {
        get {
            rawBusService?.accessorBusRoute = self
            return rawBusService
        }
        set {
            rawBusService = newValue
        }
    }
    
    public var busStop: BusStop? {
        get {
            rawBusStop?.accessorBusRoute = self
            return rawBusStop
        }
        set {
            rawBusStop = newValue
        }
    }
    
}

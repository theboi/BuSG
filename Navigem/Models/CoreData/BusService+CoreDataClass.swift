//
//  BusService+CoreDataClass.swift
//  Navigem
//
//  Created by Ryan The on 4/12/20.
//
//

import UIKit
import CoreData

@objc(BusService)
public class BusService: NSManagedObject {
    
    public var busStops: [BusStop] {
        let context = self.managedObjectContext
        let routeReq: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
        routeReq.predicate = NSPredicate(format: "serviceNo == %@", serviceNo)
        do {
            let busRoute = try context?.fetch(routeReq).first
            let stopReq: NSFetchRequest<BusStop> = BusStop.fetchRequest()
            stopReq.predicate = NSPredicate(format: "busStopCode == %@", busRoute!.busStopCode)
            return try context?.fetch(stopReq) ?? []
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}

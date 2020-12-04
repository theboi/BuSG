//
//  BusStop+CoreDataClass.swift
//  Navigem
//
//  Created by Ryan The on 4/12/20.
//
//

import Foundation
import CoreData

@objc(BusStop)
public class BusStop: NSManagedObject {
    public var busServices: [BusService] {
        let context = self.managedObjectContext
        let routeReq: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
        routeReq.predicate = NSPredicate(format: "busStopCode == %@", busStopCode)
        do {
            let busRoute = try context?.fetch(routeReq).first
            let stopReq: NSFetchRequest<BusService> = BusService.fetchRequest()
            stopReq.predicate = NSPredicate(format: "serviceNo == %@", busRoute!.serviceNo)
            return try context?.fetch(stopReq) ?? []
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

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
        let context = self.managedObjectContext!
        let routeReq: NSFetchRequest<BusRoute> = BusRoute.fetchRequest()
        routeReq.predicate = NSPredicate(format: "busStopCode == %@", busStopCode)
        do {
            let busRoutes = try context.fetch(routeReq)
            return busRoutes.map({ (busRoute) -> BusService in
                let stopReq: NSFetchRequest<BusService> = BusService.fetchRequest()
                stopReq.predicate = NSPredicate(format: "serviceNo == %@", busRoute.serviceNo)
                do {
                    return try context.fetch(stopReq).first!
                } catch {
                    fatalError(error.localizedDescription)
                }
            })
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

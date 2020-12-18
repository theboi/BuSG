//
//  BusStop+CoreDataClass.swift
//   BuSG
//
//  Created by Ryan The on 4/12/20.
//
//

import Foundation
import CoreData

@objc(BusStop)
public class BusStop: NSManagedObject {
    
    public var accessorBusRoute: BusRoute?

    public var busServices: [BusService] {
        if let busRoutes = busRoutes?.allObjects as? [BusRoute] {
            var busServices: [BusService] = []
            for busRoute in busRoutes {
                let busServiceBusRoutes = busRoute.busService?.busRoutes?.allObjects as! [BusRoute]
                if (busRoute.stopSequence == busServiceBusRoutes.filter({ $0.direction == 1 }).count && busRoute.direction == 1) || (busRoute.stopSequence == busServiceBusRoutes.filter({ $0.direction == 2 }).count && busRoute.direction == 2) { continue }
                
                if let busService = busRoute.busService {
                    busServices.append(busService)
                }
            }
            return busServices.sorted {
                $0.serviceNo.localizedStandardCompare($1.serviceNo) == .orderedAscending
            }
        }
        return []
    }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var roadDesc: String {
        rawRoadDesc.capitalized
    }
    
    public var roadName: String {
        rawRoadName.capitalized
    }
}

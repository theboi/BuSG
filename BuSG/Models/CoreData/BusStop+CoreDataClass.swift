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
        if let busRoutes = busRoutes, busRoutes.count > 0 {
            var busServices: [BusService] = []
            for busRoute in (busRoutes.allObjects as! [BusRoute]) {
                if let busService = busRoute.busService {
                    busService.accessorBusRoute = busRoute
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

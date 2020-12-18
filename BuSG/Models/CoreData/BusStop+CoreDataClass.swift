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

    public var _busServices = [BusService]()
    
    public var busServices: [BusService] {
        get {
            if _busServices.count > 0 { return _busServices }
            if let busRoutes = busRoutes?.allObjects as? [BusRoute] {
                _busServices = busRoutes.filter({ (busRoute) -> Bool in
                    let busServiceBusRoutes = busRoute.busService?.busRoutes?.allObjects as! [BusRoute]
                    return !(busRoute.stopSequence == busServiceBusRoutes.filter({ $0.direction == 1 }).count && busRoute.direction == 1) || (busRoute.stopSequence == busServiceBusRoutes.filter({ $0.direction == 2 }).count && busRoute.direction == 2)
                }).sorted {
                    $0.serviceNo.localizedStandardCompare($1.serviceNo) == .orderedAscending
                }.compactMap({
                    $0.busService
                })
            }
            return _busServices
        }
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

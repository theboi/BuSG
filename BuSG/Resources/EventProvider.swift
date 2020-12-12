//
//  EventProvider.swift
//  BuSG
//
//  Created by Ryan The on 8/12/20.
//

import EventKit

class EventProvider {
    
    static let shared = EventProvider()
    
    lazy var store: EKEventStore = {
        let store = EKEventStore()
        store.requestAccess(to: .event) { granted, error in
            
        }
        return store
    }()
    
    public func presentDayCalendarEvents() -> [EKEvent] {
        let calendar = Calendar.current
        
        let todayStart = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let todayEnd = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!

        let predicate = store.predicateForEvents(withStart: todayStart, end: todayEnd, calendars: nil)
        let events = store.events(matching: predicate)
        return events
    }
}

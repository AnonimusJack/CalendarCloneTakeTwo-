//
//  JFTEventSearchEngine.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 01/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation


class JFTEventSearchEngine
{
    private static func getAllEvents() -> [JFTEvent]
    {
        var events: [JFTEvent] = []
        for calendar in JFTCalendar.LocalCalendars
        {
            for event in calendar.Events
            {
                events.append(event)
            }
        }
        return events
    }
    
    static func SearchForEventBy(name: String) -> Dictionary<String,[JFTEvent]>
    {
        let events = JFTEventSearchEngine.getAllEvents()
        var foundEvents: [JFTEvent] = []
        for event in events
        {
            if event.Title.contains(name)
            {
                foundEvents.append(event)
            }
        }
        return JFTEventSearchEngine.sortByDate(events: foundEvents)
    }
    
    private static func sortByDate(events: [JFTEvent]) -> Dictionary<String,[JFTEvent]>
    {
        var sortedEvents: Dictionary<String,[JFTEvent]> = [:]
        for event in events
        {
            let eventDate = JFTEvent.JSONDateFormatter.string(from: event.StartTime)
            if sortedEvents[eventDate] != nil
            {
                sortedEvents[eventDate]!.append(event)
            }
            else
            {
                sortedEvents.updateValue([event], forKey: eventDate)
            }
        }
        return sortedEvents
    }
}

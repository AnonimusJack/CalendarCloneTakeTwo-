//
//  JFTCalendar.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
import Foundation
import UIKit

class JFTCalendar: JFTJSONSerializable
{
    func Serialize() -> Dictionary<String, Any>
    {
        var jsonDictionary = Dictionary<String,Any>()
        jsonDictionary.updateValue(Name, forKey: "Name")
        var eventsArrayJSONs: [Dictionary<String,Any>] = []
        for event in Events
        {
            eventsArrayJSONs.append(event.Serialize())
        }
        jsonDictionary.updateValue(eventsArrayJSONs, forKey: "Events")
        jsonDictionary.updateValue(ColorCode.Name!, forKey: "ColorCode")
        jsonDictionary.updateValue(IsVisible, forKey: "IsVisible")
        return jsonDictionary
    }
    
    func Deserialize(json: Dictionary<String, Any>)
    {
        Name = json["Name"] as! String
        Events = []
        for eventJSON in json["Events"] as! [Dictionary<String,Any>]
        {
            let event = JFTEvent()
            event.Deserialize(json: eventJSON)
            Events.append(event)
        }
        ColorCode = UIColor.ColorByName(name: json["ColorCode"] as! String)
        IsVisible = json["IsVisible"] as! Bool
    }
    
    
    static var LocalCalendars: [JFTCalendar] = []
    var Name: String = ""
    var Events: [JFTEvent] = []
    var ColorCode: UIColor = UIColor.cyan
    var IsVisible: Bool = true
    
    required init() {}
    
//    func encode(with coder: NSCoder)
//    {
//        coder.encode(Name, forKey: "Name")
//        coder.encode(Events, forKey: "Events")
//        coder.encode(ColorCode, forKey: "ColorCode")
//    }
//
//    required init?(coder: NSCoder)
//    {
//        Name = coder.decodeObject(forKey: "Name") as! String
//        Events = coder.decodeObject(forKey: "Events") as! [JFTEvent]
//        ColorCode = coder.decodeObject(forKey: "ColorCode") as! UIColor
//    }
    
    func CheckIfDateIsFree(date: Date) -> Bool
    {
        for event in Events
        {
            if date >= event.StartTime && date <= event.EndTime
            {
                return false
            }
        }
        return true
    }
    
    func RemoveAlerts()
    {
        for event in Events
        {
            event.RemoveNotification()
        }
    }
    
    func AddAlertsBack()
    {
        for event in Events
        {
            event.AddNotification()
        }
    }
    
    func AddEvent(newEvent: JFTEvent)
    {
        Events.append(newEvent)
        newEvent.AddNotification()
    }
    
    func DeleteEvent(eventToDelete: JFTEvent)
    {
        if let index = Events.firstIndex(where: {$0 === eventToDelete})
        {
            Events[index].RemoveNotification()
            Events.remove(at: index)
        }
    }
    
    static func LoadLocalCalendars()
    {
        if let calendars: [JFTCalendar]  = JFTUtilities.LoadLocalData(filename: "localcalendars")
        {
            LocalCalendars = calendars
        }
        else
        {
            let defaultCalendar = JFTCalendar()
            defaultCalendar.Name = "Calendar"
            defaultCalendar.ColorCode = UIColor.blue
            LocalCalendars.append(defaultCalendar)
            SaveLocalCalendars()
        }
    }
    
    static func SaveLocalCalendars()
    {
        JFTUtilities.SaveLocalData(filename: "localcalendars", objectToSave: LocalCalendars)
    }
    
    static func ToggleShowForAllCalendars(on: Bool)
    {
        for calendar in JFTCalendar.LocalCalendars
        {
            calendar.IsVisible = on
        }
    }
    
    static func getDatesOfEventsFor(date: Date) -> [Date]
    {
        var dates: [Date] = []
        for calendar in JFTCalendar.LocalCalendars
        {
            if calendar.IsVisible
            {
                for event in calendar.Events
                {
                    if Calendar.current.compare(event.StartTime, to: date, toGranularity: .month) == .orderedSame
                    {
                        dates.append(event.StartTime)
                    }
                }
            }
        }
        return dates
    }
}

//
//  JFTEvent.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
import UIKit

class JFTEvent: JFTJSONSerializable
{
    static let JSONDateFormatter = DateFormatter()
    static var WorkingEventHolder: JFTEvent = JFTEvent()
    var ID: String
    var Title: String
    var Location: String
    var IsAllDay: Bool = false
    var StartTime: Date
    var EndTime: Date
    var Repeats: Bool = false
    var NotificationDate: DateComponents
    var URL: String
    var Notes: String
    var EventDuration: Int //In Minutes
    {
        get
        {
            let interval = EndTime.timeIntervalSince(StartTime)
            return Int(interval / 60)
        }
    }
    
    init(copy event: JFTEvent)
    {
        ID = event.ID
        Title = event.Title
        Location = event.Location
        StartTime = event.StartTime
        EndTime = event.EndTime
        NotificationDate = event.NotificationDate
        URL = event.URL
        Notes = event.Notes
    }
    
    required init()
    {
        ID = ""
        Title = ""
        Location = ""
        StartTime = Date()
        EndTime = Date()
        NotificationDate = DateComponents()
        URL = ""
        Notes = ""
    }
    
    
    // MARK: Event Methods
    func AddNotification()
    {
        let content = UNMutableNotificationContent()
        content.title = Title
        content.body = Notes
        let triggerDate = UNCalendarNotificationTrigger(dateMatching: NotificationDate, repeats: Repeats)
        let alert = UNNotificationRequest(identifier: ID, content: content, trigger: triggerDate)
        UNUserNotificationCenter.current().add(alert, withCompletionHandler: nil)
    }
    
    func RemoveNotification()
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ID])
    }
    
    func GenerateID()
    {
        let startDateComponenets = Calendar.current.dateComponents([.year, .month, .day], from: StartTime)
        ID = "\(Title)\(startDateComponenets.year!)\(startDateComponenets.month!)\(startDateComponenets.day!)"
    }
    
    
    // MARK: JFTJSONSerializable Implamentation
    func Serialize() -> Dictionary<String, Any>
    {
        var jsonDictionary = Dictionary<String,Any>()
        jsonDictionary.updateValue(ID, forKey: "ID")
        jsonDictionary.updateValue(Title, forKey: "Title")
        jsonDictionary.updateValue(Location, forKey: "Location")
        jsonDictionary.updateValue(IsAllDay, forKey: "IsAllDay")
        jsonDictionary.updateValue(JFTEvent.JSONDateFormatter.string(from: StartTime), forKey: "StartTime")
        jsonDictionary.updateValue(JFTEvent.JSONDateFormatter.string(from: EndTime), forKey: "EndTime")
        jsonDictionary.updateValue(Repeats, forKey: "Repeats")
        jsonDictionary.updateValue(URL, forKey: "URL")
        jsonDictionary.updateValue(Notes, forKey: "Notes")
        return jsonDictionary
    }
    
    func Deserialize(json: Dictionary<String, Any>)
    {
        ID = json["ID"] as! String
        Title = json["Title"] as! String
        Location = json["Location"] as! String
        StartTime = JFTEvent.JSONDateFormatter.date(from: json["StartTime"] as! String)!
        EndTime = JFTEvent.JSONDateFormatter.date(from: json["EndTime"] as! String)!
        URL = json["URL"] as! String
        Notes = json["Notes"] as! String
    }
    
    
    // MARK: Helper Functions
    static func UpdateComponentsForRepeatingNotification(for event: JFTEvent, type: JFTRepeatType, start date: Date)
    {
        switch type
        {
            case .Never:
                event.NotificationDate = DateComponents()
                break
            case .EveryWeek:
                event.NotificationDate = Calendar.current.dateComponents([.hour, .minute, .weekday], from: date)
                break
            case .EveryDay:
                event.NotificationDate = Calendar.current.dateComponents([.hour, .minute], from: date)
                break
            case .EveryMonth:
                event.NotificationDate = Calendar.current.dateComponents([.hour, .minute, .day], from: date)
                break
            case .EveryYear:
                event.NotificationDate = Calendar.current.dateComponents([.hour, .minute, .day, .month], from: date)
                break
        }
    }
    
    static func SetFormatterFormat()
    {
        JFTEvent.JSONDateFormatter.dateFormat = "MMM dd,yyyy HH:mm"
    }
}

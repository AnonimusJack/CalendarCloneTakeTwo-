//
//  JFTDay.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
import Foundation

enum JFTWeekDay: Int
{
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    
    static subscript(dayIndex: Int) -> JFTWeekDay
    {
        switch dayIndex
        {
            case 1:
                return .Sunday
            case 2:
                return .Monday
            case 3:
                return .Tuesday
            case 4:
                return .Wednesday
            case 5:
                return .Thursday
            case 6:
                return .Friday
            case 7:
                return .Saturday
            default:
                return .Sunday
        }
    }
}

class JFTDay: JFTPDatable
{
    private var year: Int
    private var month: Int
    var DayOfTheMonth: Int
    var DayOfTheWeek: JFTWeekDay
    
    init(date: Date)
    {
        DayOfTheMonth = Calendar.current.component(.day, from: date)
        DayOfTheWeek = JFTWeekDay[Calendar.current.component(.weekday, from: date)]
        year = Calendar.current.component(.year, from: date)
        month = Calendar.current.component(.month, from: date)
    }
    
    static func ==(left: JFTDay, right: JFTDay) -> Bool
    {
        if left.DayOfTheMonth == right.DayOfTheMonth && left.month == right.month && left.year == right.year
        {
            return true
        }
        return false
    }
    
    func GetDate() -> Date
    {
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: DayOfTheMonth))!
    }
}

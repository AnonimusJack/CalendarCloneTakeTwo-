//
//  JFTMonth.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
import Foundation

enum JFTMonthName: Int
{
    case January = 1
    case February = 2
    case March = 3
    case April = 4
    case May = 5
    case June = 6
    case July = 7
    case August = 8
    case September = 9
    case October = 10
    case November = 11
    case December = 12
    
    func toString() -> String
    {
        switch self
        {
            case .January:
                return "January"
            case .February:
                return "February"
            case .March:
                return "March"
            case .April:
                return "April"
            case .May:
                return "May"
            case .June:
                return "June"
            case .July:
                return "July"
            case .August:
                return "August"
            case .September:
                return "September"
            case .October:
                return "October"
            case .November:
                return "November"
            case .December:
                return "December"
        }
    }
    
    static subscript(monthIndex: Int) -> JFTMonthName
    {
        switch monthIndex
        {
            case 1:
                return .January
            case 2:
                return .February
            case 3:
                return .March
            case 4:
                return .April
            case 5:
                return .May
            case 6:
                return .June
            case 7:
                return .July
            case 8:
                return .August
            case 9:
                return .September
            case 10:
                return .October
            case 11:
                return .November
            case 12:
                return .December
            default:
                return .January
        }
    }
}

class JFTMonth
{
    var Year: Int
    var Name: JFTMonthName = .January
    var Days: [JFTDay] = []
    
    convenience init(date: Date)
    {
        let yearAndMonth: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        self.init(month: JFTMonthName[yearAndMonth.month!], year: yearAndMonth.year!)
    }
    
    required init(month: JFTMonthName, year: Int)
    {
        self.Year = year
        var month = month
        self.Name = month
        initializeDays(month: &month, year: &self.Year)
    }
    
    func GetDate() -> Date
    {
        return Calendar.current.date(from: DateComponents(year: self.Year, month: self.Name.rawValue))!
    }
    
    private func initializeDays(month: inout JFTMonthName, year: inout Int)
    {
        let dayCount: Int = self.getAmountOfDays(month: &month, year: &year)
        if dayCount != 0
        {
            for i in 1...dayCount
            {
                let currentDayDateComponents: DateComponents = DateComponents(year: year, month: month.rawValue, day: i)
                Days.append(JFTDay(date: Calendar.current.date(from: currentDayDateComponents) ?? Date()))
            }
        }
    }
    
    private func getAmountOfDays(month: inout JFTMonthName, year: inout Int) -> Int
    {
        let dateComponents: DateComponents = DateComponents(year: year, month: month.rawValue)
        let date: Date = Calendar.current.date(from: dateComponents) ?? Date()
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
}

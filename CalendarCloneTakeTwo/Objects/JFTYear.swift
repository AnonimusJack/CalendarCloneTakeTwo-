//
//  JFTYear.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

class JFTYear
{
    var Year: Int
    var Months: [JFTMonth]
    
    init(year: Int)
    {
        Year = year
        Months = []
        for i in 1...12
        {
            Months.append(JFTMonth(month: JFTMonthName[i], year: year))
        }
    }
    
    func GetDate() -> Date
    {
        return Calendar.current.date(from: DateComponents(year: self.Year))!
    }
}

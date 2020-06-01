//
//  NSDateExt.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 24/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

extension Date
{
    func CompareByDay(to date: Date) -> Bool
    {
        let order = Calendar.current.compare(self, to: date, toGranularity: .day)
        switch order
        {
            case .orderedSame:
                return true
            default:
                return false
        }
    }
}

//
//  JFTWeekLayoutView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 22/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTWeekLayoutView: UIView, JFTPDatable
{
    private static var selectedWeekday = 1
    private var dayViews: [JFTDayView] = []
    private var date: Date?
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    convenience init(date: Date, frame: CGRect)
    {
        self.init(frame: frame)
        self.date = date
        layoutDayViews(start: date, frame: frame)
    }
    
    func HighlightSelectedDay()
    {
        removeHighlightFromDayViews()
        dayViews[JFTWeekLayoutView.selectedWeekday - 1].IsHightlighted = true
        dayViews[JFTWeekLayoutView.selectedWeekday - 1].setNeedsDisplay()
    }
    
    func SetWeekdayForToday()
    {
        JFTWeekLayoutView.selectedWeekday = Calendar.current.component(.weekday, from: Date())
    }
    
    private func layoutDayViews(start date: Date, frame: CGRect)
    {
        dayViews.append(JFTDayView(date: date, frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0)))
        addNextDays(start: date)
        addPreviousDays(start: date)
        setDayViewPositions(frame: frame)
        var eventsDates = JFTCalendar.getDatesOfEventsFor(date: date)
        for dayView in dayViews
        {
            dayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onJFTDayTouch)))
            dayView.SetDaysEvent(dates: &eventsDates)
            self.addSubview(dayView)
        }
    }
    
    private func setDayViewPositions(frame: CGRect)
    {
        for i in 0...6
        {
            let newPosition = CGPoint(x: (7 + frame.width * (CGFloat(i)/7.0)), y: 5.0)
            dayViews[i].frame.origin = newPosition
        }
    }
    
    private func addNextDays(start date: Date)
    {
        var date = date
        let currentWeekday = (Calendar.current.component(.weekday, from: date) + 1)
        if currentWeekday == 8
        {
            return
        }
        for _ in currentWeekday...7
        {
            date = Calendar.current.date(byAdding: DateComponents(day: 1), to: date)!
            dayViews.append(JFTDayView(date: date, frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0)))
        }
    }
    
    private func addPreviousDays(start date: Date)
    {
        var date = date
        let currentWeekday = (Calendar.current.component(.weekday, from: date) - 1)
        if currentWeekday == 0
        {
            return
        }
        for _ in 1...currentWeekday
        {
            date = Calendar.current.date(byAdding: DateComponents(day: -1), to: date)!
            dayViews.insert(JFTDayView(date: date, frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0)), at: 0)
        }
    }
    
    @objc private func onJFTDayTouch(sender: UITapGestureRecognizer)
    {
        removeHighlightFromDayViews()
        let selectedView = sender.view as! JFTDayView
        selectedView.IsHightlighted = true
        JFTDayViewController.CurrentReference!.SelectDay(selected: selectedView.DayObject)
        JFTWeekLayoutView.selectedWeekday = selectedView.DayObject.DayOfTheWeek.rawValue
    }
    
    private func removeHighlightFromDayViews()
    {
        for dayView in self.subviews
        {
            let dayView = dayView as! JFTDayView
            dayView.IsHightlighted = false
            dayView.setNeedsDisplay()
        }
    }
    
    func GetDate() -> Date
    {
        return date!
    }
    
    static func CleanHighlightFromViews(views array: [JFTWeekLayoutView])
    {
        for view in array
        {
            view.removeHighlightFromDayViews()
        }
    }
    
    static func SetWeekdayForDate(date: Date)
    {
        JFTWeekLayoutView.selectedWeekday = Calendar.current.component(.weekday, from: date)
    }
}

//
//  JFTDayViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTDayViewController: UIViewController
{
    static var CurrentReference: JFTDayViewController?
    private var isToday: Bool = true
    @IBOutlet weak var weekLayoutView: UIView!
    @IBOutlet weak var hoursLayoutView: UIScrollView!
    var selectedDay: JFTDay = JFTDay(date: Date())
    
    override func loadView()
    {
        super.loadView()
        JFTDayViewController.CurrentReference = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        JFTDayViewController.CurrentReference = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        buildToolbarForYearViewController()
        self.weekLayoutView.addShadowToBottomOfView()
        if !isToday
        {
            let castWeekLayoutView = weekLayoutView as! JFTWeekView
            castWeekLayoutView.LoadWithSelectedDate(selected: selectedDay.GetDate())
        }
        viewInitialization()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        JFTDayViewController.CurrentReference = nil
    }
    
    func SelectDay(selected day: JFTDay)
    {
        selectedDay = day
        let castWeekLayoutView = weekLayoutView as! JFTWeekView
        castWeekLayoutView.OnNewSelectedDay()
        viewInitialization()
    }
    
    func SelectDayPreInit(selected date: Date)
    {
        selectedDay = JFTDay(date: date)
        isToday = false
    }
    
    private func viewInitialization()
    {
        removeAllSubviews()
        self.initializeHoursLayoutView()
        if selectedDay == JFTDay(date: Date())
        {
            self.drawTodaysExactTime()
        }
        layoutEventViews()
        hoursLayoutView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    private func removeAllSubviews()
    {
        for subview in hoursLayoutView.subviews
        {
            subview.removeFromSuperview()
        }
    }
    
    private func layoutEventViews()
    {
        let selectedDate = selectedDay.GetDate()
        for calendar in JFTCalendar.LocalCalendars
        {
            if calendar.IsVisible
            {
                for event in calendar.Events
                {
                    if event.StartTime.CompareByDay(to: selectedDate)
                    {
                        let newEventView = JFTEventView(frame: CGRect(x: 0.0, y: 0.0, width: 325.0, height: 100.0))
                        newEventView.ActivateWith(event: event, and: calendar)
                        hoursLayoutView.addSubview(newEventView)
                        addHourLabelsFor(startTime: event.StartTime, endTime: event.EndTime, calendarColor: calendar.ColorCode)
                        self.view.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    private func initializeHoursLayoutView()
    {
        hoursLayoutView.contentSize = CGSize(width: self.view.bounds.width, height: 2400.0)
        var yPosition: CGFloat = 0
        while yPosition <= 2400
        {
            self.addHourLabel(yPosition: yPosition, timeString: "\(Int(yPosition)/100):00")
            yPosition += 100
        }
    }
    
    private func drawTodaysExactTime()
    {
        let todaysComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let yPosition = calculateYPositionForLabel(hour: todaysComponents.hour!, minute: todaysComponents.minute!)
        let todayMinuteString = (todaysComponents.minute! <= 9) ? "0\(todaysComponents.minute!)" : "\(todaysComponents.minute!)"
        self.addHourLabel(yPosition: CGFloat(yPosition), timeString: "\(todaysComponents.hour!):\(todayMinuteString)", isToday: true)
    }
    
    private func addHourLabel(yPosition: CGFloat, timeString: String, isToday: Bool = false)
    {
        let drawColor: UIColor = isToday ? UIColor.red : UIColor.lightGray
        let timeLable: UILabel = UILabel(frame: CGRect(x: 5, y: yPosition, width: 35, height: 15))
        timeLable.text = timeString
        timeLable.textColor = drawColor
        timeLable.font = timeLable.font.withSize(12.0)
        hoursLayoutView.addSubview(timeLable)
        let separatorView: UIView = UIView(frame: CGRect(x: 41, y: (CGFloat(yPosition) + 7.5), width: (self.view.bounds.width - 47), height: 1.0))
        separatorView.backgroundColor = drawColor
        hoursLayoutView.addSubview(separatorView)
    }
    
    private func addHourLabelsFor(startTime: Date, endTime: Date, calendarColor: UIColor)
    {
        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
        let yStartPosition = calculateYPositionForLabel(hour: startComponents.hour!, minute: startComponents.minute!)
        let startMinutesString = (startComponents.minute! <= 9) ? "0\(startComponents.minute!)" : "\(startComponents.minute!)"
        self.addHourLabelsForEvent(yPosition: CGFloat(yStartPosition), timeString: "\(startComponents.hour!):\(startMinutesString)", color: calendarColor)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)
        let yEndPosition = calculateYPositionForLabel(hour: endComponents.hour!, minute: endComponents.minute!)
        let endMinuteString = (endComponents.minute! <= 9) ? "0\(endComponents.minute!)" : "\(endComponents.minute!)"
        self.addHourLabelsForEvent(yPosition: CGFloat(yEndPosition), timeString: "\(endComponents.hour!):\(endMinuteString)", color: calendarColor)
    }
    
    private func addHourLabelsForEvent(yPosition: CGFloat, timeString: String, color: UIColor)
    {
        let timeLable: UILabel = UILabel(frame: CGRect(x: 5, y: yPosition, width: 35, height: 15))
        timeLable.text = timeString
        timeLable.textColor = color
        timeLable.font = timeLable.font.withSize(12.0)
        hoursLayoutView.addSubview(timeLable)
    }
    
    private func calculateYPositionForLabel(hour: Int, minute: Int) -> Double
    {
        let minuteDouble = Double(minute) / 60.0 * 100.0
        let minuteString = (minuteDouble < 10.0) ? "0\(minute)" : "\(minute)"
        let timeAsDouble = Double(String("\(hour)"+minuteString))!
        return timeAsDouble
    }
    
    
    private func buildToolbarForYearViewController()
    {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(onTodayTap))
        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let calendarButton = UIBarButtonItem(title: "Calendar", style: .plain, target: self, action: #selector(onCalendarTap))
        let inboxButton = UIBarButtonItem(title: "Inbox", style: .plain, target: self, action: nil)
        let toolbarButtons = [todayButton, flexibleSpace, calendarButton, flexibleSpace1, inboxButton]
        setToolbarItems(toolbarButtons, animated: true)
    }
    
    @objc private func onTodayTap()
    {
        let castWeekLayoutView = weekLayoutView as! JFTWeekView
        castWeekLayoutView.OnSetTodayTouch()
    }
    
    @objc private func onCalendarTap()
    {
        performSegue(withIdentifier: "openCalendar", sender: self)
    }
}


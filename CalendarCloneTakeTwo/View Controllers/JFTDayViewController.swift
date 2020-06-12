//
//  JFTDayViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTDayViewController: UIViewController, JFTPRefreshable
{
    static var CurrentReference: JFTDayViewController?
    private var isToday: Bool = true
    private var selectedEventID: String = ""
    private var isRefreshPending: Bool = false
    @IBOutlet weak var weekLayoutView: UIView!
    @IBOutlet weak var hoursLayoutView: UIScrollView!
    var selectedDay: JFTDay = JFTDay(date: Date())
    
    
    // MARK: View Controller Events
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
            SelectDay(selected: selectedDay)
        }
        else
        {
            viewInitialization()
        }
        hoursLayoutView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onDayLayoutViewLongPress)))
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        JFTDayViewController.CurrentReference = nil
    }
    
    
    // MARK: Navigation Events
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "editEvent"
        {
            let destinationNavVC = segue.destination as! UINavigationController
            let castDestination = destinationNavVC.viewControllers.first as! JFTAEEventMainTableViewController
            castDestination.IsEdit = true
            JFTEvent.WorkingEventHolder = JFTCalendar.EventWith(id: selectedEventID)!
        }
        else if segue.identifier == "specialAdd"
        {
            let destinationNavVC = segue.destination as! UINavigationController
            let castDestination = destinationNavVC.viewControllers.first as! JFTAEEventMainTableViewController
            let castSender = sender as! Date
            castDestination.OnSpecialAddWith(date: castSender)
        }
    }
    
    // MARK: Day View Events
    func SelectDay(selected day: JFTDay)
    {
        selectedDay = day
        let castWeekView = weekLayoutView as! JFTWeekView
        castWeekView.OnNewSelectedDay()
        viewInitialization()
    }
    
    func SelectDayPreInit(selected date: Date)
    {
        selectedDay = JFTDay(date: date)
        isToday = false
    }
    
    @objc private func onDayLayoutViewLongPress(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .ended
        {
            let eventStartDate = calculateStartDateForPosition(position: sender.location(in: sender.view!).y)
            performSegue(withIdentifier: "specialAdd", sender: eventStartDate)
        }
    }
    
    
    // MARK: Event View Events
    @objc private func onEventViewTouch(sender: UITapGestureRecognizer)
    {
        let selectedView = sender.view as! JFTEventView
        selectedEventID = selectedView.EventID
        performSegue(withIdentifier: "editEvent", sender: self)
    }
    
    
    // MARK: Builder Methods
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
                        newEventView.EventID = event.ID
                        newEventView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEventViewTouch)))
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
    
    
    // MARK: Helper Methods
    private func removeAllSubviews()
    {
        for subview in hoursLayoutView.subviews
        {
            subview.removeFromSuperview()
        }
    }

    private func calculateYPositionForLabel(hour: Int, minute: Int) -> Double
    {
        let minuteDouble = Double(minute) / 60.0 * 100.0
        let minuteString = (minuteDouble < 10.0) ? "0\(minuteDouble)" : "\(minuteDouble)"
        let timeAsDouble = Double(String("\(hour)"+minuteString))!
        return timeAsDouble
    }
    
    private func calculateStartDateForPosition(position: CGFloat) -> Date
    {
        var addedEventDateComponenets = Calendar.current.dateComponents([.year, .month, .day], from: selectedDay.GetDate())
        let positionString = String(Double(position))
        let hours = (position >= 1000) ? Int(positionString.prefix(2))! : Int(positionString.prefix(1))!
        let precalculatedMinutesValue = (position >= 1000) ? Double(positionString.suffix(positionString.count - 2))! : Double(positionString.suffix(positionString.count - 1))!
        let minutes = Int(precalculatedMinutesValue / 100.0 * 60.0)
        addedEventDateComponenets.hour = hours
        addedEventDateComponenets.minute = minutes
        return Calendar.current.date(from: addedEventDateComponenets)!
    }
    

    // MARK: Controls Events
    @objc private func onTodayTap()
    {
        let castWeekLayoutView = weekLayoutView as! JFTWeekView
        castWeekLayoutView.OnSetTodayTouch()
    }
    
    @objc private func onCalendarTap()
    {
        performSegue(withIdentifier: "openCalendar", sender: self)
    }
    
    
    // MARK: JFTPRefreshable Implamentation
    func SetRefreshEvent()
    {
        self.loadView()
        self.viewWillAppear(false)
    }
}


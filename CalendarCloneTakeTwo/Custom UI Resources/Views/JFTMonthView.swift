//
//  JFTMonthView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTMonthView: UIView, JFTPDatable
{
    @IBInspectable var HighlightColor: UIColor = UIColor.purple
    @IBOutlet weak var SmallViewMonthNameLable: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet weak var daysLayoutView: UIView!
    var IsSmallView: Bool = false
    {
        willSet
        {
            SmallViewMonthNameLable.isHidden = !newValue
        }
    }
    var MonthObject: JFTMonth
    let xibName: String = "JFTMonthView"
    private var viewSize: CGFloat = 0.0
    
    convenience init(date: Date, frame: CGRect, isSmallView: Bool = false)
    {
        self.init(month: JFTMonth(date: date), frame: frame, isSmallView: isSmallView)
    }
    
    convenience init(month: JFTMonthName, year: Int, frame: CGRect, isSmallView: Bool = false)
    {
        self.init(frame: frame)
        MonthObject = JFTMonth(month: month, year: year)
        IsSmallView = isSmallView
        SmallViewMonthNameLable.isHidden = !IsSmallView
        viewSize = IsSmallView ? 20.0 : 40.0
        if !IsSmallView
        {
            self.setMonthTitleForLargeView()
        }
        layoutDayViews()
        SmallViewMonthNameLable.text = MonthObject.Name.toString()
    }
    
    convenience init(month: JFTMonth, frame: CGRect, isSmallView: Bool = false)
    {
        
        self.init(frame: frame)
        MonthObject = month
        IsSmallView = isSmallView
        SmallViewMonthNameLable.isHidden = !IsSmallView
        viewSize = IsSmallView ? 20.0 : 40.0
        if !IsSmallView
        {
            self.setMonthTitleForLargeView()
        }
        layoutDayViews()
        SmallViewMonthNameLable.text = MonthObject.Name.toString()
    }
    
    override init(frame: CGRect)
    {
        MonthObject = JFTMonth(month: JFTMonthName.January , year: 2000)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        MonthObject = JFTMonth(month: JFTMonthName.January , year: 2000)
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        //daysLayoutView.frame = self.repositionDaysLayoutView()
        view.setNeedsDisplay()
    }
    
    func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        SmallViewMonthNameLable.textColor = HighlightColor
        daysLayoutView.frame = self.repositionDaysLayoutView()
    }
    
    private func calculateViewPosition(row: Int, col: Int) -> CGPoint
    {
        let x: CGFloat = (CGFloat(col) / 7) * daysLayoutView.frame.width
        let y: CGFloat = (CGFloat(row) / 7) * daysLayoutView.frame.height
        return CGPoint(x: x, y: y)
    }
    
    private func setMonthTitleForLargeView()
    {
        let dayViewPosition: CGPoint = self.calculateViewPosition(row: 0, col: (MonthObject.Days[0].DayOfTheWeek.rawValue - 1))
        let monthTitle: UILabel = UILabel(frame: CGRect(origin: dayViewPosition, size: CGSize(width: viewSize, height: viewSize)))
        monthTitle.text = String(MonthObject.Name.toString().prefix(3))
        monthTitle.textColor = HighlightColor
        monthTitle.adjustsFontSizeToFitWidth = true
        daysLayoutView.addSubview(monthTitle)
    }
    
    private func repositionDaysLayoutView() -> CGRect
    {
        let heightMultiplier: CGFloat = 0.893333
        let yMultiplier: CGFloat = 20 / 375
        let newHeight: CGFloat = self.bounds.height * heightMultiplier
        let newY: CGFloat = self.bounds.height * yMultiplier
        return CGRect(x: 0, y: newY, width: self.bounds.width, height: newHeight)
    }
    
    private func layoutDayViews()
    {
        var weekCount = 1
        var eventsDates = JFTCalendar.getDatesOfEventsFor(date: MonthObject.GetDate())
        for day in MonthObject.Days
        {
            let dayViewPosition: CGPoint = self.calculateViewPosition(row: weekCount, col: (day.DayOfTheWeek.rawValue - 1))
            let dayView: JFTDayView = JFTDayView(day: day, frame: CGRect(origin: dayViewPosition, size: CGSize(width: viewSize, height: viewSize)))
            if !IsSmallView
            {
                dayView.SetDaysEvent(dates: &eventsDates)
                dayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDayViewTouch)))
            }
            daysLayoutView.addSubview(dayView)
            if day.DayOfTheWeek.rawValue == 7
            {
                weekCount += 1
            }
        }
    }
    
    @objc private func onDayViewTouch(sender: UITapGestureRecognizer)
    {
        let selectedView = sender.view as! JFTDayView
        JFTMonthViewController.CurrentReference!.OnDaySelected(selected: selectedView.GetDate())
    }
    
    func GetDate() -> Date
    {
        MonthObject.GetDate()
    }
}


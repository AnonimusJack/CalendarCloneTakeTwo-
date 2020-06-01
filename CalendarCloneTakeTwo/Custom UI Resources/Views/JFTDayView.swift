//
//  JFTDayView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable class JFTDayView: UIView, JFTPDatable
{
    @IBOutlet weak var CurrentDayLableTrailingConstraint: NSLayoutConstraint!
    @IBInspectable var HighlightColor: UIColor = UIColor.purple
    private var dayObject: JFTDay = JFTDay(date: Date())
    @IBOutlet weak var CurrentDayDateLable: UILabel!
    
    let xibName: String = "JFTDayView"
    var IsHightlighted: Bool = true
    {
        willSet
        {
            if newValue == true
            {
                self.CurrentDayDateLable.textColor = UIColor.white
            }
            else
            {
                self.CurrentDayDateLable.textColor = UIColor.black
            }
        }
    }
    var IsSmallView: Bool = false
    @IBOutlet var view: UIView!
    var ContainsEvents = false
    var IsToday: Bool = true
    var DayObject: JFTDay
    {
        get
        {
            return self.dayObject
        }
        set
        {
            self.dayObject = newValue
            if (newValue == JFTDay(date: Date()))
            {
                self.IsToday = true
                self.IsHightlighted = true
            }
            else
            {
                self.IsToday = false
                self.IsHightlighted = false
            }
            self.CurrentDayDateLable.text = String(DayObject.DayOfTheMonth)
        }
    }
    
    convenience init(date: Date, frame: CGRect)
    {
        self.init(frame: frame)
        DayObject = JFTDay(date: date)
        self.setFontSize()
    }
    
    convenience init(day: JFTDay, frame: CGRect)
    {
        self.init(frame: frame)
        DayObject = day
        self.setFontSize()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        if IsHightlighted
        {
            CurrentDayDateLable.textColor = UIColor.white
        }
        CurrentDayDateLable.text = String(DayObject.DayOfTheMonth)
        self.setFontSize()
        self.realignDayLable()
    }
    
    func reinit(date: Date)
    {
        self.DayObject = JFTDay(date: date)
    }
    
    override func draw(_ rect: CGRect)
    {
        UIColor.white.setFill()
        UIRectFill(rect)
        if self.IsHightlighted
        {
            self.drawHightlightCircle()
        }
        if self.ContainsEvents && !self.IsSmallView
        {
            self.drawEventCircle()
        }
    }
    
    private func realignDayLable()
    {
        let ratio: CGFloat = self.CurrentDayDateLable.frame.size.height * ((self.bounds.height > 20) ? 0.2 : 0.1)
        CurrentDayLableTrailingConstraint.constant += ratio
    }
    
    private func setFontSize()
    {
        if self.bounds.height < 80
        {
            if dayObject.DayOfTheMonth > 9
            {
                let fontSizeRatio: CGFloat = (self.bounds.height > 20) ? 1/3 : 1/6
                CurrentDayDateLable.font = CurrentDayDateLable.font.withSize(CurrentDayDateLable.frame.height * fontSizeRatio)
            }
            else
            {
                let fontSizeRatio: CGFloat = (self.bounds.height > 20) ? 2/3 : 1/3
                CurrentDayDateLable.font = CurrentDayDateLable.font.withSize(CurrentDayDateLable.frame.height * fontSizeRatio)
            }
        }
    }
    
    private func calculateHighlightCircleOrigin(_ circleSize: CGFloat) -> CGPoint
    {
        let ratioY: CGFloat = 1/21
        let x: CGFloat = (self.bounds.width / 2) - (circleSize / 2)
        return CGPoint(x: x, y: self.bounds.size.height * ratioY)
    }
    
    private func calculateEventNotificationCircleOrigin(_ circleSize: CGFloat) -> CGPoint
    {
        let y: CGFloat = (CurrentDayDateLable.frame.height * 2)
        let x: CGFloat = (self.bounds.width / 2) - (circleSize / 2)
        return CGPoint(x: x, y: y)
    }
    
    private func drawHightlightCircle()
    {
        let circleSize = CurrentDayDateLable.frame.height + (CurrentDayDateLable.frame.height * 0.6)
        let centerPoint: CGPoint = self.calculateHighlightCircleOrigin(circleSize)
        let circlePath: UIBezierPath = UIBezierPath(ovalIn: CGRect(x: centerPoint.x, y: centerPoint.y, width: circleSize, height: circleSize))
        if self.IsToday
        {
            self.HighlightColor.setFill()
        }
        else
        {
            UIColor.black.setFill()
        }
        circlePath.fill()
    }
    
    private func drawEventCircle()
    {
        let circleSize = CurrentDayDateLable.frame.height * (1/3)
        let originPoint: CGPoint = self.calculateEventNotificationCircleOrigin(circleSize)
        let circlePath: UIBezierPath = UIBezierPath(ovalIn: CGRect(x: originPoint.x, y: originPoint.y, width: circleSize, height: circleSize))
        UIColor.darkGray.setFill()
        circlePath.fill()
    }
    
    func SetDaysEvent(dates: inout [Date])
    {
        if checkIfDayContainsEvents(dates: &dates)
        {
            ContainsEvents = true
        }
    }
    
    private func checkIfDayContainsEvents(dates: inout [Date]) -> Bool
    {
        for eventDate in dates
        {
            if Calendar.current.compare(eventDate, to: dayObject.GetDate(), toGranularity: .day) == .orderedSame
            {
                return true
            }
        }
        return false
    }
    
    func GetDate() -> Date
    {
        DayObject.GetDate()
    }
}

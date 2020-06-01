//
//  JFTWeekView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable
class JFTWeekView: UIView, UIScrollViewDelegate
{
    @IBOutlet var view: UIView!
    @IBOutlet weak var WeekLayoutScrollView: UIScrollView!
    @IBOutlet weak var SelectedDateLable: UILabel!
    private var infiniteScrollHandler: JFTInfiniteScrollViewPresentationHandler?
    private static let xibName: String = "JFTWeekView"
    private static let formatter: DateFormatter = DateFormatter()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(JFTWeekView.xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        JFTWeekView.formatter.dateFormat = "EEEE dd MMM, yyyy"
        SelectedDateLable.text = JFTWeekView.formatter.string(from: Date())
        WeekLayoutScrollView.delegate = self
        WeekLayoutScrollView.isPagingEnabled = true
        infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: WeekLayoutScrollView, type: .JFTWeekViewType)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if scrollView.isDragging
        {
            if translation.x > 0
            {
                infiniteScrollHandler!.OnScrollLeft()
            }
            else if translation.x < 0
            {
                infiniteScrollHandler!.OnScrollRight()
            }
        }
    }
    
    func OnNewSelectedDay()
    {
        SelectedDateLable.text = JFTWeekView.formatter.string(from: (JFTDayViewController.CurrentReference!.selectedDay.GetDate()))
    }
    
    func LoadWithSelectedDate(selected date: Date)
    {
        infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: WeekLayoutScrollView, type: .JFTWeekViewType, selected: date)
    }
    
    func OnSetTodayTouch()
    {
        if infiniteScrollHandler!.IsSelectedDayToday()
        {
            if !infiniteScrollHandler!.IsScrollViewCentered()
            {
                infiniteScrollHandler!.OnMoveToTodayRequest()
                OnNewSelectedDay()
                let todaysWeekday = Calendar.current.component(.weekday, from: Date())
                let firstViewReference = WeekLayoutScrollView.subviews[0] as! JFTWeekLayoutView
                firstViewReference.HighlightSelectedDay(weekday: todaysWeekday)
            }
            
        }
        else
        {
            infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: WeekLayoutScrollView, type: .JFTWeekViewType)
            self.view.setNeedsDisplay()
        }
    }
}

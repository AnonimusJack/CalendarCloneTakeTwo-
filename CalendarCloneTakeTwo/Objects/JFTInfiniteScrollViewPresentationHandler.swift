//
//  JFTInfiniteScrollViewPresentationHandler.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
import Foundation
import UIKit

enum JFTInfiniteScrollViewType
{
    case JFTYearViewType
    case JFTMonthViewType
    case JFTWeekViewType
}

class JFTInfiniteScrollViewPresentationHandler
{
    private weak var callerScrollViewReference: UIScrollView?
    private var viewHeight: CGFloat = 0
    private var viewWidth: CGFloat = 375.0
    private var verticalOffset: CGFloat = 0.0
    private var verticalInfinity: Bool
    private var ascendingViewsArray: [UIView] = []
    private var descendingViewsArray: [UIView] = []
    private var scrollAxisPosition: CGFloat = 0.0
    private var selectedDate: Date
    private var lastAscendingDate: Date
    private var lastDescendingDate: Date
    private var currentViewType: JFTInfiniteScrollViewType
    private var finishedAddingView: Bool = true
    private var lastPositionOfCenterObject: CGFloat = 0.0
    
    
    
    init(scrollViewToReference: UIScrollView, type: JFTInfiniteScrollViewType, selected date: Date = Date())
    {
        callerScrollViewReference = scrollViewToReference
        selectedDate = date
        lastAscendingDate = date
        lastDescendingDate = date
        currentViewType = type
        verticalInfinity = (type == .JFTWeekViewType) ? false : true
        setViewHeight(type: type)
        verticalOffset = viewHeight * 1/5
        lastPositionOfCenterObject += verticalInfinity ? viewHeight : viewWidth
        clearScrollView()
        initializeInfiniteScrollView()
    }
    
    
    // MARK: Caller Events
    func OnScrollUpwards()
    {
        if callerScrollViewReference!.contentOffset.y <= verticalOffset
        {
            if finishedAddingView
            {
                resetContentOffset(ascending: true)
                addViewToTheTop()
            }
        }
    }
    
    func OnScrollDownwards()
    {
        let viewHeightCorrected = (currentViewType == .JFTMonthViewType) ? (viewHeight * 2) : viewHeight
        if callerScrollViewReference!.contentOffset.y >= (callerScrollViewReference!.contentSize.height - viewHeightCorrected)
        {
            if finishedAddingView
            {
                resetContentOffset(ascending: false)
                addViewToTheBottom()
            }
        }
    }
    
    func OnScrollRight()
    {
        if callerScrollViewReference!.contentOffset.x >= (callerScrollViewReference!.contentSize.width  - viewWidth)
        {
            if finishedAddingView
            {
                addViewToTheBottom()
                resetContentOffset(ascending: false)
            }
        }
        cleanupForScrollEventForWeekView()
        scrolledEventForWeekView(right: true)
    }
    
    func OnScrollLeft()
    {
        if callerScrollViewReference!.contentOffset.x < viewWidth
        {
            if finishedAddingView
            {
                addViewToTheTop()
                resetContentOffset(ascending: true)
            }
        }
        cleanupForScrollEventForWeekView()
        scrolledEventForWeekView(right: false)
    }
    
    func OnFinishedScrollingForWeekView()
    {
        cleanupForScrollEventForWeekView()
        scrolledEventForWeekView(right: false)
    }
    
    func OnMoveToTodayRequest()
    {
        resetToCenter()
    }
    
    
    // MARK: State Announcer Methods
    func IsSelectedDayToday() -> Bool
    {
        var granualityType: Calendar.Component
        switch currentViewType
        {
            case .JFTYearViewType:
                granualityType = .year
                break
            case .JFTMonthViewType:
                granualityType = .month
                break
            case .JFTWeekViewType:
                granualityType = .weekOfYear
                break
        }
        if Calendar.current.compare(selectedDate, to: Date(), toGranularity: granualityType) == .orderedSame
        {
            return true
        }
        return false
    }
    
    func IsScrollViewCentered() -> Bool
    {
        if verticalInfinity
        {
            if callerScrollViewReference!.contentOffset.y == lastPositionOfCenterObject
            {
                return true
            }
        }
        else
        {
            if callerScrollViewReference!.contentOffset.x == lastPositionOfCenterObject
            {
                return true
            }
        }
        return false
    }
    
    
    // MARK: Builder Methods
    private func addViewToTheTop()
    {
        finishedAddingView = false
        if descendingViewsArray.count > 1
        {
            callerScrollViewReference!.viewWithTag(descendingViewsArray.last!.tag)?.removeFromSuperview()
            descendingViewsArray.removeLast()
            moveDate(ascending: false, next: true)
        }
        offsetViewsForNewTopView()
        lastPositionOfCenterObject += verticalInfinity ? viewHeight : viewWidth
        moveDate(ascending: true, next: true)
        let newView = getViewFor(ascending: true, date: lastAscendingDate)
        ascendingViewsArray.append(newView)
        callerScrollViewReference!.addSubview(newView)
        recalculateScrollViewContentSize()
        
        finishedAddingView = true
        callerScrollViewReference!.setNeedsDisplay()
    }
    
    private func addViewToTheBottom()
    {
        finishedAddingView = false
        if ascendingViewsArray.count > 1
        {
            lastPositionOfCenterObject -= verticalInfinity ? viewHeight : viewWidth
            callerScrollViewReference!.viewWithTag(ascendingViewsArray.last!.tag)?.removeFromSuperview()
            ascendingViewsArray.removeLast()
            reoffsetViewsForNewTopView()
            moveDate(ascending: true, next: false)
        }
        moveDate(ascending: false, next: false)
        let newView = getViewFor(ascending: false, date: lastDescendingDate)
        descendingViewsArray.append(newView)
        callerScrollViewReference!.addSubview(newView)
        recalculateScrollViewContentSize()
        
        finishedAddingView = true
    }
    
    private func addFisrtViewToArray(date: Date)
    {
        switch currentViewType
        {
            case .JFTYearViewType:
                let newYearView = JFTYearView(year: Calendar.current.component(.year, from: Date()), frame: CGRect(x: 0.0, y: 0.0, width: viewWidth, height: viewHeight))
                callerScrollViewReference!.addSubview(newYearView)
                break
            case .JFTMonthViewType:
                let newMonthView = JFTMonthView(date: date, frame: CGRect(x: 0.0, y: 0.0, width: viewWidth, height: viewHeight), isSmallView: false)
                callerScrollViewReference!.addSubview(newMonthView)
                break
            case .JFTWeekViewType:
                let newWeekView = JFTWeekLayoutView(date: date, frame: CGRect(x: 0.0, y: 0.0, width: viewWidth, height: viewHeight))
                callerScrollViewReference!.addSubview(newWeekView)
                break
        }
    }
    
    private func initializeInfiniteScrollView()
    {
        let currentDate = selectedDate
        addFisrtViewToArray(date: currentDate)
        offsetViewsForNewTopView()
        moveDate(ascending: true, next: true)
        moveDate(ascending: false, next: false)
        let ascendingView = getViewFor(ascending: true, date: lastAscendingDate)
        ascendingViewsArray.append(ascendingView)
        callerScrollViewReference!.addSubview(ascendingView)
        let descendingView = getViewFor(ascending: false, date: lastDescendingDate)
        descendingViewsArray.append(descendingView)
        callerScrollViewReference!.addSubview(descendingView)
        recalculateScrollViewContentSize()
        callerScrollViewReference!.contentOffset = CGPoint(x: 0.0, y: 0.0)
        resetInitialPosition()
    }
    
    private func clearScrollView()
    {
        for view in callerScrollViewReference!.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    private func cleanupForScrollEventForWeekView()
    {
        JFTWeekLayoutView.CleanHighlightFromViews(views: callerScrollViewReference!.subviews as! [JFTWeekLayoutView])
    }
    
    
    // MARK: Helper Methods
    private func recalculateScrollViewContentSize()
    {
        let calculatedHeight: CGFloat = verticalInfinity ? (CGFloat((callerScrollViewReference?.subviews.count)!) * viewHeight) : viewHeight
        let calculatedWidth: CGFloat = verticalInfinity ? viewWidth : ((CGFloat((callerScrollViewReference?.subviews.count)!) * viewWidth))
        callerScrollViewReference!.contentSize = CGSize(width: calculatedWidth, height: calculatedHeight)
    }
    
    private func moveDate(ascending: Bool, next: Bool)
    {
        var dateComponentToAdd: DateComponents
        switch currentViewType
        {
            case .JFTYearViewType:
                dateComponentToAdd = DateComponents(year: next ? 1 : -1)
                break
            case .JFTMonthViewType:
                dateComponentToAdd = DateComponents(month: next ? 1 : -1)
                break
            case .JFTWeekViewType:
                dateComponentToAdd = DateComponents(weekOfMonth: next ? -1 : 1)
                break
        }
        if ascending
        {
            lastAscendingDate = Calendar.current.date(byAdding: dateComponentToAdd, to: lastAscendingDate)!
        }
        else
        {
            lastDescendingDate = Calendar.current.date(byAdding: dateComponentToAdd, to: lastDescendingDate)!
        }
    }
    
    private func offsetViewsForNewTopView()
    {
        for view in callerScrollViewReference!.subviews
        {
            let newPoint = verticalInfinity ? CGPoint(x: view.frame.origin.x, y: view.frame.origin.y + viewHeight) : CGPoint(x: view.frame.origin.x + viewWidth, y: view.frame.origin.y)
            view.frame.origin = newPoint
        }
    }
    
    private func reoffsetViewsForNewTopView()
    {
        for view in callerScrollViewReference!.subviews
        {
            let newPoint = verticalInfinity ? CGPoint(x: view.frame.origin.x, y: view.frame.origin.y - viewHeight) : CGPoint(x: view.frame.origin.x - viewWidth, y: view.frame.origin.y)
            view.frame.origin = newPoint
        }
    }
    
    private func getViewFor(ascending: Bool, date: Date) -> UIView
    {
        switch currentViewType
        {
            case .JFTYearViewType:
                let year = Calendar.current.component(.year, from: date)
                let newYearView = JFTYearView(year: year, frame: calculateFrameForView(ascending: ascending))
                newYearView.tag = year
                return newYearView
            case .JFTMonthViewType:
                let newMonthView = JFTMonthView(date: date, frame: calculateFrameForView(ascending: ascending), isSmallView: false)
                let tagString = "\(newMonthView.MonthObject.Name.rawValue)\(newMonthView.MonthObject.Year)"
                newMonthView.tag = Int(tagString)!
                return newMonthView
            case .JFTWeekViewType:
                let newWeekView = JFTWeekLayoutView(date: date, frame: calculateFrameForView(ascending: ascending))
                let weekDateComponents = Calendar.current.dateComponents([.year, .month, .weekOfMonth], from: newWeekView.GetDate())
                let tagString = "\(weekDateComponents.year!)\(weekDateComponents.month!)\(weekDateComponents.weekOfMonth!)"
                newWeekView.tag = Int(tagString)!
                return newWeekView
        }
    }
    
    private func calculateFrameForView(ascending: Bool) -> CGRect
    {
        if verticalInfinity
        {
            if !ascending
            {
                var newFrame = (descendingViewsArray.last ?? callerScrollViewReference!.subviews.first!).frame
                newFrame.origin.y += viewHeight
                return newFrame
            }
            return CGRect(x: 0.0, y: 0.0, width: viewWidth, height: viewHeight)
        }
        else
        {
            if !ascending
            {
                var newFrame = (descendingViewsArray.last ?? callerScrollViewReference!.subviews.first!).frame
                newFrame.origin.x += viewWidth
                return newFrame
            }
            return CGRect(x: 0.0, y: 0.0, width: viewWidth, height: viewHeight)
        }
    }
    
    private func resetInitialPosition()
    {
        switch currentViewType
        {
            case .JFTWeekViewType:
                let centerX = callerScrollViewReference!.contentOffset.x + viewWidth
                callerScrollViewReference!.setContentOffset(CGPoint(x: centerX, y: 0.0), animated: true)
                break
            default:
                let centerY = callerScrollViewReference!.contentOffset.y + ((currentViewType == JFTInfiniteScrollViewType.JFTMonthViewType) ? (viewHeight / 2.0) : viewHeight)
                callerScrollViewReference!.setContentOffset(CGPoint(x: 0.0, y: centerY), animated: true)
                break
        }
    }
    
    private func setViewHeight(type: JFTInfiniteScrollViewType)
    {
        switch type
        {
            case .JFTYearViewType:
                viewHeight = 579.0
                break
            case .JFTMonthViewType:
                viewHeight = 279.0
                break
            case .JFTWeekViewType:
                viewHeight = 50.0
                break
        }
    }
    
    private func resetContentOffset(ascending: Bool)
    {
        if verticalInfinity
        {
            if ascending
            {
                let centerY = callerScrollViewReference!.contentOffset.y + viewHeight
                callerScrollViewReference!.setContentOffset(CGPoint(x: 0.0, y: centerY), animated: false)
            }
        }
        else
        {
            if ascending
            {
                let centerX = callerScrollViewReference!.contentOffset.x + viewWidth
                callerScrollViewReference!.setContentOffset(CGPoint(x: centerX, y: 0.0), animated: false)
            }
            else
            {
                let centerX = callerScrollViewReference!.contentOffset.x - viewWidth
                callerScrollViewReference!.setContentOffset(CGPoint(x: centerX, y: 0.0), animated: false)
            }
        }
    }
    
    private func resetToCenter()
    {
        if verticalInfinity
        {
            callerScrollViewReference!.setContentOffset(CGPoint(x: 0.0, y: lastPositionOfCenterObject), animated: true)
        }
        else
        {
            callerScrollViewReference!.setContentOffset(CGPoint(x: lastPositionOfCenterObject, y: 0.0), animated: true)
        }
    }
    
    private func viewAtOffset() -> UIView
    {
        let offsetPosition = callerScrollViewReference!.contentOffset
        for view in callerScrollViewReference!.subviews
        {
            if view.frame.contains(offsetPosition)
            {
                return view
            }
        }
        return callerScrollViewReference!.subviews[0]
    }
    
    private func scrolledEventForWeekView(right direction: Bool)
    {
        let selectedView = viewAtOffset() as! JFTWeekLayoutView
        selectedView.HighlightSelectedDay()
    }
}

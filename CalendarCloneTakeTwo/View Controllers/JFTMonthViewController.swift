//
//  JFTMonthViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 22/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTMonthViewController: UIViewController, UIScrollViewDelegate
{
    static var CurrentReference: JFTMonthViewController?
    @IBOutlet weak var monthScrollView: UIScrollView!
    private var infiniteScrollHandler: JFTInfiniteScrollViewPresentationHandler?
    private var selectedDate: Date = Date()
    
    override func loadView()
    {
        super.loadView()
        JFTMonthViewController.CurrentReference = self
        monthScrollView.delegate = self
        infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: monthScrollView, type: .JFTMonthViewType, selected: selectedDate)
        buildToolbarForYearViewController()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        JFTMonthViewController.CurrentReference = self
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if scrollView.isDragging
        {
            if translation.y > 0
            {
                infiniteScrollHandler!.OnScrollUpwards()
            }
            else if translation.y < 0
            {
                infiniteScrollHandler!.OnScrollDownwards()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        JFTMonthViewController.CurrentReference = nil
    }
    
    func SelectMonth(date: Date)
    {
        selectedDate = date
    }
    
    func OnDaySelected(selected date: Date)
    {
        performSegue(withIdentifier: "openDayView", sender: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let selectedDate = sender as? Date
        {
            let castDesination = segue.destination as! JFTDayViewController
            castDesination.SelectDayPreInit(selected: selectedDate)
        }
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
        if infiniteScrollHandler!.IsSelectedDayToday()
        {
            if infiniteScrollHandler!.IsScrollViewCentered()
            {
                performSegue(withIdentifier: "openDayView", sender: self)
            }
            else
            {
                infiniteScrollHandler!.OnMoveToTodayRequest()
            }
        }
        else
        {
            infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: monthScrollView, type: .JFTMonthViewType)
            self.view.setNeedsDisplay()
        }
    }
    
    @objc private func onCalendarTap()
    {
        performSegue(withIdentifier: "openCalendar", sender: self)
    }
}

//
//  JFTYearViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit


class JFTYearViewController: UIViewController, UIScrollViewDelegate
{
    static var CurrentReference: JFTYearViewController?
    @IBOutlet weak var yearScrollView: UIScrollView!
    private var infiniteScrollHandler: JFTInfiniteScrollViewPresentationHandler?
    
    override func loadView()
    {
        super.loadView()
        JFTEvent.SetFormatterFormat()
        JFTCalendar.LoadLocalCalendars()
        JFTYearViewController.CurrentReference = self
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        yearScrollView.delegate = self
        infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: yearScrollView, type: .JFTYearViewType)
        buildToolbarForYearViewController()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        JFTYearViewController.CurrentReference = self
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        JFTYearViewController.CurrentReference = nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
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
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//    {
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        if scrollView.isDragging
//        {
//            if translation.y > 0
//            {
//                infiniteScrollHandler!.OnScrollUpwards()
//            }
//            else if translation.y < 0
//            {
//                infiniteScrollHandler!.OnScrollDownwards()
//            }
//        }
//    }
    
    func OnMonthSelected(selected date: Date)
    {
        performSegue(withIdentifier: "openMonthsView", sender: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let selectedDate = sender as? Date
        {
            let castDesination = segue.destination as! JFTMonthViewController
            castDesination.SelectMonth(date: selectedDate)
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
                performSegue(withIdentifier: "openMonthsView", sender: self)
            }
            else
            {
                infiniteScrollHandler!.OnMoveToTodayRequest()
            }
        }
        else
        {
            infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: yearScrollView, type: .JFTYearViewType)
            self.view.setNeedsDisplay()
        }
    }
    
    @objc private func onCalendarTap()
    {
        performSegue(withIdentifier: "openCalendar", sender: self)
    }
}

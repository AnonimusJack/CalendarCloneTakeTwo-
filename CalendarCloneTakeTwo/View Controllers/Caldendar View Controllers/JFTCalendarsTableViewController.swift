//
//  JFTCalendarsTableViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 19/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTCalendarsTableViewController: UITableViewController, JFTPRefreshable
{
    private var hideShowBarButton: UIBarButtonItem?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        buildToolbarForCalendarsViewController()
        initializeNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if let dayViewController = JFTDayViewController.CurrentReference
        {
            dayViewController.SetRefreshEvent()
        }
        if let monthViewController = JFTMonthViewController.CurrentReference
        {
            monthViewController.SetRefreshEvent()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let calendarRef = JFTCalendar.LocalCalendars[indexPath.row]
        let newCell: JFTCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JFTCalendarTableCell") as! JFTCalendarTableViewCell
        newCell.CalendarReference = calendarRef
        newCell.CalendarCheckCircle.CircleColor = calendarRef.ColorCode
        newCell.CalendarCheckCircle.setNeedsDisplay()
        newCell.CalendarNameLabel.text = calendarRef.Name
        return newCell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        performSegue(withIdentifier: "editCalendar", sender: JFTCalendar.LocalCalendars[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return JFTCalendar.LocalCalendars.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationNavController = segue.destination as? UINavigationController
        let editCalendarTableView = destinationNavController!.viewControllers.first as! JFTAECalendarTableViewController
        editCalendarTableView.ParentReference = self
        if segue.identifier == "editCalendar"
        {
            editCalendarTableView.IsEdit = true
            editCalendarTableView.Calendar = sender as! JFTCalendar
        }
    }
    
    private func initializeNavigationBar()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDoneButtonTouch))
    }
    
    private func buildToolbarForCalendarsViewController()
    {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let addCalendarButton = UIBarButtonItem(title: "Add Calendar", style: .plain, target: self, action: #selector(onAddCalendarTouch))
        let hideShowButton = UIBarButtonItem(title: "Hide All", style: .plain, target: self, action: #selector(onHideShowTouch))
        let toolbarButtons = [addCalendarButton, flexibleSpace, hideShowButton]
        hideShowBarButton = hideShowButton
        setToolbarItems(toolbarButtons, animated: true)
    }
    
    @objc private func onAddCalendarTouch()
    {
        performSegue(withIdentifier: "addCalendar", sender: self)
    }
    
    @objc private func onHideShowTouch()
    {
        if hideShowBarButton!.title == "Show All"
        {
            hideShowBarButton!.title = "Hide All"
            JFTCalendar.ToggleShowForAllCalendars(on: true)
        }
        else
        {
            hideShowBarButton!.title = "Show All"
            JFTCalendar.ToggleShowForAllCalendars(on: false)
        }
    }
    
    @objc private func onDoneButtonTouch()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func SetRefreshEvent()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

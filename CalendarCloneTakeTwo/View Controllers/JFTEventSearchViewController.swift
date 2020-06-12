//
//  JFTEventSearchViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 01/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTEventSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource
{
    private var results: Dictionary<String, [JFTEvent]> = [:]
    private var selectedEvent: JFTEvent?
    @IBOutlet weak var EventsResultsTable: UITableView!
    @IBOutlet weak var EventSearcbBar: UISearchBar!
    
    
    // MARK: View Controller Events
    override func viewDidLoad()
    {
        super.viewDidLoad()
        JFTEventSearchEngine.SetEngineFormat()
        JFTEventTableViewCell.SetTimeFormat()
        EventSearcbBar.delegate = self
        EventsResultsTable.delegate = self
        EventsResultsTable.dataSource = self
        EventsResultsTable.isHidden = true
    }
    
    
    // MARK: SearchBar Events
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text != ""
        {
            results = JFTEventSearchEngine.SearchForEventBy(name: searchBar.text!)
            EventsResultsTable.isHidden = false
            EventsResultsTable.reloadData()
            view.setNeedsDisplay()
        }
        else
        {
            results = [:]
            EventsResultsTable.isHidden = true
            EventsResultsTable.reloadData()
            view.setNeedsDisplay()
        }
    }
    
    
    // MARK: Table View Events
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return Array(results.keys).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let keysArray = Array(results.keys)
        let key = keysArray[section]
        return results[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let keysArray = Array(results.keys)
        return keysArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 84.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let eventKey = Array(results.keys)[indexPath.section]
        selectedEvent = results[eventKey]![indexPath.row]
        performSegue(withIdentifier: "editEvent", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let eventDateKey = Array(results.keys)[indexPath.section]
        let event = results[eventDateKey]?[indexPath.row] ?? JFTEvent()
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! JFTEventTableViewCell
        eventCell.TitleLabel.text = event.Title
        eventCell.LocationLabel.text = event.Location
        eventCell.SetStartAndEndTimes(start: event.StartTime, end: event.EndTime)
        eventCell.ColorIndicatorView.backgroundColor = JFTCalendar.ColorForEventWith(id: event.ID)
        return eventCell
    }
    
    
    // MARK:Navigation Events
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "editEvent"
        {
            let destinationNavVC = segue.destination as! UINavigationController
            let castDestination = destinationNavVC.viewControllers.first as! JFTAEEventMainTableViewController
            castDestination.IsEdit = true
            JFTEvent.WorkingEventHolder = selectedEvent!
        }
    }
}

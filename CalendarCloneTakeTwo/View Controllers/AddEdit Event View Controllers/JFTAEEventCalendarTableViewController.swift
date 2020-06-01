//
//  JFTAEEventCalendarTableViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 26/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTAEEventCalendarTableViewController: UITableViewController
{
    private static var selectedRow: IndexPath = IndexPath(row: 0, section: 0)
    weak var parentDelegate: JFTAEEventDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.selectRow(at: JFTAEEventCalendarTableViewController.selectedRow, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        tableView(tableView, didSelectRowAt: JFTAEEventCalendarTableViewController.selectedRow)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return JFTCalendar.LocalCalendars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let calendarRef = JFTCalendar.LocalCalendars[indexPath.row]
        let newCell = tableView.dequeueReusableCell(withIdentifier: "shortCalendarCell") as! JFTShortCalendarTableViewCell
        newCell.ColorCircle.CircleColor = calendarRef.ColorCode
        newCell.NameLabel.text = calendarRef.Name
        return newCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.RemoveAllCheckmarks()
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        JFTAEEventCalendarTableViewController.selectedRow = indexPath
        parentDelegate!.RaiseStringValueChanged(string: "\(indexPath.row)", type: .CalendarName)
    }
}

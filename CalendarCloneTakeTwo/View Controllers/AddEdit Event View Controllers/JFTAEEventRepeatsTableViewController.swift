//
//  JFTAEEventRepeatsTableViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 19/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

enum JFTRepeatType: String
{
    case Never
    case EveryWeek
    case EveryDay
    case EveryMonth
    case EveryYear
    
    static subscript(index: Int) -> JFTRepeatType
    {
        switch index
        {
            case 0:
                return .Never
            case 1:
                return .EveryDay
            case 2:
                return .EveryWeek
            case 3:
                return .EveryMonth
            case 4:
                return .EveryYear
            default:
                return .Never
        }
    }
    
    static subscript(type: JFTRepeatType) -> Int
    {
        switch type
        {
            case .Never:
                return 0
            case .EveryDay:
                return 1
            case .EveryWeek:
                return 2
            case .EveryMonth:
                return 3
            case .EveryYear:
                return 4
        }
    }
}

class JFTAEEventRepeatsTableViewController: UITableViewController
{
    static var SelectedRepeatType: JFTRepeatType = .Never
    weak var parentDelegate: JFTAEEventDelegate?

    // MARK: View Controller Events
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let indexPathToSelect = IndexPath(row: JFTRepeatType[JFTAEEventRepeatsTableViewController.SelectedRepeatType], section: 0)
        tableView.selectRow(at: indexPathToSelect, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        tableView(tableView, didSelectRowAt: indexPathToSelect)
    }
    
    
    // MARK: Table View Events
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.RemoveAllCheckmarks()
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        setComponentsForRepeatingNotification(type: JFTRepeatType[indexPath.row])
    }
    
    
    // MARK: Helper Methods
    private func setComponentsForRepeatingNotification(type: JFTRepeatType)
    {
        JFTEvent.UpdateComponentsForRepeatingNotification(for: JFTEvent.WorkingEventHolder, type: type, start: JFTEvent.WorkingEventHolder.StartTime)
        JFTAEEventRepeatsTableViewController.SelectedRepeatType = type
        parentDelegate!.RaiseStringValueChanged(string: type.rawValue, type: .Repeat)
    }
}

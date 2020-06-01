//
//  JFTAEEventAlertTableViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 19/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTAEEventAlertTableViewController: UITableViewController
{
    weak var parentDelegate: JFTAEEventDelegate?
    private var earlyDateHolder: Date = JFTEvent.WorkingEventHolder.StartTime
    private static var selectedRow: IndexPath = IndexPath(row: 0, section: 0)
    private var selectedAlertType: JFTAlertType = .None
    private var selectedValue: Int = 0
    
    enum JFTAlertType: String
    {
        case None
        case Same
        case Minutes
        case Hours
        case Days
        case Weeks
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.selectRow(at: JFTAEEventAlertTableViewController.selectedRow, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        tableView(tableView, didSelectRowAt: JFTAEEventAlertTableViewController.selectedRow)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.RemoveAllCheckmarks()
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        JFTAEEventAlertTableViewController.selectedRow = indexPath
        updateNotificationDate()
        parentDelegate!.RaiseStringValueChanged(string: tableView.cellForRow(at: indexPath)!.textLabel!.text!, type: .Alert)
    }
    
    private func selectAlertTypeFor(indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            selectedAlertType = .None
            selectedValue = 0
        }
        else
        {
            switch indexPath.row
            {
                case 0:
                    selectedAlertType = .Same
                    selectedValue = 0
                    break
                case 1:
                    selectedAlertType = .Minutes
                    selectedValue = -5
                    break
                case 2:
                    selectedAlertType = .Minutes
                    selectedValue = -10
                    break
                case 3:
                    selectedAlertType = .Minutes
                    selectedValue = -15
                    break
                case 4:
                    selectedAlertType = .Minutes
                    selectedValue = -30
                    break
                case 5:
                    selectedAlertType = .Hours
                    selectedValue = -1
                    break
                case 6:
                    selectedAlertType = .Hours
                    selectedValue = -2
                    break
                case 7:
                    selectedAlertType = .Days
                    selectedValue = -1
                    break
                case 8:
                    selectedAlertType = .Days
                    selectedValue = -2
                    break
                case 9:
                    selectedAlertType = .Weeks
                    selectedValue = -1
                    break
                default:
                    break
            }
        }
    }
    
    private func calculateNewDateForNotification()
    {
        switch selectedAlertType
        {
            case .Minutes:
                earlyDateHolder = Calendar.current.date(byAdding: DateComponents(minute: selectedValue), to: earlyDateHolder)!
                break
            case .Hours:
                earlyDateHolder = Calendar.current.date(byAdding: DateComponents(hour: selectedValue), to: earlyDateHolder)!
                break
            case .Days:
                earlyDateHolder = Calendar.current.date(byAdding: DateComponents(day: selectedValue), to: earlyDateHolder)!
                break
            case .Weeks:
                earlyDateHolder = Calendar.current.date(byAdding: DateComponents(day: (selectedValue * 7)), to: earlyDateHolder)!
                break
            default:
                return
        }
    }
    
    private func updateNotificationDate()
    {
        calculateNewDateForNotification()
        JFTEvent.UpdateComponentsForRepeatingNotification(for: JFTEvent.WorkingEventHolder, type: JFTAEEventRepeatsTableViewController.SelectedRepeatType, start: earlyDateHolder)
    }
}

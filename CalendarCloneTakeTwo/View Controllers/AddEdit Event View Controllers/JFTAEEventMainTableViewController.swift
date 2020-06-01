//
//  JFTAEEventMainTableViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

enum JFTChangedLableType
{
    case CalendarName
    case Repeat
    case Alert
}

class JFTAEEventMainTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, JFTAEEventDelegate
{
    static private var formatter: DateFormatter = DateFormatter()
    private var selectedCalendarReference: JFTCalendar = JFTCalendar.LocalCalendars[0]
    private var isStartDateSelected: Bool = false
    private var isEndDateSelected: Bool = false
    @IBOutlet weak var TitleTF: UITextField!
    @IBOutlet weak var LocationTF: UITextField!
    @IBOutlet weak var IsEntireDaySwitch: UISwitch!
    @IBOutlet weak var StartDateLabel: UILabel!
    @IBOutlet weak var StartDateDP: UIDatePicker!
    @IBOutlet weak var EndDateLabel: UILabel!
    @IBOutlet weak var EndDateDP: UIDatePicker!
    @IBOutlet weak var URLTF: UITextField!
    @IBOutlet weak var NotesTV: UITextView!
    @IBOutlet weak var CalendarNameLabel: UILabel!
    @IBOutlet weak var RepeatLabel: UILabel!
    @IBOutlet weak var AlertLabel: UILabel!
    var IsEdit: Bool = false
    
    override func loadView()
    {
        super.loadView()
        TitleTF.delegate = self
        LocationTF.delegate = self
        URLTF.delegate = self
        NotesTV.delegate = self
        CalendarNameLabel.text = selectedCalendarReference.Name
        JFTAEEventMainTableViewController.formatter.dateFormat = "MMM dd,yyyy HH:mm"
        initializeDatesForPickersAndLabels()
        initializeNavigationBar()
        if IsEdit
        {
            buildToolbarForEditEventViewController()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1
        {
            if indexPath.row == 1
            {
                isStartDateSelected = !isStartDateSelected
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            else if indexPath.row == 2
            {
                isEndDateSelected = !isEndDateSelected
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 1
        {
            if indexPath.row == 1
            {
                return isStartDateSelected ? 244.0 : 44.0
            }
            else if indexPath.row == 2
            {
                return isEndDateSelected ? 244.0 : 44.0
            }
        }
        return 44.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
            case "repeatSegue":
                let castDestination = segue.destination as! JFTAEEventRepeatsTableViewController
                castDestination.parentDelegate = self
                break
            case "alertSegue":
                let castDestination = segue.destination as! JFTAEEventAlertTableViewController
                castDestination.parentDelegate = self
                break
            case "calendarSegue":
                let castDestination = segue.destination as! JFTAEEventCalendarTableViewController
                castDestination.parentDelegate = self
                break
            default:
                return
        }
    }
    
    @IBAction func OnStartDatePick(_ sender: UIDatePicker)
    {
        StartDateLabel.text = JFTAEEventMainTableViewController.formatter.string(from: sender.date)
        JFTEvent.WorkingEventHolder.StartTime = sender.date
        adjustEndAutomaticlyByAnHour()
        let indexPathToSelect = IndexPath(row: 1, section: 1)
        tableView.selectRow(at: indexPathToSelect, animated: true, scrollPosition: .none)
                tableView(tableView, didSelectRowAt: indexPathToSelect)
    }
    
    @IBAction func OnEndDatePick(_ sender: UIDatePicker)
    {
        EndDateLabel.text = JFTAEEventMainTableViewController.formatter.string(from: sender.date)
        JFTEvent.WorkingEventHolder.EndTime = sender.date
        let indexPathToSelect = IndexPath(row: 2, section: 1)
        tableView.selectRow(at: indexPathToSelect, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: indexPathToSelect)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        JFTEvent.WorkingEventHolder.Title = TitleTF.text!
        JFTEvent.WorkingEventHolder.Location = LocationTF.text!
        JFTEvent.WorkingEventHolder.URL = URLTF.text!
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        JFTEvent.WorkingEventHolder.Notes = textView.text!
    }
    
    @IBAction func OnEntireDatSwitch(_ sender: UISwitch)
    {
        JFTEvent.WorkingEventHolder.IsAllDay = sender.isOn
    }
    
    private func initializeNavigationBar()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonTouch))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTouch))
    }
    
    private func buildToolbarForEditEventViewController()
    {
        let deleteButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(deleteButtonTouch))
        let toolbarButtons = [deleteButton]
        setToolbarItems(toolbarButtons, animated: true)
    }
    
    @objc private func deleteButtonTouch()
    {
        
    }
    
    @objc private func cancelButtonTouch()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTouch()
    {
        if IsEdit
        {
            JFTCalendar.SaveLocalCalendars()
            JFTEvent.WorkingEventHolder = JFTEvent()
            cancelButtonTouch()
        }
        else
        {
            if checkIfRequiredFieldsAreSet()
            {
                selectedCalendarReference.Events.append(JFTEvent(copy: JFTEvent.WorkingEventHolder))
                JFTCalendar.SaveLocalCalendars()
                JFTEvent.WorkingEventHolder = JFTEvent()
                cancelButtonTouch()
            }
            else
            {
                UIAlertView.init(title: "Unfinished Event", message: "Please enter a Title and choose a the time and duration of the event.\nNote that Finish time cannot be now", delegate: self, cancelButtonTitle: "Ok").show()
            }
        }
    }
    
    private func checkIfRequiredFieldsAreSet() -> Bool
    {
        if JFTEvent.WorkingEventHolder.StartTime != JFTEvent.WorkingEventHolder.EndTime && JFTEvent.WorkingEventHolder.Title != "" && !(JFTEvent.WorkingEventHolder.EndTime <= Date())
        {
            return true
        }
        return false
    }
    
    private func initializeDatesForPickersAndLabels()
    {
        StartDateDP.date = Date()
        StartDateLabel.text = JFTAEEventMainTableViewController.formatter.string(from: StartDateDP.date)
        JFTEvent.WorkingEventHolder.StartTime = StartDateDP.date
        adjustEndAutomaticlyByAnHour()
    }
    
    private func adjustEndAutomaticlyByAnHour()
    {
        EndDateDP.date = Calendar.current.date(byAdding: DateComponents(hour: 1), to: StartDateDP.date)!
        EndDateLabel.text = JFTAEEventMainTableViewController.formatter.string(from: EndDateDP.date)
        JFTEvent.WorkingEventHolder.EndTime = EndDateDP.date
    }
    
    func RaiseStringValueChanged(string: String, type: JFTChangedLableType)
    {
        switch type
        {
            case .Alert:
                AlertLabel.text = string
                break
            case .CalendarName:
                selectedCalendarReference = JFTCalendar.LocalCalendars[Int(string)!]
                CalendarNameLabel.text = selectedCalendarReference.Name
                break
            case .Repeat:
                RepeatLabel.text = string
                break
        }
    }
}

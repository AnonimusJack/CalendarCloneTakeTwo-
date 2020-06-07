//
//  JFTAECalendarTableViewController.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 19/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTAECalendarTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var NameTextField: UITextField!
    var IsEdit: Bool = false
    var Calendar: JFTCalendar = JFTCalendar()
    var ParentReference: JFTPRefreshable?
    private var colorsArray: [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.brown]
    
    override func loadView()
    {
        super.loadView()
        initializeNavigationBar()
        NameTextField.delegate = self
        NameTextField.text = self.Calendar.Name
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        ParentReference!.SetRefreshEvent()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
            case 2:
                return "Color"
            case 3:
                if !IsEdit
                {
                    return nil
                }
                return "Notifications";
            default:
                return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return 7
            case 3:
                if !IsEdit
                {
                    return 0
                }
                return 1
            default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 2
        {
            removeAllCheckmarks()
            tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
            self.Calendar.ColorCode = colorsArray[indexPath.row]
        }
    }
    
    @IBAction func EventsOnSwitch(_ sender: UISwitch)
    {
        
    }
    
    private func initializeNavigationBar()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonTouch))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTouch))
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
            cancelButtonTouch()
        }
        else
        {
            if NameTextField.text != "" && self.Calendar.ColorCode != UIColor()
            {
                JFTCalendar.LocalCalendars.append(self.Calendar)
                JFTCalendar.SaveLocalCalendars()
                cancelButtonTouch()
            }
            else
            {
                UIAlertView.init(title: "Unfinished Calendar", message: "Please enter a calendar name and choose a color", delegate: self, cancelButtonTitle: "Ok").show()
            }
        }
    }
    
    private func removeAllCheckmarks()
    {
        for cell in tableView.visibleCells
        {
            cell.accessoryType = .none
        }
    }
}

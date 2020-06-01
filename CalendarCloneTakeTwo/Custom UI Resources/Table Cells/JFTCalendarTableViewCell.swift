//
//  JFTCalendarTableViewCell.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 20/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTCalendarTableViewCell: UITableViewCell
{
    @IBOutlet weak var CalendarCheckCircle: JFTCheckCircle!
    @IBOutlet weak var CalendarNameLabel: UILabel!
    var CalendarReference: JFTCalendar = JFTCalendar()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

    
    @IBAction func OnChecked(_ sender: JFTCheckCircle)
    {
        CalendarReference.IsVisible = sender.IsChecked
    }
}

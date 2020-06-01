//
//  JFTShortCalendarTableViewCell.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 26/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTShortCalendarTableViewCell: UITableViewCell
{
    @IBOutlet weak var ColorCircle: JFTColorCircle!
    @IBOutlet weak var NameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}

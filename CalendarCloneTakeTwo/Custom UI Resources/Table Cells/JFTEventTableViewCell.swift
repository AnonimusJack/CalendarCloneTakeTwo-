//
//  JFTEventTableViewCell.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 03/06/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTEventTableViewCell: UITableViewCell
{
    private static let timeFormatter = DateFormatter()
    @IBOutlet weak var ColorIndicatorView: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var StartTimeLabel: UILabel!
    @IBOutlet weak var EndTimeLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func SetStartAndEndTimes(start: Date, end: Date)
    {
        StartTimeLabel.text = JFTEventTableViewCell.timeFormatter.string(from: start)
        EndTimeLabel.text = JFTEventTableViewCell.timeFormatter.string(from: end)
    }

    static func SetTimeFormat()
    {
        JFTEventTableViewCell.timeFormatter.dateFormat = "HH:mm"
    }
}

//
//  JFTWeekDaysTitlesView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable
class JFTWeekDaysTitlesView: UIView
{
    @IBOutlet var view: UIView!
    let xibName: String = "JFTWeekDaysTitlesView"
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
}

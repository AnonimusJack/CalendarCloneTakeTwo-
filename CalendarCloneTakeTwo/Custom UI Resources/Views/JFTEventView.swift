//
//  JFTEventView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 24/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class JFTEventView: UIView
{
    @IBOutlet var view: UIView!
    @IBOutlet weak var EventTitleLabel: UILabel!
    @IBOutlet weak var EventLocationLabel: UILabel!
    private static var xibName = "JFTEventView"
    private var colorCode: UIColor = UIColor.systemBlue
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(JFTEventView.xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        backgroundColor = colorCode.withAlphaComponent(0.5)
    }
    
    func ActivateWith(event: JFTEvent, and calendar: JFTCalendar)
    {
        colorCode = calendar.ColorCode
        backgroundColor = colorCode.withAlphaComponent(0.5)
        let eventsStartComponents = Calendar.current.dateComponents([.hour, .minute], from: event.StartTime)
        let eventViewCorrectYPosition = Double(String("\(eventsStartComponents.hour!)\(CGFloat(eventsStartComponents.minute!) / 60.0 * 100.0)"))!
        let eventViewHeight = CGFloat(event.EventDuration) / 60.0 * 100
        self.frame = CGRect(x: 40.0, y: CGFloat(eventViewCorrectYPosition), width: self.frame.width, height: eventViewHeight)
        EventTitleLabel.text = event.Title
        EventLocationLabel.text = event.Location
        self.view.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect)
    {
        let borderPath = UIBezierPath(rect: rect)
        borderPath.lineWidth = 3
        colorCode.setStroke()
        borderPath.stroke()
    }

}

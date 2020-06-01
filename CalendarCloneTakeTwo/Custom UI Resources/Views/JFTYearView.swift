//
//  JFTYearView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation
import UIKit

class JFTYearView : UIView, JFTPDatable
{
    @IBInspectable var HighlightColor: UIColor = UIColor.purple
    @IBOutlet var view: UIView!
    @IBOutlet weak var YearLable: UILabel!
    @IBOutlet weak var monthsLayoutView: UIView!
    var YearObject: JFTYear
    let xibName: String = "JFTYearView"
    
    convenience init(year: Int, frame: CGRect)
    {
        self.init(frame: frame)
        YearObject = JFTYear(year: year)
        self.layoutMonthViews()
        YearLable.text = String(YearObject.Year)
        YearLable.textColor = HighlightColor
    }
    
    override init(frame: CGRect)
    {
        YearObject = JFTYear(year: 2000)
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder: NSCoder)
    {
        YearObject = JFTYear(year: 2000)
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func layoutMonthViews()
    {
        var m: Int = 0
        let mViewFrame: CGSize = CGSize(width: 100, height: 100)
        for i in 0...3
        {
            for j in 0...2
            {
                let mViewPoint: CGPoint = self.calculateViewPosition(row: i, col: j)
                let monthView: JFTMonthView = JFTMonthView(month: YearObject.Months[m], frame: CGRect(origin: mViewPoint, size: mViewFrame), isSmallView: true)
                monthView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMonthViewTouch)))
                monthsLayoutView.addSubview(monthView)
                m += 1
            }
        }
    }
    
    private func calculateViewPosition(row: Int, col: Int) -> CGPoint
    {
        //Recalculate
        let x: CGFloat = (CGFloat(col) / 3) * monthsLayoutView.frame.width
        var y: CGFloat = (CGFloat(row) / 4) * monthsLayoutView.frame.height
        if row != 0
        {
            y -= 33
        }
        
        return CGPoint(x: x, y: y)
    }
    
    @objc private func onMonthViewTouch(sender: UITapGestureRecognizer)
    {
        let selectedView = sender.view as! JFTMonthView
        JFTYearViewController.CurrentReference!.OnMonthSelected(selected: selectedView.GetDate())
    }
    
    func GetDate() -> Date
    {
        YearObject.GetDate()
    }
}

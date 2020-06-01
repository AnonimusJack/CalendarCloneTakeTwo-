//
//  JFTColorCircle.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 19/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable
class JFTColorCircle: UIView
{
    @IBInspectable var CircleColor: UIColor = UIColor.brown

    override func draw(_ rect: CGRect)
    {
        drawColoredCircle(rect)
    }
    
    func drawColoredCircle(_ rect: CGRect)
    {
        let circlePath: UIBezierPath = UIBezierPath(ovalIn: rect)
        CircleColor.setFill()
        circlePath.fill()
    }
}

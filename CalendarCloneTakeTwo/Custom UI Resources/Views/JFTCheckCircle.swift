//
//  JFTCheckCircle.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 20/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable
class JFTCheckCircle: UIControl
{
    @IBInspectable var IsChecked: Bool = true
    @IBInspectable var CircleColor: UIColor = UIColor.blue

    
    // MARK: Componenets Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        IsChecked = !IsChecked
        sendActions(for: UIControl.Event.valueChanged)
        setNeedsDisplay()
    }
    
    
    // MARK: Drawing Methods
    override func draw(_ rect: CGRect)
    {
        let correctedFrame = CGRect(x: rect.origin.x + 2, y: rect.origin.y + 2, width: rect.width - 4, height: rect.height - 4)
        drawColoredCircle(correctedFrame)
        if IsChecked
        {
            drawCheckMark(correctedFrame)
        }
    }
    
    func drawColoredCircle(_ rect: CGRect)
    {
        let circlePath: UIBezierPath = UIBezierPath(ovalIn: rect)
        if IsChecked
        {
            CircleColor.setFill()
            circlePath.fill()
        }
        else
        {
            circlePath.lineWidth = 2
            CircleColor.setStroke()
            circlePath.stroke()
        }
    }
    
    func drawCheckMark(_ rect: CGRect)
    {
        let checkBox: CGRect = CGRect(x: (rect.width * (1/4)), y: (rect.height * (1/4)), width: (rect.width * (1/2)), height: (rect.height * (1/2)))
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: checkBox.origin.x, y: checkBox.height * 1.2))
        checkmarkPath.addLine(to: CGPoint(x: (rect.width / 2), y: checkBox.height * 1.7))
        checkmarkPath.addLine(to: CGPoint(x: checkBox.width * 1.7, y: checkBox.origin.y * 1.4))
        checkmarkPath.lineWidth = 2.5
        UIColor.white.setStroke()
        checkmarkPath.stroke()
    }
}

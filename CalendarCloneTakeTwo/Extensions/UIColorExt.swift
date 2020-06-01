//
//  UIColorExt.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 31/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

extension UIColor
{
    var Name: String?
    {
        switch self
        {
            case UIColor.black:
                return "black"
            case UIColor.darkGray:
                return "darkGray"
            case UIColor.lightGray:
                return "lightGray"
            case UIColor.white:
                return "white"
            case UIColor.gray:
                return "gray"
            case UIColor.red:
                return "red"
            case UIColor.green:
                return "green"
            case UIColor.blue:
                return "blue"
            case UIColor.cyan:
                return "cyan"
            case UIColor.yellow:
                return "yellow"
            case UIColor.magenta:
                return "magenta"
            case UIColor.orange:
                return "orange"
            case UIColor.purple:
                return "purple"
            case UIColor.brown:
                return "brown"
            default:
                return nil
        }
    }
    
    static func ColorByName(name: String) -> UIColor
    {
        switch name
        {
            case "black":
                return UIColor.black
            case "darkGray":
                return UIColor.darkGray
            case "lightGray":
                return UIColor.lightGray
            case "white":
                return UIColor.white
            case "gray":
                return UIColor.gray
            case "red":
                return UIColor.red
            case "green":
                return UIColor.green
            case "blue":
                return UIColor.blue
            case "cyan":
                return UIColor.cyan
            case "yellow":
                return UIColor.yellow
            case "magenta":
                return UIColor.magenta
            case "orange":
                return UIColor.orange
            case "purple":
                return UIColor.purple
            case "brown":
                return UIColor.brown
            default:
                return UIColor.clear
        }
    }
}

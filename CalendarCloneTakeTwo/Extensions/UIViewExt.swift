//
//  UIViewExt.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
import UIKit

extension UIView
{
    ///Extension: Adds small shadow to the bottom of the view
    func addShadowToBottomOfView()
    {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
}

//
//  JFTPDelegatable.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 24/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

protocol JFTAEEventDelegate: AnyObject
{
    ///Signals the main View Controller to change one of it's String values
    func RaiseStringValueChanged(string: String, type: JFTChangedLableType)
}

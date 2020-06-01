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
    func RaiseStringValueChanged(string: String, type: JFTChangedLableType)
}

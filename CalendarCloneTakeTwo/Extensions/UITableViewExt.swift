//
//  UITableViewExt.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 26/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

extension UITableView
{
    ///Extension: Removes all checkmarks inside a tableview
    func RemoveAllCheckmarks()
    {
        for cell in self.visibleCells
        {
            if cell.accessoryType == .checkmark
            {
                cell.accessoryType = .none
            }
        }
    }
}

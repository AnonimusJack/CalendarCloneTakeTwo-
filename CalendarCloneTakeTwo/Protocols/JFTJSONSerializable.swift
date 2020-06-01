//
//  JFTJSONSerializable.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 31/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

protocol JFTJSONSerializable
{
    func Serialize() -> Dictionary<String, Any>
    func Deserialize(json: Dictionary<String, Any>)
    init()
}

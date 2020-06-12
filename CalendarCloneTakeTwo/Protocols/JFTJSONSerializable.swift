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
    ///Serialize a swift Object into a JSON compatable dictionary
    func Serialize() -> Dictionary<String, Any>
    ///Deserialize a JSON dictionary read from file into a swift Object
    func Deserialize(json: Dictionary<String, Any>)
    //Required for the fetch and save methods
    init()
}

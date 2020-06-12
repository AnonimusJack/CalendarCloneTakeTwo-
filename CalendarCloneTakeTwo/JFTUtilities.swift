//
//  JFTUtilities.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
import Foundation

class JFTUtilities
{
    // MARK: JSON IO Methods
    ///Saves the sent Object to a JSON file in the documents folder
    static func SaveLocalData<T>(filename: String, objectToSave: T) where T : JFTJSONSerializable
    {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        guard let stream = OutputStream(toFileAtPath: fullPath.path, append: false)
            else
        {
            print("Error getting the Path..")
            return
        }
        stream.open()
        defer { stream.close() }
        var error: NSError?
        let JSONData = objectToSave.Serialize()
        JSONSerialization.writeJSONObject(JSONData, to: stream, options: [], error: &error)
        if let error = error
        {
            print(error)
        }
    }
    
    ///Saves the sent  Array of Objects to a JSON file in the documents folder
    static func SaveLocalData<T>(filename: String, objectToSave: [T]) where T : JFTJSONSerializable
    {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        guard let stream = OutputStream(toFileAtPath: fullPath.path, append: false)
            else
        {
            print("Error getting the Path..")
            return
        }
        stream.open()
        defer { stream.close() }
        var error: NSError?
        var JSONData: [Dictionary<String,Any>] = []
        for data in objectToSave
        {
            JSONData.append(data.Serialize())
        }
        JSONSerialization.writeJSONObject(JSONData, to: stream, options: [], error: &error)
        if let error = error
        {
            print(error)
        }
    }
    
    ///Returns an Array of Objects from a JSON file in the documents folder
    static func LoadLocalData<T>(filename: String) -> [T]? where T : JFTJSONSerializable
    {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        guard let stream = InputStream(url: fullPath)
            else
        {
            return nil
        }
        stream.open()
        defer { stream.close() }
        do
        {
            guard let jsonDictionaries = try JSONSerialization.jsonObject(with: stream, options: []) as? [Dictionary<String,Any>]
                else
            {
                return nil
            }
            var objectArray: [T] = []
            for json in jsonDictionaries
            {
                let deserializedObject = T()
                deserializedObject.Deserialize(json: json)
                objectArray.append(deserializedObject)
            }
            return objectArray
        }
        catch
        {
            print(error)
        }
        return nil
    }
    
    ///Gets the current documents folder path
    static private func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

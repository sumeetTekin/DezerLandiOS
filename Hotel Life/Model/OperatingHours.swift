//
//  OperatingHours.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 22/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

public class OperatingHours: NSObject {
    var day : String?
    var isOpen : Bool? = false
    var startTime : Date?
    var endTime : Date?
    var timeArray : [String]?
    public class func modelsFromDictionaryArray(array:NSArray) -> [OperatingHours]
    {
        var models:[OperatingHours] = []
        for item in array
        {
            models.append(OperatingHours(dictionary: item as! NSDictionary)!)
        }
        return models
    }
        
    required public init?(dictionary: NSDictionary) {
        super.init()
        print(dictionary)
        day = dictionary["value"] as? String
        if let val = day {
            if let dict = dictionary[val] as? NSDictionary{
                isOpen = dict["open"] as? Bool
                if isOpen == true {
                    if let time = dict["start"] as? String, time != "" {
                        if let date = Helper.getOptionalDateFromString(string: time, formatString: DATEFORMATTER.hhmma) {
                            startTime = date
                        }
                    }
                    if let time = dict["end"] as? String, time != "" {
                        if let date = Helper.getOptionalDateFromString(string: time, formatString: DATEFORMATTER.hhmma) {
                            endTime = date
                        }
                    }
                    if startTime != nil && endTime != nil{
                        timeArray = getDateArray()
                    }
                }
            }
        }
    }
    
    func getDateArray() -> [String]{
        var array : [String] = []
        let calendar = Calendar.current
        var component = DateComponents()
        var time = startTime!
        while time <= endTime! {
          let timeString = Helper.getStringFromDate(format: DATEFORMATTER.HA, date: time)
            array.append(timeString)
            component.hour = 1
            time = calendar.date(byAdding: component, to: time)!
        }
        return array
    }
}

//
//  OperatingHoursSlot.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 31/08/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import Foundation
import UIKit

public class OperatingHoursSlot: NSObject {
    var day : String?
    var isOpen : Bool? = false
//    var startTime : Date?
//    var endTime : Date?
    var slotsArray : [OperatingTimeSlot] = []
    var timeArray : [String] = []
    public class func modelsFromDictionaryArray(array:NSArray) -> [OperatingHoursSlot]
    {
        var models:[OperatingHoursSlot] = []
        for item in array
        {
            models.append(OperatingHoursSlot(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        super.init()
        print(dictionary)
        
        day = dictionary["value"] as? String
        isOpen = dictionary["open"] as? Bool
        if isOpen == true {
            timeArray.removeAll()
            if let val = day {
                if let operatingHours = dictionary[val] as? [[String : Any]]{
                    self.slotsArray = OperatingTimeSlot.modelsFromDictionaryArray(array: operatingHours as NSArray)
                    for slot in slotsArray {
                        var timeArr = self.timeArray
                        for time in slot.timeArray {
                            if !timeArr.contains(time) {
                                timeArr.append(time)
                            }
                        }
                        self.timeArray = timeArr
                    }
                }
            }
        }
    }
    
    
}
public class OperatingTimeSlot: NSObject {
    var startTime : Date?
    var endTime : Date?
    var timeArray : [String] = []

    public class func modelsFromDictionaryArray(array:NSArray) -> [OperatingTimeSlot]
    {
        var models:[OperatingTimeSlot] = []
        for item in array
        {
            models.append(OperatingTimeSlot(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        super.init()
        if let time = dictionary["start"] as? String, time != "" {
            if let date = Helper.getOptionalTimeFromString(string: time, formatString: DATEFORMATTER.hhmma) {
                startTime = date
            }
        }
        if let time = dictionary["end"] as? String, time != "" {
            if let date = Helper.getOptionalTimeFromString(string: time, formatString: DATEFORMATTER.hhmma) {
                endTime = date
            }
        }
        if startTime != nil && endTime != nil{
//            var timeArr = self.timeArray
//                for time in getTimeArray() {
//                    if !timeArr.contains(time) {
//                        timeArr.append(time)
//                    }
//                }
                self.timeArray = getTimeArray()
        }
    }
    func getTimeArray() -> [String]{
        var array : [String] = []
        let calendar = Calendar.current
        var component = DateComponents()
        var time = startTime!
        while time <= endTime! {
            let timeString = Helper.getTimeStringFromDate(format: DATEFORMATTER.HA, date: time)
            array.append(timeString)
            component.hour = 1
            time = calendar.date(byAdding: component, to: time)!
        }
        return array
    }
}

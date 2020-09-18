//
//  DeviceInfo.swift
//  Hotel Life
//
//  Created by Adil Mir on 2/1/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class DeviceInfo: NSObject {
    public var _link : Link?
    public var address : String?
    public var cool_setpoint : Double?
    public var cool_setpoint_max : Double?
    public var cool_setpoint_min : Double?
    public var fanspeed : String?
    public var fanspeed_allowed : Array<String>?
    public var fanspeed_state : String?
    public var heat_setpoint : Double?
    public var heat_setpoint_max : Double?
    public var heat_setpoint_min : Double?
    public var mode : String?
    public var mode_allowed : Array<String>?
    public var mode_state : String?
    public var occupied : Bool?
    public var temperature : Double?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [DeviceInfo]
    {
        var models:[DeviceInfo] = []
        for item in array
        {
            models.append(DeviceInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let data = Data(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Data Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["_link"] != nil) { _link = Link(dictionary: dictionary["_link"] as! NSDictionary) }
        address = dictionary["address"] as? String
        cool_setpoint = dictionary["cool-setpoint"] as? Double
        cool_setpoint_max = dictionary["cool-setpoint-max"] as? Double
        cool_setpoint_min = dictionary["cool-setpoint-min"] as? Double
        fanspeed = dictionary["fanspeed"] as? String
        if (dictionary["fanspeed-allowed"] != nil) { fanspeed_allowed = dictionary["fanspeed-allowed"] as! NSArray as! Array<String> }
        fanspeed_state = dictionary["fanspeed-state"] as? String
        heat_setpoint = dictionary["heat-setpoint"] as? Double
        heat_setpoint_max = dictionary["heat-setpoint-max"] as? Double
        heat_setpoint_min = dictionary["heat-setpoint-min"] as? Double
        mode = dictionary["mode"] as? String
        if (dictionary["mode-allowed"] != nil) { mode_allowed = dictionary["mode-allowed"] as! Array<String> }
        mode_state = dictionary["mode-state"] as? String
        occupied = dictionary["occupied"] as? Bool
        temperature = dictionary["temperature"] as? Double
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._link?.dictionaryRepresentation(), forKey: "_link")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.cool_setpoint, forKey: "cool-setpoint")
        dictionary.setValue(self.cool_setpoint_max, forKey: "cool-setpoint-max")
        dictionary.setValue(self.cool_setpoint_min, forKey: "cool-setpoint-min")
        dictionary.setValue(self.fanspeed, forKey: "fanspeed")
        dictionary.setValue(self.fanspeed_state, forKey: "fanspeed-state")
        dictionary.setValue(self.heat_setpoint, forKey: "heat-setpoint")
        dictionary.setValue(self.heat_setpoint_max, forKey: "heat-setpoint-max")
        dictionary.setValue(self.heat_setpoint_min, forKey: "heat-setpoint-min")
        dictionary.setValue(self.mode, forKey: "mode")
        dictionary.setValue(self.mode_state, forKey: "mode-state")
        dictionary.setValue(self.occupied, forKey: "occupied")
        dictionary.setValue(self.temperature, forKey: "temperature")
        
        return dictionary
    }
    
}

//
//  Thermostat.swift
//  Resort Life
//
//  Created by Adil Mir on 1/15/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import Foundation
class Thermostat:NSObject{
    public var coolSetpoint : Double?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let thermostat_list = Thermostat.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Thermostat Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Thermostat]
    {
        var models:[Thermostat] = []
        for item in array
        {
            models.append(Thermostat(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let thermostat = Thermostat(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Thermostat Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        coolSetpoint = dictionary["cool-setpoint"] as? Double
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.coolSetpoint, forKey: "cool-setpoint")
        
        return dictionary
    }
    
}

//
//  Tkorouter.swift
//  Resort Life
//
//  Created by Adil Mir on 1/15/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import Foundation
class Tkorouter:NSObject{
    public var thermostat : Thermostat?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let tkorouter_list = Tkorouter.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Tkorouter Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Tkorouter]
    {
        var models:[Tkorouter] = []
        for item in array
        {
            models.append(Tkorouter(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let tkorouter = Tkorouter(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Tkorouter Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["thermostat"] != nil) { thermostat = Thermostat(dictionary: dictionary["thermostat"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.thermostat?.dictionaryRepresentation(), forKey: "thermostat")
        
        return dictionary
    }
    
}

//
//  ThermostatModel.swift
//  Resort Life
//
//  Created by Adil Mir on 1/15/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import Foundation

class ThermostatAPIResponse:NSObject{
    public var type : String?
    public var datetime : String?
    public var payload : Payload?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ThermostatAPIResponse]
    {
        var models:[ThermostatAPIResponse] = []
        for item in array
        {
            models.append(ThermostatAPIResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        type = dictionary["type"] as? String
        datetime = dictionary["datetime"] as? String
        if (dictionary["payload"] != nil) { payload = Payload(dictionary: dictionary["payload"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.datetime, forKey: "datetime")
        dictionary.setValue(self.payload?.dictionaryRepresentation(), forKey: "payload")
        
        return dictionary
    }
    
}

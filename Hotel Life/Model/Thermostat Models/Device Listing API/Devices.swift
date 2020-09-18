//
//  Devices.swift
//  Hotel Life
//
//  Created by Adil Mir on 2/1/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class Devices: NSObject {
    public var _link : Link?
    public var address : String?
    public var type : String?
    public var label:String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let devices_list = Devices.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Devices Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Devices]
    {
        var models:[Devices] = []
        for item in array
        {
            models.append(Devices(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let devices = Devices(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Devices Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["_link"] != nil) { _link = Link(dictionary: dictionary["_link"] as! NSDictionary) }
        address = dictionary["address"] as? String
        type = dictionary["type"] as? String
        label = dictionary["label"] as? String ?? "Unnamed Device"
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._link?.dictionaryRepresentation(), forKey: "_link")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.label,forKey: "label")
        
        return dictionary
    }
    
}

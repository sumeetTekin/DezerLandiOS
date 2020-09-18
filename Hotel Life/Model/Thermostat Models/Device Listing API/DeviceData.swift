//
//  DeviceData.swift
//  Hotel Life
//
//  Created by Adil Mir on 2/1/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class DeviceData: NSObject {
    public var _link : Link?
    public var address : String?
    public var devices : Array<Devices>?
    public var privacy : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Data Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [DeviceData]
    {
        var models:[DeviceData] = []
        for item in array
        {
            models.append(DeviceData(dictionary: item as! NSDictionary)!)
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
        if (dictionary["devices"] != nil) { devices = Devices.modelsFromDictionaryArray(array: dictionary["devices"] as! NSArray) }
        privacy = dictionary["privacy"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._link?.dictionaryRepresentation(), forKey: "_link")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.privacy, forKey: "privacy")
        
        return dictionary
    }
    
}

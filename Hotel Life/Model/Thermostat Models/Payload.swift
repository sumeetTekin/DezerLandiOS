//
//  Payload.swift
//  Resort Life
//
//  Created by Adil Mir on 1/15/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import Foundation
class Payload:NSObject{
    public var changes : Changes?
    public var roomNumber : String?
    public var coordinatorAddress : String?
    public var address : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let payload_list = Payload.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Payload Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Payload]
    {
        var models:[Payload] = []
        for item in array
        {
            models.append(Payload(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let payload = Payload(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Payload Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["changes"] != nil) { changes = Changes(dictionary: dictionary["changes"] as! NSDictionary) }
        roomNumber = dictionary["room-number"] as? String
        coordinatorAddress = dictionary["coordinator-address"] as? String
        address = dictionary["address"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.changes?.dictionaryRepresentation(), forKey: "changes")
        dictionary.setValue(self.roomNumber, forKey: "room-number")
        dictionary.setValue(self.coordinatorAddress, forKey: "coordinator-address")
        dictionary.setValue(self.address, forKey: "address")
        
        return dictionary
    }
    
}


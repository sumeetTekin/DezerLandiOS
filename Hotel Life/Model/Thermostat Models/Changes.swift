//
//  Changes.swift
//  Resort Life
//
//  Created by Adil Mir on 1/15/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import Foundation

class Changes:NSObject {
    public var tkorouter : Tkorouter?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let changes_list = Changes.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Changes Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Changes]
    {
        var models:[Changes] = []
        for item in array
        {
            models.append(Changes(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let changes = Changes(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Changes Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["tkorouter"] != nil) { tkorouter = Tkorouter(dictionary: dictionary["tkorouter"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.tkorouter?.dictionaryRepresentation(), forKey: "tkorouter")
        
        return dictionary
    }
    
}

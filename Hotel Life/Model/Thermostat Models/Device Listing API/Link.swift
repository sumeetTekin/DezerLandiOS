//
//  Link.swift
//  Hotel Life
//
//  Created by Adil Mir on 2/1/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class Link: NSObject {
    public var _self : String?
    public var discovery : String?
    public var tkorouter : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let _link_list = _link.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of _link Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Link]
    {
        var models:[Link] = []
        for item in array
        {
            models.append(Link(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let _link = _link(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: _link Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _self = dictionary["_self"] as? String
        discovery = dictionary["discovery"] as? String
        tkorouter = dictionary["tkorouter"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._self, forKey: "_self")
        dictionary.setValue(self.discovery, forKey: "discovery")
        dictionary.setValue(self.tkorouter, forKey: "tkorouter")
        
        return dictionary
    }
    
}

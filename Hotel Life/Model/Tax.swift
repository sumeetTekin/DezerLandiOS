//
//  Tax.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 17/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

public class Tax: NSObject {
    public var county_tax : Float?
    public var service_charge : Float?
    public var state_tax : Float?
    public var delivery_charge : Float?
    public var delivery_charge_percent : Float?
    
   
    public class func modelsFromDictionaryArray(array:NSArray) -> [Tax]
    {
        var models:[Tax] = []
        for item in array
        {
            models.append(Tax(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        county_tax = dictionary["county_tax"] as? Float
        service_charge = dictionary["service_charge"] as? Float
        state_tax = dictionary["state_tax"] as? Float
        delivery_charge = dictionary["delivery_charge"] as? Float
        delivery_charge_percent = dictionary["delivery_charge_percent"] as? Float
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.county_tax, forKey: "county_tax")
        dictionary.setValue(self.service_charge, forKey: "service_charge")
        dictionary.setValue(self.state_tax, forKey: "state_tax")
        dictionary.setValue(self.delivery_charge, forKey: "delivery_charge")
        dictionary.setValue(self.delivery_charge_percent, forKey: "delivery_charge_percent")
        
        return dictionary
    }
    
    

}

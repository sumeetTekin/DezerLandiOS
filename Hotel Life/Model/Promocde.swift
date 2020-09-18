//
//  Promocde.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 21/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

public class Promocode: NSObject {
    public var promocode_id : String?
    public var code : String?
    public var value : Float?
    public var type : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Promocode]
    {
        var models:[Promocode] = []
        for item in array
        {
            models.append(Promocode(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        promocode_id = dictionary["_id"] as? String
        code = dictionary["code"] as? String
        value = dictionary["value"] as? Float
        type = dictionary["type"] as? String
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.promocode_id, forKey: "promocode_id")
        dictionary.setValue(self.value, forKey: "value")
        dictionary.setValue(self.type, forKey: "type")
        return dictionary
    }
    
}

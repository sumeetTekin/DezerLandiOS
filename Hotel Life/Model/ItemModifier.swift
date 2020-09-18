//
//  ItemModifier.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 27/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

public class ItemModifier: NSObject {
    public var name : String? = ""
    public var posItemId : String? = ""
    
    override init() {
        
    }
    
    public class func modelsFromDictionaryArray(array:NSArray, imagePath : String) -> [ItemModifier]
    {
        var models:[ItemModifier] = []
        for item in array
        {
            models.append(ItemModifier(dictionary: item as! NSDictionary, imagePath : imagePath)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary , imagePath : String) {
        
        if let text = dictionary["name"] as? String {
            name = text
        }
        
    }

}

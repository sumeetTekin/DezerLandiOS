//
//  Modifier.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 26/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

public class Modifier: NSObject {
    
    public var name : String? = ""
    public var posItemId : String? = ""
    public var parentGroupId : Int?
    public var price : String? = ""
    public var desc : String? = ""
    public var modifierId : Int?
    public var itemModifiers : [ItemModifier]? = []
    
    override init() {
        
    }
    
    public class func modelsFromDictionaryArray(array:NSArray, parentGroupId : Int?) -> [Modifier]
    {
        
        var models:[Modifier] = []
        for item in array
        {
            if let modifier = Modifier(dictionary: item as! NSDictionary, parentGroupId : parentGroupId) {
                if modifier.name != "" {
                    models.append(modifier)
                }
            }
            
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary , parentGroupId : Int?) {
//        print(dictionary)
        self.parentGroupId = parentGroupId
        if let text = dictionary["Name"] as? String {
            name = text
        }
        if let text = dictionary["POSItemId"] as? Int {
            posItemId = "\(text)"
        }
        if let id = dictionary["ModifierId"] as? Int {
            modifierId = id
        }
        
        if let itemModi = dictionary["ItemModifiers"] as? NSArray {
            if let item = itemModi.firstObject as? NSDictionary {
                if let price = item["Price"] as? Float {
                    self.price = String(format : "%.2f",price)
                }
            }
        }
        if let desc = dictionary["description"] as? String {
            self.desc = "\(desc)"
        }
        
        
        if let items = dictionary["ItemModifiers"] as? NSArray {
            itemModifiers = ItemModifier.modelsFromDictionaryArray(array: items, imagePath: "")
        }
            
    }

}

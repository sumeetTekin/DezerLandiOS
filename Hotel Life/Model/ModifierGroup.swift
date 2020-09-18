//
//  ModifierGroup.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 26/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

public class ModifierGroup: NSObject {
    
    public var modifiers : [Modifier]? = []
    public var name : String? = ""
    public var minCount : Int = 0
    public var maxCount : Int = 0
    public var modifierGroupId : Int?
    
    override init() {
        
    }
    
    public class func modelsFromDictionaryArray(array:[NSDictionary], imagePath : String, sortArray : [Int]?) -> [ModifierGroup]
    {
        var models:[ModifierGroup] = []
        if let arr = sortArray, arr.count > 0 {
            for item in arr
            {
                let filteredArray = array.filter{
                    $0["ModifierGroupId"] as? Int == item
                }
                if let item = filteredArray.first {
                    if let group = ModifierGroup(dictionary: item, imagePath : imagePath) {
                        models.append(group)
                    }
                }
            }
        }
        else {
            for item in array
            {
                if let group = ModifierGroup(dictionary: item, imagePath : imagePath) {
                    models.append(group)
                }
                
            }
        }
        
        return models
    }
    
    
    required public init?(dictionary: NSDictionary , imagePath : String) {
//        print(dictionary)
        if let text = dictionary["ModifierGroupId"] as? Int {
            modifierGroupId = text
        }
        if let modi = dictionary["modi"] as? NSArray {
            modifiers = Modifier.modelsFromDictionaryArray(array: modi, parentGroupId: modifierGroupId)
        }
        if let text = dictionary["Name"] as? String {
            name = text
        }
        if let count = dictionary["MinimumItems"] as? Int {
            minCount = count
        }
        if let count = dictionary["MaximumItems"] as? Int {
            maxCount = count
        }
        
    }
}

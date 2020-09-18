//
//  DefaultOption.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 15/05/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

public class DefaultOption: NSObject {
    public var defaultReason : Int?
    public var modifierGroupId : Int?
    public var modifierId : Int?
//    DefaultQuantity = 1;
//    DefaultReason = 1;
//    ItemOptionSetId = 0;
//    ModifierAction = 0;
//    ModifierGroupId = 8248;
//    ModifierId = 2328;
        public class func modelsFromDictionaryArray(array:NSArray) -> [DefaultOption]
        {
            var models:[DefaultOption] = []
            for item in array
            {
                if let item = item as? NSDictionary {
                    if let model = DefaultOption(dictionary: item) {
                        models.append(model)
                    }
                }
            }
            return models
        }
    required public init?(dictionary: NSDictionary) {
        if let id = dictionary["ModifierGroupId"] as? Int {
            modifierGroupId = id
        }
        if let id = dictionary["ModifierId"] as? Int {
            modifierId = id
        }
        if let id = dictionary["DefaultReason"] as? Int {
            defaultReason = id
        }
        
        
        
    }
}

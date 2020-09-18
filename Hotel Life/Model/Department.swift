//
//  Department.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 08/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class Department: NSObject {
    
        public var items : [Menu]? = []
        public var name : String? = ""
        public var slug : String? = ""
        public var is_drink : Bool = false
        override init() {
            
        }
        
    public class func modelsFromDictionaryArray(array:NSArray, imagePath : String, is_drink : Bool) -> [Department]
        {
            var models:[Department] = []
            for item in array
            {
                models.append(Department(dictionary: item as! NSDictionary, imagePath : imagePath, is_drink : is_drink)!)
            }
            return models
        }
        
        
        required public init?(dictionary: NSDictionary , imagePath : String, is_drink : Bool) {
            // check if it is a drink department
            
            self.is_drink = is_drink
            if let menus = dictionary["items"] as? NSArray {
                items = Menu.modelsFromDictionaryArray(array: menus, imagePath: imagePath, is_drink: self.is_drink)
            }
            if let text = dictionary["name"] as? String {
                name = text
            }
            if let text = dictionary["slug"] as? String {
                slug = text
            }
        }
    }

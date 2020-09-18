//
//  Service.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 20/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class Service: NSObject {
    
    var id : String? = ""
    var label : String? = ""
    var comment : String? = ""
    var date : String? = ""
    var menu : Menu?
    var room_number : String?
    
    override init() {
        
    }
    
    public class func modelsFromDictionaryArray(array:NSArray, menu : Menu) -> [Service]
    {
        var models:[Service] = []
        for item in array
        {
            models.append(Service(dictionary: item as! NSDictionary, menu : menu)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary, menu : Menu) {
        // For Menu
        if let _id = dictionary["_id"] as? String {
            id = _id
        }
        if let name = dictionary["name"] as? String {
            label = name
        }
        self.menu = menu
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        if let module_id = menu?.module_id {
           dictionary.setValue(module_id , forKey: "module_id")
        }
        if let department_id = menu?.department_Id {
            dictionary.setValue(department_id, forKey: "department_id")

        }
        if let dateStr = date {
            dictionary.setValue(dateStr, forKey: "appointment_date")
        }
        if let idStr = id {
            dictionary.setValue(idStr, forKey: "maintenance_option_id")
        }
        if let room_number = room_number {
            dictionary.setValue(room_number, forKey: "room_number")
        }
        dictionary.setValue(self.comment, forKey: "comment")
        return dictionary
    }
}

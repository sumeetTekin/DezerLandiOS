//
//  Items_attributes.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 11/02/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation

public class Items_attributes:NSObject {
	public var default_time : String?
	public var descriptionItem : Bool?
	public var instant_order : Bool?
	public var link : Bool? = false
	public var price : Bool?
	public var price_suffix : String?
    public var extra_amenities : [String]?
	public var quantity : Bool = false
    public var ask_gender : Bool? = false
    public var hide_cancel : Bool? = false
    public var hide_modify : Bool? = false
    public var is_restaurant : Bool? = false
    public var is_map_seat : Bool? = false
    public var time_error : String?
    public var is_payment_selection : Bool?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Items_attributes]
    {
        var models:[Items_attributes] = []
        for item in array
        {
            models.append(Items_attributes(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
		default_time = dictionary["default_time"] as? String
        descriptionItem = dictionary["description"] as? Bool
		instant_order = dictionary["instant_order"] as? Bool
		link = dictionary["link"] as? Bool
		price = dictionary["price"] as? Bool
		price_suffix = dictionary["price_suffix"] as? String
        // check max quantity - day bed
        if let isQuantity = dictionary["quantity"] as? Bool
        {
            quantity = isQuantity
        }
        if let amenities = dictionary["extra_amenities"] as? String
        {
            extra_amenities = amenities.components(separatedBy: ", ")
        }
        is_payment_selection = dictionary["is_payment_selection"] as? Bool
        ask_gender = dictionary["ask_gender"] as? Bool
        hide_cancel = dictionary["hide_cancel"] as? Bool
        hide_modify = dictionary["hide_modify"] as? Bool
        
        time_error = dictionary["time_error"] as? String
        is_restaurant = dictionary["is_restaurant"] as? Bool
        is_map_seat = dictionary["is_map_seat"] as? Bool
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.default_time, forKey: "default_time")
		dictionary.setValue(self.descriptionItem, forKey: "description")
		dictionary.setValue(self.instant_order, forKey: "instant_order")
		dictionary.setValue(self.link, forKey: "link")
		dictionary.setValue(self.price, forKey: "price")
		dictionary.setValue(self.price_suffix, forKey: "price_suffix")
		dictionary.setValue(self.quantity, forKey: "quantity")
        dictionary.setValue(self.is_restaurant, forKey: "is_restaurant")
        dictionary.setValue(self.is_payment_selection, forKey: "is_payment_selection")
		return dictionary
	}

}

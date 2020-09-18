/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class DepartmentOrder {
	public var _id : String?
	public var name : String?
	public var image : String?
	public var module_id : String?
	public var department_type : String?
	public var __v : Int?
	public var items_attributes : Items_attributesOrder?
	public var mobile_number : String?
	public var country_code : String?
	public var disclaimer : String?
	public var sort_order : Int?
	public var inactive_message : String?
	public var is_active_TGrande : Bool?
	public var operating_hours_slots : Array<Operating_hours_slots>?
	public var operating_hours : Array<Operating_hours>?
	public var is_operating : Bool?
	public var created : String?
	public var is_deleted : Bool?
	public var is_active : Bool?
	public var tax : TaxOrder?
	public var include_tax : Bool?
	public var order_type : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let department_list = Department.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Department Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [DepartmentOrder]
    {
        var models:[DepartmentOrder] = []
        for item in array
        {
            models.append(DepartmentOrder(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let department = Department(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Department Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		if (dictionary["name"] != nil) {
            name = dictionary["name"] as? String
            
        }
		image = dictionary["image"] as? String
		module_id = dictionary["module_id"] as? String
		department_type = dictionary["department_type"] as? String
		__v = dictionary["__v"] as? Int
		if (dictionary["items_attributes"] != nil) { items_attributes = Items_attributesOrder(dictionary: dictionary["items_attributes"] as! NSDictionary) }
		mobile_number = dictionary["mobile_number"] as? String
		country_code = dictionary["country_code"] as? String
		disclaimer = dictionary["disclaimer"] as? String
		sort_order = dictionary["sort_order"] as? Int
		inactive_message = dictionary["inactive_message"] as? String
		is_active_TGrande = dictionary["is_active_TGrande"] as? Bool
        if (dictionary["operating_hours_slots"] != nil) { operating_hours_slots = Operating_hours_slots.modelsFromDictionaryArray(array: dictionary["operating_hours_slots"] as! NSArray) }
        if (dictionary["operating_hours"] != nil) { operating_hours = Operating_hours.modelsFromDictionaryArray(array: dictionary["operating_hours"] as! NSArray) }
		is_operating = dictionary["is_operating"] as? Bool
		created = dictionary["created"] as? String
		is_deleted = dictionary["is_deleted"] as? Bool
		is_active = dictionary["is_active"] as? Bool
		if (dictionary["tax"] != nil) { tax = TaxOrder(dictionary: dictionary["tax"] as! NSDictionary) }
		include_tax = dictionary["include_tax"] as? Bool
		order_type = dictionary["order_type"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.module_id, forKey: "module_id")
		dictionary.setValue(self.department_type, forKey: "department_type")
		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.items_attributes?.dictionaryRepresentation(), forKey: "items_attributes")
		dictionary.setValue(self.mobile_number, forKey: "mobile_number")
		dictionary.setValue(self.country_code, forKey: "country_code")
		dictionary.setValue(self.disclaimer, forKey: "disclaimer")
		dictionary.setValue(self.sort_order, forKey: "sort_order")
		dictionary.setValue(self.inactive_message, forKey: "inactive_message")
		dictionary.setValue(self.is_active_TGrande, forKey: "is_active_TGrande")
		dictionary.setValue(self.is_operating, forKey: "is_operating")
		dictionary.setValue(self.created, forKey: "created")
		dictionary.setValue(self.is_deleted, forKey: "is_deleted")
		dictionary.setValue(self.is_active, forKey: "is_active")
		dictionary.setValue(self.tax?.dictionaryRepresentation(), forKey: "tax")
		dictionary.setValue(self.include_tax, forKey: "include_tax")
		dictionary.setValue(self.order_type, forKey: "order_type")

		return dictionary
	}

}

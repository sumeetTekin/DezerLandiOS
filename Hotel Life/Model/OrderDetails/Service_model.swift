/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Service_model {
	public var _id : String?
	public var department_id : String?
	public var module_id : String?
	public var appointment_date : String?
	public var customer_id : String?
	public var booking_number : String?
	public var confirmation_number : String?
	public var __v : Int?
	public var cancel_by_user_type : String?
	public var source : String?
	public var is_drink : Bool?
	public var aloha_item_format : Array<String>?
	public var is_aloha : Bool?
	public var action_performed : Array<String>?
	public var is_sent : Bool?
	public var is_deleted : Bool?
	public var modified : String?
	public var created_date : String?
	public var order_items : Array<Order_itemsOrder>?
	public var appointment_status : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let service_model_list = Service_model.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Service_model Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Service_model]
    {
        var models:[Service_model] = []
        for item in array
        {
            models.append(Service_model(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let service_model = Service_model(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Service_model Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		department_id = dictionary["department_id"] as? String
		module_id = dictionary["module_id"] as? String
		appointment_date = dictionary["appointment_date"] as? String
		customer_id = dictionary["customer_id"] as? String
		booking_number = dictionary["booking_number"] as? String
		confirmation_number = dictionary["confirmation_number"] as? String
		__v = dictionary["__v"] as? Int
		cancel_by_user_type = dictionary["cancel_by_user_type"] as? String
		source = dictionary["source"] as? String
		is_drink = dictionary["is_drink"] as? Bool
        
        if (dictionary["aloha_item_format"] != nil) {
            aloha_item_format = dictionary["aloha_item_format"] as? Array<String>
            
        }
        
		is_aloha = dictionary["is_aloha"] as? Bool
        if (dictionary["action_performed"] != nil) { action_performed = dictionary["action_performed"] as? Array<String> }
		is_sent = dictionary["is_sent"] as? Bool
		is_deleted = dictionary["is_deleted"] as? Bool
		modified = dictionary["modified"] as? String
		created_date = dictionary["created_date"] as? String
        if (dictionary["order_items"] != nil) { order_items =  dictionary["order_items"] as? Array<Order_itemsOrder>}
		appointment_status = dictionary["appointment_status"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.department_id, forKey: "department_id")
		dictionary.setValue(self.module_id, forKey: "module_id")
		dictionary.setValue(self.appointment_date, forKey: "appointment_date")
		dictionary.setValue(self.customer_id, forKey: "customer_id")
		dictionary.setValue(self.booking_number, forKey: "booking_number")
		dictionary.setValue(self.confirmation_number, forKey: "confirmation_number")
		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.cancel_by_user_type, forKey: "cancel_by_user_type")
		dictionary.setValue(self.source, forKey: "source")
		dictionary.setValue(self.is_drink, forKey: "is_drink")
		dictionary.setValue(self.is_aloha, forKey: "is_aloha")
		dictionary.setValue(self.is_sent, forKey: "is_sent")
		dictionary.setValue(self.is_deleted, forKey: "is_deleted")
		dictionary.setValue(self.modified, forKey: "modified")
		dictionary.setValue(self.created_date, forKey: "created_date")
		dictionary.setValue(self.appointment_status, forKey: "appointment_status")

		return dictionary
	}

}

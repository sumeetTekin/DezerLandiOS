/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class OrderListing {
	public var _id : String?
    public var status : String?
	public var customer_id : Customer_id?
	public var gender : String?
	public var is_instructor : Int?
	public var number_of_people : Int?
	public var appointment_date : String?
	public var department_id : Department_id?
	public var module_id : String?
	public var room_number : String?
	public var booking_number : String?
	public var confirmation_number : String?
	public var __v : Int?
	public var source : String?
	public var isActive : Bool?
	public var aloha_item_format : Array<String>?
	public var is_aloha : Bool?
	//public var action_performed : Array<String>?
	public var is_sent : Bool?
	public var is_deleted : Bool?
	public var modified : String?
	public var created_date : String?
	public var order_items : Array<Order_items>?
    public var action_performed : Array<Action_performed>?
	public var appointment_status : String?
    public var rating : Rating?
    public var base_packages : Array<Base_packages>?
    public var totalSelectedPrice : Int?
    public var bookingDate : String?
    public var endDate : String?
    public var createdAt : String?
    public var updatedAt : String?
    public var specialRequest : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    
    required public init() {
        
    }
    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderListing]
    {
        var models:[OrderListing] = []
        for item in array
        {
            models.append(OrderListing(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let data = Data(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Data Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
        specialRequest = dictionary["specialRequest"] as? String
        status = dictionary["status"] as? String
		if (dictionary["customerId"] != nil) { customer_id = Customer_id(dictionary: dictionary["customerId"] as! NSDictionary) }
		gender = dictionary["gender"] as? String
		is_instructor = dictionary["is_instructor"] as? Int
		number_of_people = dictionary["numberOfPeople"] as? Int
		appointment_date = dictionary["appointment_date"] as? String
		if (dictionary["departmentId"] != nil) { department_id = Department_id(dictionary: dictionary["departmentId"] as! NSDictionary) }
		module_id = dictionary["moduleId"] as? String
		room_number = dictionary["room_number"] as? String
		booking_number = dictionary["bookingNumber"] as? String
		confirmation_number = dictionary["confirmation_number"] as? String
		__v = dictionary["__v"] as? Int
		source = dictionary["source"] as? String
		isActive = dictionary["isActive"] as? Bool
        if (dictionary["aloha_item_format"] != nil) {
            aloha_item_format = dictionary["aloha_item_format"] as? Array<String>
            
        }
		is_aloha = dictionary["is_aloha"] as? Bool
//        if (dictionary["action_performed"] != nil) {
//            action_performed = dictionary["action_performed"] as? Array<String>
//
//        }
		is_sent = dictionary["is_sent"] as? Bool
		is_deleted = dictionary["is_deleted"] as? Bool
		modified = dictionary["modified"] as? String
		created_date = dictionary["createdAt"] as? String
        if (dictionary["order_items"] != nil) { order_items = Order_items.modelsFromDictionaryArray(array: dictionary["order_items"] as! NSArray) }
        if (dictionary["action_performed"] != nil) { action_performed = Action_performed.modelsFromDictionaryArray(array: dictionary["action_performed"] as! NSArray) }
		appointment_status = dictionary["appointment_status"] as? String
        if (dictionary["rating"] != nil) { rating = Rating(dictionary: dictionary["rating"] as! NSDictionary) }
        if (dictionary["base_packages"] != nil) { base_packages = Base_packages.modelsFromDictionaryArray(array: dictionary["base_packages"] as! NSArray) }
        totalSelectedPrice = dictionary["totalSelectedPrice"] as? Int
        bookingDate = dictionary["bookingDate"] as? String
        endDate = dictionary["endDate"] as? String
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.specialRequest, forKey: "specialRequest")
        
		dictionary.setValue(self.customer_id?.dictionaryRepresentation(), forKey: "customerId")
		dictionary.setValue(self.gender, forKey: "gender")
		dictionary.setValue(self.is_instructor, forKey: "is_instructor")
		dictionary.setValue(self.number_of_people, forKey: "numberOfPeople")
		dictionary.setValue(self.appointment_date, forKey: "appointment_date")
		dictionary.setValue(self.department_id?.dictionaryRepresentation(), forKey: "departmentId")
		dictionary.setValue(self.module_id, forKey: "moduleId")
		dictionary.setValue(self.room_number, forKey: "room_number")
		dictionary.setValue(self.booking_number, forKey: "bookingNumber")
		dictionary.setValue(self.confirmation_number, forKey: "confirmation_number")
		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.source, forKey: "source")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.is_aloha, forKey: "is_aloha")
		dictionary.setValue(self.is_sent, forKey: "is_sent")
		dictionary.setValue(self.is_deleted, forKey: "is_deleted")
		dictionary.setValue(self.modified, forKey: "modified")
		dictionary.setValue(self.created_date, forKey: "createdAt")
		dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        dictionary.setValue(self.rating, forKey: "rating")
        dictionary.setValue(self.totalSelectedPrice, forKey: "totalSelectedPrice")
        dictionary.setValue(self.bookingDate, forKey: "bookingDate")
        dictionary.setValue(self.endDate, forKey: "endDate")
        dictionary.setValue(self.createdAt, forKey: "createdAt")
        dictionary.setValue(self.updatedAt, forKey: "updatedAt")

        
		return dictionary
	}

}

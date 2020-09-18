/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Order_items {
	public var is_drink : Bool?
	public var item_id : String?
	public var item_name : String?
	public var item_price : Int?
	public var item_quantity : Int?
	public var original_price : Int?
	public var _id : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let order_items_list = Order_items.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Order_items Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Order_items]
    {
        var models:[Order_items] = []
        for item in array
        {
            models.append(Order_items(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let order_items = Order_items(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Order_items Instance.
*/
	required public init?(dictionary: NSDictionary) {

		is_drink = dictionary["is_drink"] as? Bool
		item_id = dictionary["item_id"] as? String
		item_name = dictionary["item_name"] as? String
		item_price = dictionary["item_price"] as? Int
		item_quantity = dictionary["item_quantity"] as? Int
		original_price = dictionary["original_price"] as? Int
		_id = dictionary["_id"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.is_drink, forKey: "is_drink")
		dictionary.setValue(self.item_id, forKey: "item_id")
		dictionary.setValue(self.item_name, forKey: "item_name")
		dictionary.setValue(self.item_price, forKey: "item_price")
		dictionary.setValue(self.item_quantity, forKey: "item_quantity")
		dictionary.setValue(self.original_price, forKey: "original_price")
		dictionary.setValue(self._id, forKey: "_id")

		return dictionary
	}

}
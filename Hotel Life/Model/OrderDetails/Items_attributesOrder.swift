/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Items_attributesOrder {
	public var discount : Int?
	public var is_discount : Bool?
	public var modify_button : Bool?
	public var show_price_suffix : Bool?
	public var category : String?
	public var description : Bool?
	public var price : Bool?
	public var quantity : Bool?
	public var link : Bool?
	public var default_time : String?
	public var instant_order : Bool?
	public var price_suffix : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let items_attributes_list = Items_attributes.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Items_attributes Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Items_attributesOrder]
    {
        var models:[Items_attributesOrder] = []
        for item in array
        {
            models.append(Items_attributesOrder(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let items_attributes = Items_attributes(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Items_attributes Instance.
*/
	required public init?(dictionary: NSDictionary) {

		discount = dictionary["discount"] as? Int
		is_discount = dictionary["is_discount"] as? Bool
		modify_button = dictionary["modify_button"] as? Bool
		show_price_suffix = dictionary["show_price_suffix"] as? Bool
		category = dictionary["category"] as? String
		description = dictionary["description"] as? Bool
		price = dictionary["price"] as? Bool
		quantity = dictionary["quantity"] as? Bool
		link = dictionary["link"] as? Bool
		default_time = dictionary["default_time"] as? String
		instant_order = dictionary["instant_order"] as? Bool
		price_suffix = dictionary["price_suffix"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.discount, forKey: "discount")
		dictionary.setValue(self.is_discount, forKey: "is_discount")
		dictionary.setValue(self.modify_button, forKey: "modify_button")
		dictionary.setValue(self.show_price_suffix, forKey: "show_price_suffix")
		dictionary.setValue(self.category, forKey: "category")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.price, forKey: "price")
		dictionary.setValue(self.quantity, forKey: "quantity")
		dictionary.setValue(self.link, forKey: "link")
		dictionary.setValue(self.default_time, forKey: "default_time")
		dictionary.setValue(self.instant_order, forKey: "instant_order")
		dictionary.setValue(self.price_suffix, forKey: "price_suffix")

		return dictionary
	}

}

/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Base_packages {
    public var _id : String?
	public var name : String?
	public var price : String?
    public var quantity : Int? = 0

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let base_packages_list = Base_packages.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Base_packages Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Base_packages]
    {
        var models:[Base_packages] = []
        for item in array
        {
            models.append(Base_packages(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let base_packages = Base_packages(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Base_packages Instance.
*/
	required public init?(dictionary: NSDictionary) {

        _id = dictionary["_id"] as? String
		name = dictionary["name"] as? String
		price = dictionary["price"] as? String
        //quantity = dictionary["quantity"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

        dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.price, forKey: "price")
        //dictionary.setValue(self.quantity, forKey: "quantity")

		return dictionary
	}

}

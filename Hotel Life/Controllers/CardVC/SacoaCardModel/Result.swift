/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Result {
	public var _id : String?
	public var isDelete : Bool?
	public var isActive : Bool?
	public var userId : String?
	public var type : String?
	public var paymentDetails : PaymentDetails?
	public var transId : String?
	public var amount : Int?
	public var createdAt : String?
	public var updatedAt : String?
	public var __v : Int?
    public var sacoaCardNumber : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let result_list = Result.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Result Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Result]
    {
        var models:[Result] = []
        for item in array
        {
            models.append(Result(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let result = Result(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Result Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		isDelete = dictionary["isDelete"] as? Bool
		isActive = dictionary["isActive"] as? Bool
		userId = dictionary["userId"] as? String
		type = dictionary["type"] as? String
		if (dictionary["paymentDetails"] != nil) { paymentDetails = PaymentDetails(dictionary: dictionary["paymentDetails"] as! NSDictionary) }
		transId = dictionary["transId"] as? String
		amount = dictionary["amount"] as? Int
		createdAt = dictionary["createdAt"] as? String
		updatedAt = dictionary["updatedAt"] as? String
		__v = dictionary["__v"] as? Int
        sacoaCardNumber = dictionary["sacoaCardNumber"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.isDelete, forKey: "isDelete")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.userId, forKey: "userId")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.paymentDetails?.dictionaryRepresentation(), forKey: "paymentDetails")
		dictionary.setValue(self.transId, forKey: "transId")
		dictionary.setValue(self.amount, forKey: "amount")
		dictionary.setValue(self.createdAt, forKey: "createdAt")
		dictionary.setValue(self.updatedAt, forKey: "updatedAt")
		dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.sacoaCardNumber, forKey: "sacoaCardNumber")
        

		return dictionary
	}

}

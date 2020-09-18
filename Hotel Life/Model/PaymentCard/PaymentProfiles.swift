/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class PaymentProfiles {
	public var customerType : String?
	public var billTo : BillTo?
	public var customerPaymentProfileId : String?
    public var defaultPaymentProfile : Bool? = false
	public var payment : Payment?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let paymentProfiles_list = PaymentProfiles.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of PaymentProfiles Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [PaymentProfiles]
    {
        var models:[PaymentProfiles] = []
        for item in array
        {
            models.append(PaymentProfiles(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let paymentProfiles = PaymentProfiles(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: PaymentProfiles Instance.
*/
	required public init?(dictionary: NSDictionary) {

		customerType = dictionary["customerType"] as? String
        defaultPaymentProfile = (dictionary["defaultPaymentProfile"] as? Bool) ?? false
		if (dictionary["billTo"] != nil) { billTo = BillTo(dictionary: dictionary["billTo"] as! NSDictionary) }
		customerPaymentProfileId = dictionary["customerPaymentProfileId"] as? String
		if (dictionary["payment"] != nil) { payment = Payment(dictionary: dictionary["payment"] as! NSDictionary) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.customerType, forKey: "customerType")
		dictionary.setValue(self.billTo?.dictionaryRepresentation(), forKey: "billTo")
		dictionary.setValue(self.customerPaymentProfileId, forKey: "customerPaymentProfileId")
        dictionary.setValue(self.defaultPaymentProfile, forKey: "defaultPaymentProfile")
		dictionary.setValue(self.payment?.dictionaryRepresentation(), forKey: "payment")

		return dictionary
	}

}

/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Cards {
	public var credits : String?
	public var bonus : String?
	public var courtesy : String?
	public var status : String?
	public var tickets : String?
	public var childflag : String?
	public var totalCredPlayed : Int?
	public var lastPlay : String?
	public var lastBuy : String?
	public var cardNumber : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let cards_list = Cards.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Cards Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Cards]
    {
        var models:[Cards] = []
        for item in array
        {
            models.append(Cards(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let cards = Cards(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Cards Instance.
*/
	required public init?(dictionary: NSDictionary) {

		credits = dictionary["credits"] as? String
		bonus = dictionary["bonus"] as? String
		courtesy = dictionary["courtesy"] as? String
		status = dictionary["status"] as? String
		tickets = dictionary["tickets"] as? String
		childflag = dictionary["childflag"] as? String
		totalCredPlayed = dictionary["totalCredPlayed"] as? Int
		lastPlay = dictionary["lastPlay"] as? String
		lastBuy = dictionary["lastBuy"] as? String
		cardNumber = dictionary["cardNumber"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.credits, forKey: "credits")
		dictionary.setValue(self.bonus, forKey: "bonus")
		dictionary.setValue(self.courtesy, forKey: "courtesy")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.tickets, forKey: "tickets")
		dictionary.setValue(self.childflag, forKey: "childflag")
		dictionary.setValue(self.totalCredPlayed, forKey: "totalCredPlayed")
		dictionary.setValue(self.lastPlay, forKey: "lastPlay")
		dictionary.setValue(self.lastBuy, forKey: "lastBuy")
		dictionary.setValue(self.cardNumber, forKey: "cardNumber")

		return dictionary
	}

}
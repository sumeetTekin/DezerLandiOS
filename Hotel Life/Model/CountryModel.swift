//
//  BeachResorts
//
//  Created by Vikas Mehay on 19/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//


import Foundation

public class CountryModel{
	public var _id : String?
	public var name : String?
	public var code : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [CountryModel]
    {
        var models:[CountryModel] = []
        for item in array
        {
            models.append(CountryModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		name = dictionary["name"] as? String
		code = dictionary["code"] as? String
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.code, forKey: "code")

		return dictionary
	}
}

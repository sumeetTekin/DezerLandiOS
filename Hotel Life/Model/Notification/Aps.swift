//
//  Aps.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 10/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation

public class Aps {
	public var alert : String?
	public var badge : Int?
	public var sound : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Aps]
    {
        var models:[Aps] = []
        for item in array
        {
            models.append(Aps(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		alert = dictionary["alert"] as? String
		badge = dictionary["badge"] as? Int
		sound = dictionary["sound"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.alert, forKey: "alert")
		dictionary.setValue(self.badge, forKey: "badge")
		dictionary.setValue(self.sound, forKey: "sound")
		return dictionary
	}

}

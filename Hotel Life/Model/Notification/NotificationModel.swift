//
//  NotificationModel.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 10/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation


public class NotificationModel: NSObject {
	public var aps : Aps?
	public var messageFrom : String?
	public var message : Message?
    public var items_attributes : Items_attributes?

    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationModel]
    {
        var models:[NotificationModel] = []
        for item in array
        {
            models.append(NotificationModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		if let dict = dictionary["aps"] as? NSDictionary {
            aps = Aps(dictionary: dict)
        }
		messageFrom = dictionary["messageFrom"] as? String
        if let dict = dictionary["message"] as? NSDictionary {
           message = Message(dictionary: dict)
            if let attributes = dict["items_attributes"] as? NSDictionary {
                items_attributes = Items_attributes(dictionary: attributes)
            }
        }
        
	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.aps?.dictionaryRepresentation(), forKey: "aps")
		dictionary.setValue(self.messageFrom, forKey: "messageFrom")
		dictionary.setValue(self.message?.dictionaryRepresentation(), forKey: "message")
		return dictionary
	}
    public func dictionaryRepresentationForTrayPickup() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.message?.appointment_id, forKey: "appointment_id")
        return dictionary
    }

}


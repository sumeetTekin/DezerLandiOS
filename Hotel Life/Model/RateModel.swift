//
//  RateModel.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 10/10/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation


public class RateModel:NSObject {
	public var experience : String?
	public var comment : String?
	public var user_id : String?
	public var _id : String?
	public var is_active : String?
	public var is_deleted : String?
	public var created_date : String?

    override init() {
        experience = RATING_EXPERINECE.GOOD
        comment = ""
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [RateModel]
    {
        var models:[RateModel] = []
        for item in array
        {
            models.append(RateModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
		experience = dictionary["experience"] as? String
		comment = dictionary["comment"] as? String
		user_id = dictionary["user_id"] as? String
		_id = dictionary["_id"] as? String
		is_active = dictionary["is_active"] as? String
		is_deleted = dictionary["is_deleted"] as? String
		created_date = dictionary["created_date"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.experience, forKey: "experience")
		dictionary.setValue(self.comment, forKey: "comment")
		return dictionary
	}

}

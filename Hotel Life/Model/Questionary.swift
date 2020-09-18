//
//  Questionary.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation
 


public class Questionary : NSObject {
	public var questionary_id : String?
	public var questionary_text : String?
    
    override public init() {
        
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Questionary]
    {
        var models:[Questionary] = []
        for item in array
        {
            models.append(Questionary(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    public class func modelsFromSignupQuestionArray(array:[SignupQuestion]) -> [Questionary]
    {
        
        var models:[Questionary] = []
        for item in array
        {
            let quest = Questionary()
            quest.questionary_id = item._id
            quest.questionary_text = item.selectedAnswer
            models.append(quest)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		questionary_id = dictionary["questionary_id"] as? String
		questionary_text = dictionary["questionary_text"] as? String
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.questionary_id, forKey: "questionary_id")
		dictionary.setValue(self.questionary_text, forKey: "questionary_text")

		return dictionary
	}

}

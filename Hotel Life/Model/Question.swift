//
//  Question.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/15/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation
import UIKit

public class Question : NSObject {
	public var tag : Int?
	public var option1 : String?
	public var option2 : String?
    public var option1Image : UIImage?
    public var option2Image : UIImage?
	public var selected_option : String?

    override init() {
        
    }
    

    public class func modelsFromDictionaryArray(array:NSArray) -> [Question]
    {
        var models:[Question] = []
        for item in array
        {
            models.append(Question(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		tag = dictionary["tag"] as? Int
		option1 = dictionary["option1"] as? String
		option2 = dictionary["option2"] as? String
		selected_option = dictionary["selected_option"] as? String
	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.tag, forKey: "tag")
		dictionary.setValue(self.option1, forKey: "option1")
		dictionary.setValue(self.option2, forKey: "option2")
		dictionary.setValue(self.selected_option, forKey: "selected_option")

		return dictionary
	}

}

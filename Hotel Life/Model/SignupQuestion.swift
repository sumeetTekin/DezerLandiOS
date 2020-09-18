//
//  BeachResorts
//
//  Created by Vikas Mehay on 19/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation
 
public class SignupQuestion {
	public var _id : String?
	public var l_Text : String?
	public var r_Text : String?
	public var l_Image : String?
	public var r_Image : String?
    public var selectedAnswer : String?

    public class func modelsFromDictionaryArray(array:NSArray, imageBaseUrl : String) -> [SignupQuestion]
    {
        var models:[SignupQuestion] = []
        for item in array
        {
            models.append(SignupQuestion(dictionary: item as! NSDictionary , imageBaseUrl : imageBaseUrl)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary, imageBaseUrl : String) {
        
		_id = dictionary["_id"] as? String
		l_Text = dictionary["l_Text"] as? String
		r_Text = dictionary["r_Text"] as? String
		l_Image = imageBaseUrl.appending((dictionary["l_Image"] as? String)!)
		r_Image = imageBaseUrl.appending((dictionary["r_Image"] as? String)!)
        
	}
    
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.l_Text, forKey: "l_Text")
		dictionary.setValue(self.r_Text, forKey: "r_Text")
		dictionary.setValue(self.l_Image, forKey: "l_Image")
		dictionary.setValue(self.r_Image, forKey: "r_Image")
        dictionary.setValue(self.selectedAnswer, forKey: "selectedAnswer")
		return dictionary
	}

}

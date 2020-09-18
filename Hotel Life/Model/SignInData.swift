

import Foundation
 


public class SignInData {
   
    
	public var token : String?
	public var user : UserModel?

    
    public class func modelsFromDictionaryArray(array:NSArray) -> [SignInData]
    {
        var models:[SignInData] = []
        for item in array
        {
            models.append(SignInData(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		token = dictionary["token"] as? String
        if (dictionary["user"] != nil) { user = UserModel(dictionary: dictionary["user"] as! NSDictionary, imagePath: "") }
	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.token, forKey: "token")
		dictionary.setValue(self.user?.dictionaryRepresentation(), forKey: "user")

		return dictionary
	}
    

}

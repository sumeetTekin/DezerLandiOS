

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class QRCodeBase {
	public var status : Bool?
	public var message : String?
	public var data : QRCodeData?

    public class func modelsFromDictionaryArray(array:NSArray) -> [QRCodeBase]
    {
        var models:[QRCodeBase] = []
        for item in array
        {
            models.append(QRCodeBase(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		status = dictionary["status"] as? Bool
		message = dictionary["message"] as? String
		if (dictionary["data"] != nil) { data = QRCodeData(dictionary: dictionary["data"] as! NSDictionary) }
	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.data?.dictionaryRepresentation(), forKey: "data")

		return dictionary
	}

}

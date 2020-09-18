

import Foundation
 


public class QRCodeData {
	public var _id : String?
	public var videos : Array<String>?
	public var images : Array<String>?
	public var isDelete : Bool?
	public var isActive : Bool?
	public var name : String?
	public var description : String?
	public var additionalDetails : String?
	public var stop : Int?
	public var room : String?
	public var wordCount : Int?
	public var time : Int?
	public var year : String?
	public var make : String?
	public var model : String?
	public var slug : String?
	public var createdAt : String?
	public var updatedAt : String?
	public var __v : Int?


    public class func modelsFromDictionaryArray(array:NSArray) -> [QRCodeData]
    {
        var models:[QRCodeData] = []
        for item in array
        {
            models.append(QRCodeData(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
        if (dictionary["videos"] != nil) { videos = dictionary["videos"] as? Array<String>}
        if (dictionary["images"] != nil) { images = dictionary["images"] as? Array<String> }
		isDelete = dictionary["isDelete"] as? Bool
		isActive = dictionary["isActive"] as? Bool
		name = dictionary["name"] as? String
		description = dictionary["description"] as? String
		additionalDetails = dictionary["additionalDetails"] as? String
		stop = dictionary["stop"] as? Int
		room = dictionary["room"] as? String
		wordCount = dictionary["wordCount"] as? Int
		time = dictionary["time"] as? Int
		year = dictionary["year"] as? String
		make = dictionary["make"] as? String
		model = dictionary["model"] as? String
		slug = dictionary["slug"] as? String
		createdAt = dictionary["createdAt"] as? String
		updatedAt = dictionary["updatedAt"] as? String
		__v = dictionary["__v"] as? Int
	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.isDelete, forKey: "isDelete")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.additionalDetails, forKey: "additionalDetails")
		dictionary.setValue(self.stop, forKey: "stop")
		dictionary.setValue(self.room, forKey: "room")
		dictionary.setValue(self.wordCount, forKey: "wordCount")
		dictionary.setValue(self.time, forKey: "time")
		dictionary.setValue(self.year, forKey: "year")
		dictionary.setValue(self.make, forKey: "make")
		dictionary.setValue(self.model, forKey: "model")
		dictionary.setValue(self.slug, forKey: "slug")
		dictionary.setValue(self.createdAt, forKey: "createdAt")
		dictionary.setValue(self.updatedAt, forKey: "updatedAt")
		dictionary.setValue(self.__v, forKey: "__v")

		return dictionary
	}

}


public class Videos{
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Videos]
    {
        var models:[Videos] = []
        for item in array
        {
            models.append(Videos(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
    }
    
    
    public func dictionaryRepresentation() -> NSDictionary {

       let dictionary = NSMutableDictionary()
        return dictionary
    }
    
}
public class Images{
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Images]
    {
        var models:[Images] = []
        for item in array
        {
            models.append(Images(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
    }
    
    
    public func dictionaryRepresentation() -> NSDictionary {

       let dictionary = NSMutableDictionary()
        return dictionary
    }
    
}

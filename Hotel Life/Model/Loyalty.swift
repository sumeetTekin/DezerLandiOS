import Foundation
 

public class Loyalty {
	public var name : String? = ""
	public var title : String? = ""
	public var heading : String? = ""
	public var description : String? = ""
	public var image : URL?
	public var points : Int? = 0
	public var icon : URL?
	public var is_multiple : String? = ""
	public var is_active : String? = ""
	public var is_deleted : String? = ""
    public var is_enabled : Bool = true
    public var slug : String? = ""
	public var _id : String? = ""
	public var created_date : String? = ""

    public class func modelsFromDictionaryArray(array:NSArray, imagePath: String, disableArray : [String]) -> [Loyalty]
    {
        var models:[Loyalty] = []
        for item in array
        {
            models.append(Loyalty(dictionary: item as! NSDictionary, imagePath: imagePath, disableArray: disableArray)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary, imagePath: String, disableArray : [String]) {

		name = dictionary["name"] as? String
		title = dictionary["title"] as? String
		heading = dictionary["heading"] as? String
		description = dictionary["description"] as? String
        if let img = dictionary["image"] as? String {
            image = URL.init(string:"\(imagePath)\(img)")
        }
//		image = dictionary["image"] as? String
        if let img = dictionary["icon"] as? String {
            icon = URL.init(string:"\(imagePath)\(img)")
        }
//		icon = dictionary["icon"] as? String
        points = dictionary["points"] as? Int
		is_multiple = dictionary["is_multiple"] as? String
		is_active = dictionary["is_active"] as? String
		is_deleted = dictionary["is_deleted"] as? String
		_id = dictionary["_id"] as? String
		created_date = dictionary["created_date"] as? String
        if let slug = dictionary["slug"] as? String {
            self.slug = slug
            is_enabled = disableArray.contains(slug) ? true : false
        }
	}

		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.heading, forKey: "heading")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.points, forKey: "points")
		dictionary.setValue(self.icon, forKey: "icon")
		dictionary.setValue(self.is_multiple, forKey: "is_multiple")
		dictionary.setValue(self.is_active, forKey: "is_active")
		dictionary.setValue(self.is_deleted, forKey: "is_deleted")
		dictionary.setValue(self.created_date, forKey: "created_date")

		return dictionary
	}

}

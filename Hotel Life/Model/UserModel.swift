//
//  UserModel.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation


@objc public class UserModel : NSObject,NSCoding{
    
    public var userId : String? = ""
    
    public var name : String? = ""
    public var firstName : String? = ""
    public var lastName : String? = ""
    public var city : String? = ""
    public var email : String? = ""
    public var country_code : String? = ""
    public var mobile_number : String? = ""
    public var password : String? = ""
    public var confirm_password : String? = ""
    public var questionary : Array<Questionary>? = []
    public var birthday : String? = ""
    public var anniversary : String? = ""
    public var country : String? = ""
    public var checkIn : Bool = false
    public var check_in_sms : Bool = false
    public var booking_number : String?
    public var facebook_id : String? = ""
    public var default_language : String? = "en"
    public var room_number : String?
    public var arrival_date : String?
    public var departure_date : String?
    public var userType : Int?
    public var residentPhoto : String?
    public var userRole : Int?
    public var unitNumber : Int?
    public var units : Int?
    public var adults : Int?
    public var children: Int?
    public var isVerified: Bool?
    public var completePersonalProfile: Bool?
    public var provider : String?
    public var slug : String?
    
    override init(){
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeObject(forKey: "_id")  as? String
        self.name = aDecoder.decodeObject(forKey: "name")  as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName")  as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName")  as? String
        self.email = aDecoder.decodeObject(forKey: "email")  as? String
        self.country_code = aDecoder.decodeObject(forKey: "country_code") as? String
        self.mobile_number = aDecoder.decodeObject(forKey: "mobile_number") as? String
        self.birthday = aDecoder.decodeObject(forKey: "birthday") as? String
        self.anniversary = aDecoder.decodeObject(forKey: "anniversary") as? String
        self.city=aDecoder.decodeObject(forKey: "city") as? String
        self.country = aDecoder.decodeObject(forKey: "country") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.confirm_password = aDecoder.decodeObject(forKey: "confirm_password") as? String
        self.booking_number = aDecoder.decodeObject(forKey: "booking_number") as? String
        self.room_number = aDecoder.decodeObject(forKey: "room_number") as? String
        self.facebook_id = aDecoder.decodeObject(forKey: "facebook") as? String
        self.default_language = aDecoder.decodeObject(forKey: "defaultLanguage") as? String
        self.arrival_date = aDecoder.decodeObject(forKey: "arrival_date") as? String
        self.departure_date = aDecoder.decodeObject(forKey: "departure_date") as? String
        self.userType = aDecoder.decodeObject(forKey: "userType") as? Int
        self.residentPhoto = aDecoder.decodeObject(forKey: "residentPhoto") as? String
        if let userRole = aDecoder.decodeObject(forKey: "userRole") as? Int{
            self.userRole = userRole
        }
        if let unitNumber = aDecoder.decodeObject(forKey: "unitNumber") as? Int{
            self.unitNumber = unitNumber
        }
        if let sms_check = aDecoder.decodeObject(forKey: "check_in_sms") as? Bool {
            self.check_in_sms = sms_check
        }
        if let check_in = aDecoder.decodeObject(forKey: "check_in") as? Bool {
            self.checkIn = check_in
        }
        if let units = aDecoder.decodeObject(forKey: "units") as? Int{
            self.units = units
        }
        if let adults = aDecoder.decodeObject(forKey: "adults") as? Int {
            self.adults = adults
        }
        if let children = aDecoder.decodeObject(forKey: "children") as? Int {
            self.children = children
        }
        self.isVerified = aDecoder.decodeObject(forKey: "isVerified") as? Bool
        self.completePersonalProfile = aDecoder.decodeObject(forKey: "completePersonalProfile") as? Bool
        self.provider = aDecoder.decodeObject(forKey: "provider") as? String
        self.slug = aDecoder.decodeObject(forKey: "slug") as? String

    }
    
    open func encode(with _aCoder: NSCoder) {
        _aCoder.encode(self.userId, forKey: "userId")
        _aCoder.encode(self.name, forKey: "name")
        _aCoder.encode(self.firstName, forKey: "firstName")
        _aCoder.encode(self.lastName, forKey: "lastName")
        _aCoder.encode(self.email, forKey: "email")
        _aCoder.encode(self.country_code, forKey: "country_code")
        _aCoder.encode(self.mobile_number, forKey: "mobile_number")
        _aCoder.encode(self.birthday, forKey: "birthday")
        _aCoder.encode(self.anniversary, forKey: "anniversary")
        _aCoder.encode(self.city, forKey: "city")
        _aCoder.encode(self.country, forKey: "country")
        _aCoder.encode(self.password, forKey: "password")
        _aCoder.encode(self.confirm_password, forKey: "confirm_password")
        _aCoder.encode(self.booking_number, forKey: "booking_number")
        _aCoder.encode(self.facebook_id, forKey: "facebook")
        _aCoder.encode(self.default_language, forKey: "defaultLanguage")
        _aCoder.encode(self.booking_number, forKey: "room_number")
        _aCoder.encode(self.check_in_sms, forKey: "check_in_sms")
        _aCoder.encode(self.checkIn, forKey: "check_in")
        _aCoder.encode(self.arrival_date, forKey: "arrival_date")
        _aCoder.encode(self.departure_date, forKey: "departure_date")
        _aCoder.encode(self.userType, forKey: "userType")
        _aCoder.encode(self.userRole, forKey: "userRole")
        _aCoder.encode(self.residentPhoto, forKey: "residentPhoto")
        _aCoder.encode(self.unitNumber, forKey: "unitNumber")
        _aCoder.encode(self.units, forKey: "units")
        _aCoder.encode(self.adults, forKey: "adults")
        _aCoder.encode(self.children, forKey: "children")
        _aCoder.encode(self.isVerified, forKey: "isVerified")
        _aCoder.encode(self.completePersonalProfile, forKey: "completePersonalProfile")
        _aCoder.encode(self.provider, forKey: "provider")
        _aCoder.encode(self.slug, forKey: "slug")
        
    }

    
    public class func modelsFromDictionaryArray(array:NSArray,  imagePath : String?) -> [UserModel]{
        var models:[UserModel] = []
        for item in array
        {
            models.append(UserModel(dictionary: item as! NSDictionary, imagePath:imagePath)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary, imagePath : String?) {
        super.init()
        userId = dictionary["_id"] as? String
        name = dictionary["name"] as? String
        firstName = dictionary["first_name"] as? String
        lastName = dictionary["last_name"] as? String
        city = dictionary["city"] as? String
        email = dictionary["email"] as? String
        country_code = dictionary["country_code"] as? String
        mobile_number = dictionary["mobile_number"] as? String
        password = dictionary["password"] as? String
        confirm_password = dictionary["confirm_password"] as? String
        userType = dictionary["userType"] as? Int
        userRole = dictionary["userRole"] as? Int
        if let unit = dictionary["unitNumber"] as? String{
            unitNumber = Int(unit)
        }
        if let unit = dictionary["unitNumber"] as? Int{
            unitNumber = unit
        }
        if let text = dictionary["residentPhoto"] as? String, let imagePath = imagePath{
            self.residentPhoto = imagePath+text
        }
        if (dictionary["questionary"] != nil) {
            questionary = Questionary.modelsFromDictionaryArray(array: dictionary["questionary"] as! NSArray)
        }
        birthday = dictionary["birthday"] as? String
        anniversary = dictionary["anniversary"] as? String
        
        country = dictionary["country"] as? String
        if let check = dictionary["check_in"] as? Bool{
            checkIn = check
        }
        if let check = dictionary["check_in_sms"] as? Bool{
            check_in_sms = check
        }
        if let booking_no = dictionary["booking_number"] as? String{
            booking_number = booking_no
        }
        if let room_no = dictionary["room_number"] as? String{
            room_number = room_no
        }
        if let date = dictionary["arrival_date"] as? String{
            arrival_date = date
        }
        if let date = dictionary["departure_date"] as? String{
            departure_date = date
        }
        facebook_id = dictionary["facebook"] as? String
        if let langCode = dictionary["defaultLanguage"] as? String {
            if langCode == "pt"{
                default_language = "pt-BR"
            }
            else{
                default_language = langCode
            }
            
        }
        
        if let units =  dictionary["units"] as? Int{
            self.units = units
        }
        if let adults = dictionary["adults"] as? Int {
            self.adults = adults
        }
        if let children = dictionary["children"] as? Int {
            self.children = children
        }
        
        DispatchQueue.main.async(execute: {
            kAppDelegate.isUserCheckedIn = self.check_in_sms
        })
        
        self.isVerified = dictionary["isVerified"] as? Bool
        self.completePersonalProfile = dictionary["completePersonalProfile"] as? Bool
        self.provider = dictionary["provider"] as? String
        self.slug = dictionary["slug"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()
        //dictionary.setValue(self.userId, forKey: "_id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.firstName, forKey: "first_name")
        dictionary.setValue(self.lastName, forKey: "last_name")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.country_code, forKey: "country_code")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.birthday, forKey: "birthday")
        dictionary.setValue(self.anniversary, forKey: "anniversary")
        dictionary.setValue(self.country, forKey: "country")
        dictionary.setValue(self.userType, forKey: "userType")
        dictionary.setValue(self.isVerified, forKey: "isVerified")
        dictionary.setValue(self.completePersonalProfile, forKey: "completePersonalProfile")
        dictionary.setValue(self.provider, forKey: "provider")
        dictionary.setValue(self.slug, forKey: "slug")
        
        if let role = self.userRole {
            dictionary.setValue(role, forKey: "userRole")
        }
        if let photo = self.residentPhoto {
            dictionary.setValue(photo, forKey: "residentPhoto")
        }
        if let unit = self.unitNumber {
            dictionary.setValue(unit, forKey: "unitNumber")
        }
        if let number = self.room_number {
            dictionary.setValue(number, forKey: "room_number")
        }
        if let number = self.booking_number {
            dictionary.setValue(number, forKey: "booking_number")
        }
        if let langCode = self.default_language {
            if langCode == "pt-BR"{
                dictionary.setValue("pt", forKey: "defaultLanguage")
            }
            else{
                dictionary.setValue(langCode, forKey: "defaultLanguage")
            }
        }
        
        if let units = self.units{
            dictionary.setValue(units, forKey: "units")
        }
        
        if let adults = self.adults{
            dictionary.setValue(adults, forKey: "adults")
        }
        if let children = self.children{
            dictionary.setValue(children, forKey: "children")
        }
        
        
        var questArr:[NSDictionary] = []
        for obj in questionary!{
            questArr.append(obj.dictionaryRepresentation())
        }
        dictionary.setValue(questArr, forKey: "questionary")
        
        //refine later
        if self.facebook_id != "" && self.facebook_id != nil{
            dictionary.setValue(self.facebook_id, forKey: "facebook")
        }
        else{
            dictionary.setValue(self.password, forKey: "password")
            dictionary.setValue(self.confirm_password, forKey: "confirm_password")
        }
        
		return dictionary
	}
    
    public func editUserDictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        //dictionary.setValue(self.userId, forKey: "_id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.firstName, forKey: "first_name")
        dictionary.setValue(self.lastName, forKey: "last_name")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.country_code, forKey: "country_code")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        //dictionary.setValue(self.password, forKey: "password")
        dictionary.setValue(self.birthday, forKey: "birthday")
        dictionary.setValue(self.anniversary, forKey: "anniversary")
        dictionary.setValue(self.country, forKey: "country")
        dictionary.setValue(self.isVerified, forKey: "isVerified")
        dictionary.setValue(self.completePersonalProfile, forKey: "completePersonalProfile")
        dictionary.setValue(self.provider, forKey: "provider")
        dictionary.setValue(self.slug, forKey: "slug")
        
        if let langCode = self.default_language {
            if langCode == "pt-BR"{
                dictionary.setValue("pt", forKey: "defaultLanguage")
            }
            else{
                dictionary.setValue(langCode, forKey: "defaultLanguage")
            }
        }
        if let number = self.room_number {
            dictionary.setValue(number, forKey: "room_number")
        }
        if let number = self.booking_number {
            dictionary.setValue(number, forKey: "booking_number")
        }
        if let userType = self.userType{
            dictionary.setValue(userType, forKey: "userType")
            if userType == 1{
                var questArr:[NSDictionary] = []
                for obj in questionary!{
                    questArr.append(obj.dictionaryRepresentation())
                }
                dictionary.setValue(questArr, forKey: "questionary")

            }
        }
        return dictionary
    }
    public func getSoapParamName() -> String? {
        var paramName : String? = ""
        let nameArray = self.name?.components(separatedBy: " ")
        if let lastname = nameArray?.last {
            paramName = paramName?.appending(lastname)
            paramName = paramName?.appending(", ")
            
        }
        if let firstname = nameArray?.first {
            paramName = paramName?.appending(firstname)
        }
        return paramName
    }

}

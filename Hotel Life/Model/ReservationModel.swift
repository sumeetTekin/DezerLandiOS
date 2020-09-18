//
//  DateModel.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 29/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation
 

public class ReservationModel {
    public var _id : String? = ""
    public var module_id : String? = ""
    public var instant_order : Bool = false
    public var module_name : String?
    public var department_id : String? = ""
    public var department_type : String? = ""
    // Sub Menu
    var subMenuDataType : SubMenuDataType = .reservation
    public var number_of_people : Int? = 0
    public var appointment_date : String? = ""
    public var appointment_time : String? = ""
    public var order_date : Date?
    public var confirmation_number : String? = ""
    public var customer_id : String? = ""
    public var appointment_status : String? = ""
    public var order_items : [NSDictionary]? = []
    public var items : [Menu]? = []
    public var alohaItems : [AlohaMenu]? = []
    public var tax : Tax?
    public var promocode : Promocode?
    public var taxPromoTotal : TaxPromoTotal?
    public var chair_number : String?
    public var room_number : String?
    public var beach_location : String?
    public var isModification : Bool = false
    public var alertTitle : String? = ""
    public var alertMessage : String? = ""
    public var occasion : String?
    public var specialRequest : String?
    public var country_code : String?
    public var mobile_number : String?
    public var gender : String?
    public var couple_name : String?
    public var discount : Float?
    public var duration : String?
    public var instructor : Bool?
    public var is_drink : Bool?
    public var paymentType : Int?
    public var totalSelectedPrice : Double?
    public var totalSelectedPriceWithUserCount : Double?
    
    public var selectedPackages : [Base_packages]?
 
    required public init() {
        
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ReservationModel]
    {
        var models:[ReservationModel] = []
        for item in array
        {
            models.append(ReservationModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        _id = dictionary["_id"] as? String
        module_id = dictionary["moduleId"] as? String
        module_name = dictionary["module_name"] as? String
        department_id = dictionary["departmentId"] as? String
        department_type = dictionary["department_type"] as? String
        number_of_people = dictionary["numberOfPeople"] as? Int
        appointment_date = dictionary["bookingDate"] as? String
        confirmation_number = dictionary["confirmation_number"] as? String
        
        totalSelectedPriceWithUserCount = dictionary["totalSelectedPriceWithUserCount"] as? Double
        totalSelectedPrice = dictionary["totalSelectedPrice"] as? Double
        selectedPackages = dictionary["base_packages"] as? [Base_packages]
        
        print(appointment_date ?? "Date Not found")
        
        var date = Helper.getOptionalDateFromString(string: appointment_date!, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
       
        if date == nil{
            date = Helper.getDateFromString(string: appointment_date!, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_A)
            appointment_date = Helper.getStringFromDate(format: DATEFORMATTER.MMDDYYYY, date: date!)
            appointment_time = Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: date!)
        }
        else{
            appointment_date = Helper.getStringFromUTCDate(format: DATEFORMATTER.MMDDYYYY, date: date!)
            appointment_time = Helper.getStringFromUTCDate(format: DATEFORMATTER.HH_MM_A, date: date!)
        }
        
        if let date = Helper.getOptionalDateFromString(string: (dictionary["createdAt"] as? String)!, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ) {
            self.order_date = date
        }
        occasion = dictionary["occasion"] as? String
        specialRequest = dictionary["specialRequest"] as? String
        customer_id = dictionary["customer_id"] as? String
        appointment_status = dictionary["appointment_status"] as? String
        chair_number = dictionary["chair_number"] as? String
        room_number = dictionary["room_number"] as? String
        beach_location = dictionary["beach_location"] as? String
        if let gender = dictionary["gender"] as? String, gender != "" {
            self.gender = gender
        }
        couple_name = dictionary["couple_name"] as? String
        if let array = dictionary["order_items"] as? NSArray {
            items = Menu.modelsFromDictionaryArray(array: array, imagePath: "", is_drink: false)
        }
        
        if let type = dictionary["department_type"] as? String {
            switch type {
            case "service_selection"://It will have checkboxes
                subMenuDataType = .service_selection
            case "quantity_selection"://It have items and count per items
                subMenuDataType = .quantity_selection
            case "restaurant"://Display restaurant menus only
                subMenuDataType = .restaurant
            case "reservation": //date +time + number of ppl  reservation
                subMenuDataType = .reservation
            case "service_request": //Type, Custom message,Custom  service_type
                subMenuDataType = .service_request
            case "sharing": //for sharing
                subMenuDataType = .sharing
            case "link": //links
                subMenuDataType = .link
            case "attraction": //attractions type
                subMenuDataType = .attraction
            case "tabs": //tabs + quantity type
                subMenuDataType = .tabs_quantity_selection
            case "sub_menus": //submenu type
                subMenuDataType = .submenu_selection
            case "maintenance_request": //submenu type
                subMenuDataType = .maintenance_request
            case "kid_zone": //planet kids
                subMenuDataType = .kid_zone
            default:
                subMenuDataType = .quantity_selection
            }
            
        }else{
            subMenuDataType = .def
        }
        
        if let taxes = dictionary["tax"] as? NSDictionary{
            tax = Tax(dictionary: taxes)
        }
        if let code = dictionary["promocode"] as? NSDictionary{
            promocode = Promocode(dictionary: code)
        }
        if let dis = dictionary["discount"] as? String, dis != ""{
            discount = Float(dis)
        }
        if let dis = dictionary["discount"] as? Float{
            discount = dis
        }
        if let duration = dictionary["duration"] as? String, duration != ""{
            self.duration = duration
        }
        if let instructor = dictionary["is_instructor"] as? Int{
            self.instructor = instructor == 0 ? false : true
        }
//        if let dict = dictionary["departmentId"] as? NSDictionary{
//            if let country_code = dict["country_code"] as? String {
//                self.country_code = country_code
//            }
//            if let mobile_number = dict["mobile_number"] as? String {
//                self.mobile_number = mobile_number
//            }
//        }

    }
        
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.module_id, forKey: "moduleId")
        dictionary.setValue(self.department_id, forKey: "departmentId")
        if self.department_type != nil && self.department_type != "" {
            dictionary.setValue(self.department_type, forKey: "department_type")
        }
        if self.number_of_people != nil && self.number_of_people != 0 {
            dictionary.setValue(self.number_of_people, forKey: "numberOfPeople")
        }
        dictionary.setValue(self.appointment_date, forKey: "bookingDate")
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()), forKey: "order_date")
        if self.customer_id != nil && self.customer_id != "" {
            dictionary.setValue(self.customer_id, forKey: "customer_id")
        }
        if self.appointment_status != nil && self.appointment_status != "" {
            dictionary.setValue(self.appointment_status, forKey: "appointment_status")
        }
        if self.chair_number != nil && self.chair_number != "" {
            dictionary.setValue(self.chair_number, forKey: "chair_number")
        }
        if self.room_number != nil && self.room_number != "" {
            if let number = self.room_number {
                dictionary.setValue("\(number)", forKey: "room_number")
            }
        }
        
        if self.beach_location != nil && self.beach_location != ""{
            dictionary.setValue(self.beach_location, forKey: "beach_location")
        }
        let orderArray = self.getDictionaryRepresentationForOrderItems()
        if orderArray.count > 0 {
            dictionary.setValue(orderArray, forKey: "order_items")
        }
        if let promocode = self.promocode {
            dictionary.setValue(promocode.dictionaryRepresentation(), forKey: "promocode")
        }
        if let gender = self.gender, gender != "" {
            dictionary.setValue(gender, forKey: "gender")
        }
        if let special_request = self.specialRequest {
            dictionary.setValue(special_request, forKey: "specialRequest")
        }
        if let occasion = self.occasion {
            dictionary.setValue(occasion, forKey: "occasion")
        }
        if let couple_name = self.couple_name {
            dictionary.setValue(couple_name, forKey: "couple_name")
        }
        if let disc = self.discount {
            dictionary.setValue(disc, forKey: "discount")
        }
        if let duration = self.duration, duration != "" {
            dictionary.setValue(duration, forKey: "duration")
        }
        if let is_instructor = self.instructor {
            dictionary.setValue(is_instructor == true ? 1 : 0, forKey: "is_instructor")
        }
        
        if self.totalSelectedPriceWithUserCount != nil && self.totalSelectedPriceWithUserCount != 0.0 {
            dictionary.setValue(self.totalSelectedPriceWithUserCount, forKey: "totalSelectedPriceWithUserCount")
        }
        
        if self.totalSelectedPrice != nil && self.totalSelectedPrice != 0.0 {
            dictionary.setValue(self.totalSelectedPrice, forKey: "totalSelectedPrice")
        }
        
        return dictionary
        
    }
    
    public func dictionaryRepresentationForOrderReservation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.module_id, forKey: "moduleId")
        dictionary.setValue(self.department_id, forKey: "departmentId")
        if let people = self.number_of_people {
            if people > 0{
                dictionary.setValue(self.number_of_people, forKey: "numberOfPeople")
            }
        }
        
        dictionary.setValue(self.appointment_date, forKey: "bookingDate")
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()), forKey: "order_date")
        
        if self.chair_number != nil && self.chair_number != "" {
            dictionary.setValue(self.chair_number, forKey: "chair_number")
        }
        if self.room_number != nil && self.room_number != "" {
            if let number = self.room_number {
                dictionary.setValue("\(number)", forKey: "room_number")
            }
        }
        
        if self.beach_location != nil && self.beach_location != "" {
            dictionary.setValue(self.beach_location, forKey: "beach_location")
        }
        
        if self.getDictionaryRepresentationForOrderItems().count > 0 {
            dictionary.setValue(self.getDictionaryRepresentationForOrderItems(), forKey: "order_items")
        }
        
        if let tax = self.tax {
            dictionary.setValue(tax.dictionaryRepresentation(), forKey: "tax")
        }
        if let promocode = self.promocode {
            dictionary.setValue(promocode.dictionaryRepresentation(), forKey: "promocode")
        }
        if let gender = self.gender {
            dictionary.setValue(gender, forKey: "gender")
        }
        if let couple_name = self.couple_name {
            dictionary.setValue(couple_name, forKey: "couple_name")
        }
        if let disc = self.discount {
            dictionary.setValue(disc, forKey: "discount")
        }
        if let duration = self.duration, duration != "" {
            dictionary.setValue(duration, forKey: "duration")
        }
        if let is_instructor = self.instructor {
            dictionary.setValue(is_instructor == true ? 1 : 0, forKey: "is_instructor")
        }
        
        if self.totalSelectedPriceWithUserCount != nil && self.totalSelectedPriceWithUserCount != 0.0 {
            dictionary.setValue(self.totalSelectedPriceWithUserCount, forKey: "selectedPrice")
        }
        
        if self.totalSelectedPrice != nil && self.totalSelectedPrice != 0.0 {
            dictionary.setValue(self.totalSelectedPrice, forKey: "totalSelectedPrice")
        }
        
        
        return dictionary
        
    }
    public func dictionaryRepresentationForServiceReservation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.module_id, forKey: "moduleId")
        dictionary.setValue(self.department_id, forKey: "departmentId")
        if let people = self.number_of_people {
            if people > 0{
                dictionary.setValue(self.number_of_people, forKey: "numberOfPeople")
            }
        }
    
        dictionary.setValue((self.appointment_date ?? "") + " " + (self.appointment_time ?? ""), forKey: "bookingDate")
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()), forKey: "order_date")
        if self.chair_number != nil && self.chair_number != "" {
            dictionary.setValue(self.chair_number, forKey: "chair_number")
        }
        if self.room_number != nil && self.room_number != "" {
            if let number = self.room_number {
                dictionary.setValue("\(number)", forKey: "room_number")
            }
        }
        if self.beach_location != nil && self.beach_location != ""{
            dictionary.setValue(self.beach_location, forKey: "beach_location")
        }
        if let promocode = self.promocode {
            dictionary.setValue(promocode.dictionaryRepresentation(), forKey: "promocode")
        }
        
        if let occasion = self.occasion {
            dictionary.setValue(occasion, forKey: "occasion")
        }
        if let special_request = self.specialRequest {
            dictionary.setValue(special_request, forKey: "special_request")
        }
        if let gender = self.gender {
            dictionary.setValue(gender, forKey: "gender")
        }
        if let couple_name = self.couple_name {
            dictionary.setValue(couple_name, forKey: "couple_name")
        }
        if let disc = self.discount {
            dictionary.setValue(disc, forKey: "discount")
        }
        if let duration = self.duration, duration != "" {
            dictionary.setValue(duration, forKey: "duration")
        }
        if let is_instructor = self.instructor {
            dictionary.setValue(is_instructor == true ? 1 : 0, forKey: "is_instructor")
        }
        
        if self.totalSelectedPriceWithUserCount != nil && self.totalSelectedPriceWithUserCount != 0.0 {
            dictionary.setValue(self.totalSelectedPriceWithUserCount, forKey: "selectedPrice")
        }
        
        if self.totalSelectedPrice != nil && self.totalSelectedPrice != 0.0 {
            dictionary.setValue(self.totalSelectedPrice, forKey: "totalSelectedPrice")
        }
        
        if self.selectedPackages != nil {
            var array = [[String: Any]]()
            for value in self.selectedPackages! {
                var dictionary = [String: Any]()
                dictionary["name"] = value.name
                dictionary["price"] = value.price
                array.append(dictionary)
            }
            
            dictionary.setValue(array, forKey: "base_packages")
        }
        
        return dictionary
        
    }
    
    public func getDictionaryRepresentationForOrderItems() -> [[String : Any]] {
        var arr : [[String : Any]] = []
        if items != nil {
            for item in items! {
                var dictionary : [String : Any] = [:]
                if let id = item.department_Id {
                    dictionary["item_id"] = id
                }
                
                if let label = item.label {
                    dictionary["item_name"] = label
                }
                
                if let price = item.item_price {
                    if price != "" && price != "0.00" {
                    dictionary["item_price"] = price
                    }
                }
                if let price = item.before_discount_price {
                    if price != "" && price != "0.00" {
                        dictionary["original_price"] = price
                    }
                }
                
                if let id = item.category_id {
                    if id != "" {
                        dictionary["item_type"] = id
                    }
                }
    
                if item.quantity != 0 {
                    dictionary["item_quantity"] = item.quantity
                }
                
                if item.label == "" && item.item_price == "" {
                   continue
                }
                
                arr.append(dictionary)
            }
        }
        return arr
    }
    public func dictionaryRepresentationForLocalAttraction() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        if let department_id = items?.first?.department_Id {
            dictionary.setValue(department_id, forKey: "departmentId")
        }
        if let department_id = items?.first?.module_id {
            dictionary.setValue(department_id, forKey: "moduleId")
        }
        if let item_id = items?.first?.item_id {
            dictionary.setValue(item_id, forKey: "item_id")
        }
        if self.room_number != nil && self.room_number != "" {
            if let number = self.room_number {
                dictionary.setValue("\(number)", forKey: "room_number")
            }
        }
        let orderArray = self.getDictionaryRepresentationForOrderItems()
        if orderArray.count > 0 {
            dictionary.setValue(orderArray, forKey: "order_items")
        }
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()), forKey: "bookingDate")
        
        print(dictionary)
        return dictionary
    }

}

//
//  Menu.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/15/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation
import UIKit


public class Menu : NSObject, NSCopying {
    
    // Menu
    public var order_Id : String?
    public var department_Id : String? = ""
    public var item_id : String? = ""
    public var label : String?
    public var labelName : String? = ""
    
    public var labelDescription : String?
    public var imageURL : URL?
    public var isEnabled : Bool = true
    public var inactive_message : String? = ""
    
    var submoduleType : SubModuleType = .subCell
    var mobile_number : String?
    var posItemId : String?
    
    // Sub Menu
    var subMenuDataType : SubMenuDataType = .attraction
    public var module_id : String? = ""
//    public var subTitle : String? = ""
    public var duration : String? = ""
    public var cellImage : UIImage? = UIImage()
    public var quantity : Int? = 0
    public var isChecked : Bool? = false
    public var daysArray : [String] = []
    var itemType : ItemType = .def
    var orderType : OrderType = .indirect
    public var link : String?
    public var room_number : String?
    public var linkDescription : String?
    public var disclaimer : String?
    
    // item
    public var item_price : String? = ""
    public var before_discount_price : String? = ""
    public var item_name : String? = ""
    public var category_id : String? = ""
    public var menu_item_suffix : String? = ""
    public var available_quantity : Int? = 100
    public var max_quantity : Int? = 100
    public var isAirport : Bool = false
    public var items_attributes : Items_attributes?
    public var tax : Tax?
    public var serviceSelectedItemsArray : [Amenities]?
    public var removeInNextOrder = false
    public var modifierGroup : [ModifierGroup]? = []
    public var selectedModifierArray : [Modifier] = []
    public var is_discount : Bool = false
    public var discount : Float = 0
    public var defaultModifiers : [DefaultOption] = []
    
    // time related
    public var is_operating : Bool?
    public var operatingHours : [OperatingHours]? = []
    public var operatingHoursSlots : [OperatingHoursSlot]? = []
    public var is_couple : Bool = false
    public var is_drink : Bool = false
    public var couple_name : String?
    
    public var base_packages : [Base_packages]? = []
    
    
    
    override init() {
        
    }
   
    public class func modelsFromDictionaryArray(array:NSArray, imagePath : String, is_drink : Bool) -> [Menu]
    {
        var models:[Menu] = []
        for item in array
        {
            models.append(Menu(dictionary: item as! NSDictionary, imagePath : imagePath, is_drink : is_drink)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary , imagePath : String, is_drink : Bool) {
        // For Menu
        super.init()
        
        self.is_drink = is_drink
        if let _id = dictionary["_id"] as? String {
            department_Id = _id
        }
        if let _id = dictionary["_id"] as? String {
            item_id = _id
        }
        if let name = dictionary["name"] as? String {
           label = name
        }
        if let name = dictionary["name"] as? [String: Any] {
            labelName = name["en"] as! String
        }
        
        if let desc = dictionary["description"] as? String {
            labelDescription = desc
        }
        if let dur = dictionary["time"] as? String {
            duration = dur
        }
        if let img = dictionary["image"] as? String {
            imageURL = URL.init(string:"\(imagePath)\(img)")
        }
        if let enabled = dictionary["isActive"] as? Bool {
             isEnabled = enabled
        }
        if let itemsAttributes = dictionary["items_attributes"] as? NSDictionary {
            items_attributes = Items_attributes(dictionary: itemsAttributes)
            if let disc = itemsAttributes["discount"] as? Float {
                discount = disc
            }
            if let isDisc = itemsAttributes["is_discount"] as? Bool {
                is_discount = isDisc
            }
        }
        if let taxes = dictionary["tax"] as? NSDictionary{
            if taxes.allKeys.count > 0 {
                tax = Tax(dictionary: taxes)
            }  
        }
        if let type = dictionary["viewType"] as? String {
            submoduleType = self.getSubmoduleType(type : type)
        }
//        ["service_selection","quantity_selection","tabs","sub_menus","restaurant","reservation","service_request","sharing","link","attraction","maintenance_request"],
        // For Sub Menu
        if let type = dictionary["department_type"] as? String {
            subMenuDataType = self.getSubmenuDataType(type : type)
        }
        if let disclaimer = dictionary["disclaimer"] as? String, disclaimer != "" {
            // sometimes item name is  "" so fetching this
            self.disclaimer = "\(disclaimer)"
        }
        if let sub = dictionary["name"] as? String {
            // sometimes item name is  "" so fetching this
            item_name = "\(sub)"
        }
        if let sub = dictionary["item_name"] as? String {
            item_name = "\(sub)"
        }
        
        if let dept = dictionary["department"] as? NSDictionary {
            if let itemsAttributes = dept["items_attributes"] as? NSDictionary {
                if let disc = itemsAttributes["discount"] as? Float {
                    discount = disc
                }
                if let isDisc = itemsAttributes["is_discount"] as? Bool {
                    is_discount = isDisc
                }
            }
        }
        // check if there is any discount available
//        if let sub = dictionary["price"] as? NSNumber {
//            subTitle = "$\(String.init(format: "%.2f", Float(sub)))"
//        }
        if let sub = dictionary["price"] as? NSNumber {
            before_discount_price = "\(String.init(format: "%.2f", Float(sub)))"
            if is_discount {
                if let pr = before_discount_price {
                    item_price = "\(String.init(format: "%.2f", Float(self.getDiscountedItemPrice(actualPrice: pr,   discount: discount))))"
                }
                else {
                    item_price = before_discount_price
                }
            }
            else {
                item_price = before_discount_price
            }
        }
        if let sub = dictionary["item_price"] as? NSNumber {
            before_discount_price = "\(String.init(format: "%.2f", Float(sub)))"
            if is_discount {
                if let pr = before_discount_price {
                    item_price = "\(String.init(format: "%.2f", Float(self.getDiscountedItemPrice(actualPrice: pr,   discount: discount))))"
                }
                else {
                    item_price = before_discount_price
                }
            }
            else {
                item_price = before_discount_price
            }
        }
        if let price = dictionary["original_price"] as? NSNumber {
            before_discount_price = "\(String.init(format: "%.2f", Float(price)))"
        }
        if let item_quantity = dictionary["item_quantity"] as? Int {
            self.quantity = item_quantity
        }
        
        if let modId = dictionary["moduleId"] as? String {
            module_id = modId
        }

        if let type = dictionary["item_type"] as? String {
            itemType = self.getItemType(type : type)
        }
        
        if let type = dictionary["weekdays"] as? String {
            daysArray = type.components(separatedBy: ",")
            itemType = .def
        }
        if let type = items_attributes?.instant_order {
            self.orderType = self.getOrderType(type : type)
        }
        
        if let link = dictionary["link"] as? String{
            self.link = link
            subMenuDataType = .link
        }
        if let desc = dictionary["description"] as? String {
            linkDescription = desc
        }
        if let quantity = dictionary["available_quantity"] as? Int {
            available_quantity = quantity
        }
        if let max_Quan = dictionary["max_quantity"] as? Int {
            max_quantity = max_Quan
        }
        if let airport = dictionary["directions_to_hotel"] as? Bool {
            isAirport = !airport
        }
        if let id = dictionary["category_id"] as? String {
            category_id = id
        }
        if let id = dictionary["mobile_number"] as? String {
            mobile_number = id
        }
        if let is_operating = dictionary["is_operating"] as? Bool {
            self.is_operating = is_operating
//            if let operating_hours = dictionary["operating_hours"] as? NSArray {
//                self.operatingHours = OperatingHours.modelsFromDictionaryArray(array: operating_hours)
//            }
            if let operating_hours = dictionary["operating_hours_slots"] as? NSArray {
                self.operatingHoursSlots = OperatingHoursSlot.modelsFromDictionaryArray(array: operating_hours)
            }
        }
        
        if let base_packages = dictionary["base_packages"] as? NSArray{
            self.base_packages = Base_packages.modelsFromDictionaryArray(array: base_packages)
        }
        if let is_couple = dictionary["is_couple"] as? Bool {
            self.is_couple = is_couple
        }
        if let suffix = dictionary["price_suffix"] as? String {
            menu_item_suffix = suffix
        }
        if let str = dictionary["inactive_message"] as? String {
            inactive_message = str
        }
        
        if let groups = dictionary["modifierGroup"] as? [NSDictionary], groups.count > 0 {
            modifierGroup = ModifierGroup.modelsFromDictionaryArray(array: groups, imagePath: "", sortArray: dictionary["modifierGroupItems"] as? [Int])
        }
        if let _id = dictionary["POSItemId"] as? Int {
            posItemId = "\(_id)"
        }
        if let defaultOption = dictionary["DefaultOptions"] as? [NSDictionary], defaultOption.count > 0 {
            print(dictionary)
//            for modifier in defaultOption {
            self.defaultModifiers = DefaultOption.modelsFromDictionaryArray(array: defaultOption as NSArray)
//                if let reason = modifier["DefaultReason"] as? Int, (reason == 1 || reason == 2){
//                    if let id = modifier["ModifierId"] as? Int {
//                        if !self.defaultModifiers.contains(id) {
//                           self.defaultModifiers.append(id)
//                        }
//                    }
//                }
//            }
        }
    }
    func getOrderType(type : Bool) -> OrderType {
        
        switch type {
        case true :
            return .direct
        case false :
            return .indirect
        }
    }
    func getItemType(type : String) -> ItemType{
        switch type {
        case "local_attraction":
            return .local_attraction
        case "contact_me":
            return .contact
        case "website":
            return .website
        default:
            return .def
        }
    }
    func getSubmoduleType(type : String) -> SubModuleType {
        switch type {
        case "subCell": //cell with another subcell
            return .subCell
        case "textDirection"://cell with textfield and directions
            return .textDirection
        case "directions"://cell with directions only
            return .directions
        case "checkout"://cell for checkout/checkin view
            return .checkout
        case "socialMediaShare":
            return .socialMediaShare
        case "subMenu":
            return .subMenu
        case "booking":
            return .booking
        case "sacoaCard":
            return .sacoaCard
            
            
        default:
            return .subCell
        }
    }
    func getSubmenuDataType(type : String) -> SubMenuDataType {
        switch type {
        case "service_selection"://It will have checkboxes
            return .service_selection
        case "quantity_selection"://It have items and count per items
            return .quantity_selection
        case "restaurant"://Display restaurant menus only
            return .restaurant
        case "reservation": //date +time + number of ppl  reservation
            return .reservation
        case "service_request": //Type, Custom message,Custom  service_type
            return .service_request
        case "sharing": //for sharing
            return .sharing
        case "link": //links
            return .link
        case "attraction": //attractions type : Default for tennis
            return .attraction
        case "tabs": //tabs + quantity type
            return .tabs_quantity_selection
        case "sub_menus": //submenu type
            return .submenu_selection
        case "maintenance_request": //submenu type
            return .maintenance_request
        case "kid_zone": //planet kids
            return .kid_zone
        case "instant_order": //for in room dining
            return .instant_order
        case "booking":
            return .reservation
        default:
            return .quantity_selection
        }
    }
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.label, forKey: "label")
        dictionary.setValue(self.imageURL, forKey: "image")
        dictionary.setValue(self.isEnabled, forKey: "isEnabled")
//        dictionary.setValue(self.subTitle, forKey: "subTitle")
        dictionary.setValue(self.duration, forKey: "duration")
        return dictionary
    }
    public func dictionaryRepresentationForLocalAttraction() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        if let department_id = self.department_Id {
            dictionary.setValue(department_id, forKey: "departmentId")
        }
        if let department_id = self.module_id {
            dictionary.setValue(department_id, forKey: "moduleId")
        }
        
        dictionary.setValue(getDictionaryRepresentationForOrderItems(), forKey: "order_items")
        if let item_id = self.item_id {
            dictionary.setValue(item_id, forKey: "item_id")
        }
        if let label = self.item_name {
            dictionary.setValue(label, forKey: "item_name")
        }
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()), forKey: "appointment_date")
        if self.room_number != nil && self.room_number != "" {
            if let number = self.room_number {
                dictionary.setValue("\(number)", forKey: "room_number")
            }
        }
        
        print(dictionary)
        return dictionary
    }
    public func getDictionaryRepresentationForOrderItems() -> [[String : Any]] {
        var arr : [[String : Any]] = []
                var dictionary : [String : Any] = [:]
                if let id = self.item_id {
                    dictionary["item_id"] = id
                }
                
                if let label = self.item_name {
                    dictionary["item_name"] = label
                }
                arr.append(dictionary)
        return arr
    }
    public func dictionaryRepresentationForServiceRequest() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.module_id, forKey: "module_id")
        dictionary.setValue(self.department_Id, forKey: "department_id")
        
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: Date()), forKey: "appointment_time")
//        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD, date: Date()), forKey: "appointment_date")
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()), forKey: "appointment_date")
        
        if let quantity = self.quantity{
            if quantity > 0 {
                dictionary.setValue(self.quantity, forKey: "quantity")
            }
        }
        if let items = serviceSelectedItemsArray {
            if items.count > 0 {
                dictionary.setValue(self.getSelectedItemsArray(items: items), forKey: "order_items")
            }
        }
        if let room_number = self.room_number {
            dictionary.setValue(room_number, forKey: "room_number")
        }
        return dictionary
    }
    func getSelectedItemsArray(items :[Amenities]) -> [[String : Any]]{
        var arr : [[String : Any]] = []
            for item in items {
                var dictionary : [String : Any] = [:]
                    dictionary["item_name"] = item.name
                    dictionary["item_quantity"] = item.quantity
                    arr.append(dictionary)
            }
        return arr
    }
    
    
}

extension Menu {
    func getTotalPrice() -> Float {
        var totalPrice : Float = 0
        totalPrice = self.getItemPrice() * self.getTotalQuantity()
        return totalPrice
    }
    func getItemPrice() -> Float{
        var itemPrice : Float = 0
        if let price = self.item_price {
            if let pr = Float(price) {
                itemPrice = pr
            }
        }
        return itemPrice
    }
    func getDiscountedItemPrice(actualPrice : String, discount : Float) -> Float{
        var pr : Float = 0
        if let price = Float(actualPrice) {
            pr = price - (price * discount / 100)
        }
        return pr
    }
    func getTotalQuantity() -> Float {
        var totalQuantity : Float = 1
        if let quantity = self.quantity {
            totalQuantity = Float(quantity)
            if totalQuantity == 0 {
                totalQuantity = 1
            }
        }
        return totalQuantity
    }

    class func dictionaryRepresentationForTaxCalculation(menus : [Menu], orderMode : Int) -> NSMutableDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(getCustomerNameDict(), forKey: "customer")
        dictionary.setValue(getItemsDict(menus : menus), forKey: "items")
        dictionary.setValue(orderMode, forKey: "orderMode")
        dictionary.setValue(4, forKey: "orderSource")
        dictionary.setValue(0, forKey: "status")
//        if let people = self.number_of_people {
//            if people > 0{
//                dictionary.setValue(self.number_of_people, forKey: "number_of_people")
//            }
//        }
        return dictionary
//            {

//                "orderMode": 9,
//                "orderSource": 4,
//                "status": 0,

//        }
        
    }
    class func getCustomerNameDict() -> NSMutableDictionary {
        //                "customer": {
        //                    "FirstName": "Brian",
        //                    "LastName": "Campbell"
        //                }
        let dictionary = NSMutableDictionary()
    
                dictionary.setValue(Helper.getFirstName(), forKey: "FirstName")
                dictionary.setValue(Helper.getLastName(), forKey: "LastName")
        
        return dictionary
        
    }
    
    class func getItemsDict(menus : [Menu]) -> [NSMutableDictionary] {
//        {"Name":"The Bakery",
//        "PosItemId":"58001",
//        "Price":"12.00",
//        "Quantity":1,
//        "UseTakeOutPrice":false,
//        "SubItems": [{
//                "PosItemId": "20542"
//                }]
//    }
        
        
        var dataArray : [NSMutableDictionary] = []
        for menu in menus  {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(menu.posItemId, forKey: "PosItemId")
            dictionary.setValue(menu.item_name, forKey: "Name")
            dictionary.setValue(1, forKey: "Quantity")
            dictionary.setValue(false, forKey: "UseTakeOutPrice")
//            dictionary.setValue("", forKey: "Price")
            dictionary.setValue(getModifierPosIds(modifiers: menu.selectedModifierArray), forKey: "SubItems")
             dataArray.append(dictionary)
        }
        return dataArray
    }
    class func getModifierPosIds(modifiers : [Modifier]) -> [NSMutableDictionary] {
        var dataArray : [NSMutableDictionary] = []
        for modi in modifiers  {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(modi.posItemId, forKey: "PosItemId")
            dataArray.append(dictionary)
        }
        return dataArray
    }
    public func copy(with zone: NSZone? = nil) -> Any {
        let menu = Menu()
        menu.order_Id = order_Id
        menu.department_Id = department_Id
        menu.item_id = item_id
        menu.label = label
        menu.labelDescription = labelDescription
        menu.imageURL = imageURL
        menu.isEnabled = isEnabled
        menu.submoduleType = submoduleType
        menu.mobile_number = mobile_number
        menu.posItemId = posItemId
        menu.subMenuDataType = subMenuDataType
        menu.module_id = module_id
//        menu.subTitle  = subTitle
        menu.duration  = duration
        menu.cellImage  = cellImage
        menu.quantity = quantity
        menu.isChecked = isChecked
        menu.daysArray = daysArray
        menu.itemType  = itemType
        menu.orderType = orderType
        menu.link = link
        menu.room_number = room_number
        menu.linkDescription = linkDescription
        menu.disclaimer = disclaimer
        menu.item_price = item_price
        menu.item_name = item_name
        menu.category_id = category_id
        menu.menu_item_suffix = menu_item_suffix
        menu.available_quantity = available_quantity
        menu.max_quantity = max_quantity
        menu.isAirport = isAirport
        menu.items_attributes = items_attributes
        menu.tax = tax
        menu.serviceSelectedItemsArray = serviceSelectedItemsArray
        menu.removeInNextOrder = removeInNextOrder
        menu.modifierGroup = modifierGroup
        menu.selectedModifierArray = selectedModifierArray
        menu.is_operating = is_operating
        menu.operatingHours = operatingHours
        menu.operatingHoursSlots = operatingHoursSlots
        menu.base_packages = base_packages
        menu.is_couple = is_couple
        menu.couple_name = couple_name
        menu.is_drink = is_drink
        return menu
    }
    
}

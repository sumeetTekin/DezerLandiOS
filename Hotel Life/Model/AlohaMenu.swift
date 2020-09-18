//
//  Menu.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/15/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation
import UIKit


public class AlohaMenu : NSObject {

    public var label : String? = ""
    public var imageURL : URL?
    var posItemId : String?
    public var subItems : [AlohaMenu] = []
    public var item_price : Float = 0
    public var item_name : String? = ""
    public var tax : Tax?
    public var quantity : Int = 0
    public var is_drink : Bool?
   

    override init() {
    }
    
    public class func modelsFromDictionaryArray(array:NSArray, imagePath : String) -> [AlohaMenu]
    {
        var models:[AlohaMenu] = []
        for item in array
        {
            models.append(AlohaMenu(dictionary: item as! NSDictionary, imagePath : imagePath)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary , imagePath : String) {
        // For Menu
        
        if let name = dictionary["Name"] as? String {
            label = name
        }
        if let subItems = dictionary["SubItems"] as? NSArray, subItems.count > 0 {
            self.subItems = AlohaMenu.modelsFromDictionaryArray(array: subItems, imagePath: "")
        }
        if let _id = dictionary["PosItemId"] as? Int {
            posItemId = "\(_id)"
        }
        if let _id = dictionary["PosItemId"] as? String {
            posItemId = _id
        }
        
        if let price = dictionary["Price"] as? Float {
            item_price = price
        }
        if let price = dictionary["Price"] as? String {
            if let val = Float(price) {
                item_price = val
            }
        }

        if let img = dictionary["image"] as? String {
            imageURL = URL.init(string:"\(imagePath)\(img)")
        }
       
        if let taxes = dictionary["tax"] as? NSDictionary{
            if taxes.allKeys.count > 0 {
                tax = Tax(dictionary: taxes)
            }
        }
        if let sub = dictionary["Name"] as? String {
            item_name = "\(sub)"
        }
        if let val = dictionary["is_drink"] as? Bool {
            is_drink = val
        }
        if let item_quantity = dictionary["Quantity"] as? Int {
            self.quantity = item_quantity
        }
        
        
        
    }
    func getModifiersName() -> String {
        var modifiers = ""
        if subItems.count > 0 {
            for index in 0...(subItems.count - 1) {
                if let name = subItems[index].label {
                    modifiers = modifiers.appending(name)
                    if (index < subItems.count - 1) {
                        modifiers = modifiers.appending(" + ")
                    }
                }
            }
        }
        return modifiers
    }
    func getQuantityByPrice() -> String {
        return "\(self.quantity) X $\(self.getTotalPrice())"
    }
    func getTotalPrice() -> String {
        var total = self.item_price
        for item in subItems {
            total = total + item.item_price
        }
        return String(format : "%.2f",total)
    }
        
//    class func dictionaryRepresentationForConfirmOrder(menus : [AlohaMenu], model : ReservationModel,  orderMode : Int) -> NSMutableDictionary {
//
//        let dictionary = NSMutableDictionary()
//        dictionary.setValue(getCustomerNameDict(), forKey: "customer")
//        dictionary.setValue(getItemsDict(menus : menus), forKey: "items")
//        dictionary.setValue(orderMode, forKey: "orderMode")
//        dictionary.setValue(4, forKey: "orderSource")
//        dictionary.setValue(0, forKey: "status")
//        if let id = model.department_id {
//            dictionary.setValue(id, forKey: "department_id")
//        }
//        if let id = model.module_id {
//            dictionary.setValue(id, forKey: "module_id")
//        }
//        if let people = model.number_of_people, people > 0 {
//            dictionary.setValue(people, forKey: "number_of_people")
//        }
//        if let tax = model.tax {
//            if orderMode == 3 {
//                tax.delivery_charge = Float(orderMode)
//            }
//            else {
//                tax.delivery_charge = nil
//            }
//            dictionary.setValue(tax.dictionaryRepresentation(), forKey: "tax")
//        }
//        var specialInstruction = ""
//        if let is_drink = model.is_drink {
//            dictionary.setValue(is_drink, forKey: "is_drink")
//        }
//        if let chair_number = model.chair_number {
//            specialInstruction = specialInstruction.appending("Chair: \(chair_number), ")
//            dictionary.setValue(chair_number, forKey: "chair_number")
//        }
//        if let roomNumber = model.room_number {
//            specialInstruction = specialInstruction.appending("Room: \(roomNumber), ")
//            dictionary.setValue(roomNumber, forKey: "room_number")
//        }
//        specialInstruction = specialInstruction.appending("Last Name: \(Helper.getLastName())")
//        dictionary.setValue(specialInstruction, forKey: "SpecialInstructions")
//        dictionary.setValue(Helper.getCurrentDateTimeString(), forKey: "orderTime")
//        
//        print(dictionary)
//        return dictionary
//        
//    }
    class func dictionaryRepresentationForTaxCalculation(menus : [AlohaMenu], orderMode : Int) -> NSMutableDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(Helper.getCustomerNameDict(), forKey: "customer")
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
    
    class func getItemsDict(menus : [AlohaMenu]) -> [NSMutableDictionary] {
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
            dictionary.setValue(getModifierPosIds(modifiers: menu.subItems), forKey: "SubItems")
            dataArray.append(dictionary)
        }
        return dataArray
    }
    class func getModifierPosIds(modifiers : [AlohaMenu]) -> [NSMutableDictionary] {
        var dataArray : [NSMutableDictionary] = []
        for modi in modifiers  {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(modi.posItemId, forKey: "PosItemId")
            dataArray.append(dictionary)
        }
        return dataArray
    }
    
    
    
   
}


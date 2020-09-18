//
//  AlohaOrder.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 29/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import Foundation
import UIKit

class AlohaOrder: NSObject {
    
    public var alohaMenu : [AlohaMenu]? = []
    public var failedMenu : [AlohaMenu]? = []
    public var orderNumber : String? = ""
    public var orderId : String? = ""
    public var roomNumber : String? = ""
    public var subTotal : String? = ""
    public var serviceCharge : String?
    public var deliveryCharge : String?
    public var stateTax : String?
    public var countyTax : String?
    public var discount : String? = ""
    public var afterDiscount : String? = ""
    public var total : String? = ""
    public var tax : String? = ""
    public var status : String? = ""
    public var prepTime : String? = ""
    public var promiseDateTime : String? = ""
    public var orderTime : String? = ""
    public var specialInstruction : String? = ""
    public var orderMode : Int?
    public var reservationModel : ReservationModel?
    
    
    override init() {
        
    }
    
    public class func modelsFromDictionaryArray(array:NSArray, imagePath : String) -> [AlohaOrder]
    {
        var models:[AlohaOrder] = []
        for item in array
        {
            models.append(AlohaOrder(dictionary: item as! NSDictionary, imagePath : imagePath)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary , imagePath : String) {
        super.init()
        self.reservationModel = ReservationModel()
        if let val = dictionary["chair_number"] as? String {
            self.reservationModel?.chair_number = val
        }
        if let val = dictionary["room_number"] as? String {
            self.reservationModel?.room_number = val
        }
        if let val = dictionary["department_id"] as? String{
            self.reservationModel?.department_id = val
        }
        if let val = dictionary["module_id"] as? String{
            self.reservationModel?.module_id = val
        }
        if let val = dictionary["is_drink"] as? Bool {
            self.reservationModel?.is_drink = val
        }
        if let val = dictionary["beach_location"] as? String{
            self.reservationModel?.beach_location = val
        }
        if let val = dictionary["SpecialInstructions"] as? String {
            self.specialInstruction = val
        }
        if let val = dictionary["orderMode"] as? Int {
            self.orderMode = val
        }
        if let taxes = dictionary["tax"] as? NSDictionary{
            self.reservationModel?.tax = Tax(dictionary: taxes)
        }
        
        if let items = dictionary["Items"] as? NSArray {
            alohaMenu = AlohaMenu.modelsFromDictionaryArray(array: items, imagePath: "")
        }
        if let items = dictionary["items"] as? NSArray {
            // remove items which are not drinks
            alohaMenu = AlohaMenu.modelsFromDictionaryArray(array: items, imagePath: "")
            if let menus = alohaMenu?.reversed() {
                for menu in menus{
                    if UserDefaults.standard.bool(forKey: "isFromOrderHistoryDetailVC") == false {
                        if menu.is_drink != true {
                            if let index = alohaMenu?.index(of: menu) {
                                alohaMenu?.remove(at: index)
                            }
                        }
                    }
                    
                }
            }
        }
        if let items = dictionary["FailedItems"] as? NSArray {
            failedMenu = AlohaMenu.modelsFromDictionaryArray(array: items, imagePath: "")
        }
        if let text = dictionary["OrderNumber"] as? Int {
            orderNumber = "\(text)"
        }
        if let text = dictionary["SubTotal"] as? Float {
            subTotal =  "\(String.init(format: "%.2f", text))"
        }
        if let text = dictionary["Tax"] as? Float {
            tax = "\(String.init(format: "%.2f", text))"
        }
        if let text = dictionary["Total"] as? Float {
            total =  "\(String.init(format: "%.2f", text))"
        }
        if let text = dictionary["DiscountTotal"] as? Float {
            discount =  "\(String.init(format: "%.2f", text))"
            afterDiscount = calculateSubTotalAfterDiscount()
        }
        
        if let text = dictionary["OrderId"] as? Int {
            orderId =  "\(text)"
        }
        if let text = dictionary["PrepTime"] as? Int {
            prepTime =  "\(text) minutes"
        }
        if let text = dictionary["PromiseDateTime"] as? String {
            if let date = Helper.getOptionalDateFromString(string: text, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS) {
                promiseDateTime =  Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: date)
            }
        }
        if let text = dictionary["OrderTime"] as? String {
            if let date = Helper.getOptionalDateFromString(string: text, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS) {
                orderTime =  Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: date)
            }
        }
        if let text = dictionary["KitchenStatus"] as? Int {
            status  =  Helper.getStatusOfOrder(status: text)
        }
        if let text = dictionary["OrderMode"] as? Float, text == 3 {
            deliveryCharge  =  "\(String.init(format: "%.2f", text))"
        }
    }
    func dictionaryRepresentationForConfirmOrder() -> NSMutableDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(Helper.getCustomerNameDict(), forKey: "customer")
        dictionary.setValue(getItemsDict(menus : self.alohaMenu), forKey: "items")
        dictionary.setValue(orderMode, forKey: "orderMode")
        dictionary.setValue(4, forKey: "orderSource")
        dictionary.setValue(0, forKey: "status")
        if let id = self.reservationModel?.department_id {
            dictionary.setValue(id, forKey: "department_id")
        }
        if let id = self.reservationModel?.module_id {
            dictionary.setValue(id, forKey: "module_id")
        }
        if let people = self.reservationModel?.number_of_people, people > 0 {
            dictionary.setValue(people, forKey: "number_of_people")
        }
        if let tax = self.reservationModel?.tax {
            if let mode = orderMode, mode == 3 {
                tax.delivery_charge = Float(mode)
            }
            else {
                tax.delivery_charge = nil
            }
            dictionary.setValue(tax.dictionaryRepresentation(), forKey: "tax")
        }
        
        if let is_drink = self.reservationModel?.is_drink {
            dictionary.setValue(is_drink, forKey: "is_drink")
        }
        if let paymentType = self.reservationModel?.paymentType{
            dictionary.setValue(paymentType, forKey: "paymentType")
        }
        var specialInstruction = ""
        if let chair_number = self.reservationModel?.chair_number {
            specialInstruction = specialInstruction.appending("Chair: \(chair_number), ")
            dictionary.setValue(chair_number, forKey: "chair_number")
        }
        if let beach_location = self.reservationModel?.beach_location,beach_location != ""{
              dictionary.setValue(beach_location, forKey: "beach_location")
            specialInstruction = specialInstruction.appending("Beach Location: \(beach_location), ")
        }
        if let roomNumber = self.reservationModel?.room_number {
            specialInstruction = specialInstruction.appending("Room: \(roomNumber), ")
            dictionary.setValue(roomNumber, forKey: "room_number")
        }
        specialInstruction = specialInstruction.appending("Last Name: \(Helper.getLastName())")
        if let paymentType = self.reservationModel?.paymentType {
            specialInstruction = specialInstruction.appending(", Payment Type: \(Helper.getPaymentType(orderMode: paymentType))")
        }
        dictionary.setValue(specialInstruction, forKey: "SpecialInstructions")
        if let instruction = self.specialInstruction, instruction != "" {
            dictionary.setValue(instruction, forKey: "SpecialInstructions")
        }
        
        dictionary.setValue(Helper.getCurrentDateTimeString(), forKey: "orderTime")
        
        print(dictionary)
        return dictionary
        
    }
    func calculateSubTotalAfterDiscount() -> String {
        let subtotal = getSubtotalAmount()
        if let discount = discount {
            if let text = Float(discount) {
                var discountedTotal = subtotal - text
                if discountedTotal < 0 {
                    discountedTotal = 0
                    return "\(String.init(format: "%.2f", discountedTotal))"
                }
                return "\(String.init(format: "%.2f", discountedTotal))"
        }
        }
        return"0.00"
    }
    func calculateServiceCharge(charge : Float) -> String {
        // service charge to be added on subtotal amount
        let amount = getSubtotalAmount()
        let service_charge_total = amount * charge / 100
        return "\(String.init(format: "%.2f", service_charge_total))"
        
    }
    func calculateDeliveryCharge(charge : Float, percent : Float) -> String {
        //add 7% of delivery charge to actual delivery charge
        let delivery = charge + (charge * percent / 100)
        return "\(String.init(format: "%.2f", delivery))"
        
    }
    func calculateStateTax(charge : Float) -> String {
//        to be calculated on service charge + subtotal
        let taxable = getServiceChargeAmount()
        let amount = (taxable * charge / 100)
        return "\(String.init(format: "%.2f", amount))"
        
    }
    func calculateCountyTax(charge : Float) -> String {
        // to be calculated on subtotal only
        var serviceCharge : Float = 0
        if let val = self.serviceCharge {
            if let serv = Float(val) {
                serviceCharge = serv
            }
        }
        let taxable = getSubtotalAmount() + serviceCharge
        let amount = (taxable * charge / 100)
        return "\(String.init(format: "%.2f", amount))"
        
    }
    func getSubtotalAmount() -> Float {
        var amount : Float = 0
        
        if let subTotal = self.subTotal {
            if let val = Float(subTotal) {
                amount = amount + val
            }
        }
        return amount
    }
    
    func getServiceChargeAmount() -> Float{
        var amount : Float = 0

        amount = amount + getSubtotalAmount()
        if let serviceCharge = self.serviceCharge {
            if let serv = Float(serviceCharge) {
                amount = amount + serv
            }
        }
        return amount
    }
    
    func getTaxableAmount() -> Float{
        var amount : Float = 0
    
        amount = amount + getSubtotalAmount()
        if let serviceCharge = self.serviceCharge {
            if let serv = Float(serviceCharge) {
                amount = amount + serv
            }
        }
        if let deliveryCharge = self.deliveryCharge {
            if let del = Float(deliveryCharge) {
                amount = amount + del
            }
        }
        return amount
    }
    
    // must set service charge and delivery charge before calculating
    func calculateTotal() -> String {
        var total : Float = 0
        
        if let subTotal = self.afterDiscount {
            if let val = Float(subTotal) {
                total = total + val
                
                if let charge = self.serviceCharge {
                    if let val = Float(charge) {
                        total = total + val
                    }
                }
                
                if let charge = self.deliveryCharge {
                    if let val = Float(charge) {
                        total = total + val
                    }
                }
                if let charge = self.stateTax {
                    if let val = Float(charge) {
                        total = total + val
                    }
                }
                if let charge = self.countyTax {
                    if let val = Float(charge) {
                        total = total + val
                    }
                }
                
//                if let tax = self.tax {
//                    if let val = Float(tax) {
//                        total = total + val
//                    }
//                }
                return "\(String.init(format: "%.2f", total))"
            }
        }
        return "\(String.init(format: "%.2f", 0.00))"
        
    }
    
    
    
    func getItemsDict(menus : [AlohaMenu]?) -> [NSMutableDictionary] {
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
        if let arr = menus {
            for menu in arr  {
                let dictionary = NSMutableDictionary()
                
                dictionary.setValue(menu.posItemId, forKey: "PosItemId")
                dictionary.setValue(menu.item_name, forKey: "Name")
                if let is_drink = menu.is_drink {
                    dictionary.setValue(is_drink, forKey: "is_drink")
                }
                dictionary.setValue(1, forKey: "Quantity")
                dictionary.setValue(false, forKey: "UseTakeOutPrice")
                dictionary.setValue(getTotalPrice(subItems: menu.subItems, mainItem: menu), forKey: "Price")
                dictionary.setValue(getModifierPosIds(modifiers: menu.subItems), forKey: "SubItems")
                dataArray.append(dictionary)
            }
        }
        return dataArray
    }
    
    func getTotalPrice(subItems : [AlohaMenu], mainItem : AlohaMenu) -> String {
        var total = mainItem.item_price
        for item in subItems {
            total = total + item.item_price
        }
        return String(format : "%.2f",total)
    }
    
    func getModifierPosIds(modifiers : [AlohaMenu]) -> [NSMutableDictionary] {
        var dataArray : [NSMutableDictionary] = []
        for modi in modifiers  {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(modi.item_name, forKey: "Name")
            dictionary.setValue(modi.posItemId, forKey: "PosItemId")
            dataArray.append(dictionary)
        }
        return dataArray
    }
}

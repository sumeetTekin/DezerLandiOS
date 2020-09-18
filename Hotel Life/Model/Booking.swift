//
//  Booking.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 20/02/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import Foundation
public class Booking: NSObject, NSCoding {
    
    public var bookingNumber : String?
    public var arrival : String?
    public var departure : String?
    public var roomNumber : String?
    public var cardNumber : String?
    public var expiry : String?
    public var name : String?
    public var email : String?
    public var address : String?
    public var phone : String?
    public var level : String?
    public var adults : String?
    public var children : String?
    public var units : String?

    
    public override init() {
        super.init()
    }
    required public init?(dictionary: NSDictionary) {
        if let reservationresults = dictionary["reservationresults"] as? NSDictionary {
            self.name = ""
            if let title = reservationresults["name"] as? String {
                self.name = name?.appending(title)
            }

            if let date = reservationresults["arrival"] as? String {
                self.arrival = date
            }
            if let date = reservationresults["depart"] as? String {
                self.departure = date
            }
            if let date = reservationresults["unum"] as? String {
                self.roomNumber = date
            }
            if let level = reservationresults["level"] as? String {
                self.level = level
            }
            if let attributes = reservationresults["$attributes"] as? NSDictionary {
                if let bookingNumber = attributes["resno"] as? String {
                    self.bookingNumber = bookingNumber
                }
            }
            if let adults = reservationresults["adults"] as? String {
                self.adults = adults
            }
            if let children = reservationresults["children"] as? String {
                self.children = children
            }
            if let units = reservationresults["units"] as? String {
                self.units = units
            }
            
        }
        if let guestresults = dictionary["guestresults"] as? NSDictionary {
            if let credit = guestresults["credit"] as? String {
                self.cardNumber = credit
            }
            if let exp = guestresults["exp"] as? String, exp != "/" {
                self.expiry = exp
            }
            if let phone = guestresults["phone"] as? String {
                self.phone = phone
            }
            if let email = guestresults["email"] as? String {
                self.email = email
            }
            var address = ""
            if let addr = guestresults["address1"] as? String {
                address = address.appending(addr)
                address = address.appending(" ")
            }
            if let addr = guestresults["address2"] as? String {
                address = address.appending(addr)
            }
            self.address = address
        }
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.bookingNumber, forKey: "bookingNumber")
        dictionary.setValue(self.arrival, forKey: "arrival")
        dictionary.setValue(self.departure, forKey: "departure")
        dictionary.setValue(self.roomNumber, forKey: "roomNumber")
        dictionary.setValue(self.cardNumber, forKey: "cardNumber")
        dictionary.setValue(self.expiry, forKey: "expiry")
        dictionary.setValue(self.adults, forKey: "adults")
        dictionary.setValue(self.children, forKey: "children")
        dictionary.setValue(self.units, forKey: "units")
        return dictionary
    }
    
//    MARK: NSCODING
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.bookingNumber, forKey: "bookingNumber")
        aCoder.encode(self.arrival, forKey: "arrival")
        aCoder.encode(self.departure, forKey: "departure")
        aCoder.encode(self.roomNumber, forKey: "roomNumber")
        aCoder.encode(self.cardNumber, forKey: "cardNumber")
        aCoder.encode(self.expiry, forKey: "expiry")
        aCoder.encode(self.adults, forKey: "adults")
        aCoder.encode(self.children, forKey: "children")
        aCoder.encode(self.units, forKey: "units")
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.bookingNumber = aDecoder.decodeObject(forKey: "bookingNumber") as? String
        self.arrival = aDecoder.decodeObject(forKey: "arrival") as? String
        self.departure = aDecoder.decodeObject(forKey: "departure") as? String
        self.roomNumber = aDecoder.decodeObject(forKey: "roomNumber") as? String
        self.cardNumber = aDecoder.decodeObject(forKey: "cardNumber") as? String
        self.expiry = aDecoder.decodeObject(forKey: "expiry") as? String
        self.adults = aDecoder.decodeObject(forKey: "adults") as? String
        self.children = aDecoder.decodeObject(forKey: "children") as? String
        self.units = aDecoder.decodeObject(forKey: "units") as? String
        
    }
    
    
}

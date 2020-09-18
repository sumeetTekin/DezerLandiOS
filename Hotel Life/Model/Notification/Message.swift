//
//  Message.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 10/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation


public class Message {
	public var appointment_date : String?
    public var suggested_date : String?
    public var suggested_time : String?
	public var appointment_id : String?
	public var suggestion_text : String?
    public var image : String?
    public var message : String?
    public var action : String?
    public var title : String?
    public var time_modify : Bool?
    public var reservationModel : ReservationModel?
    public var previous_order_id : String?
    
    // Sub Menu
    var subMenuDataType : SubMenuDataType = .reservation

    public class func modelsFromDictionaryArray(array:NSArray) -> [Message]
    {
        var models:[Message] = []
        for item in array
        {
            models.append(Message(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		appointment_date = dictionary["appointment_date"] as? String
        if let dateStr = appointment_date {
            let date = Helper.getDateFromString(string: dateStr, formatString: DATEFORMATTER.MMDDYYYY_HH_MM)
            suggested_date = Helper.getStringFromDate(format: DATEFORMATTER.MMDDYYYY, date: date)
            suggested_time = Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: date)
        }
        title = dictionary["title"] as? String
		appointment_id = dictionary["appointment_id"] as? String
		suggestion_text = dictionary["suggestion_text"] as? String
        previous_order_id = dictionary["previous_order_id"] as? String
        image = dictionary["image"] as? String
        message = dictionary["message"] as? String
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
            case "instant_order": //instant order
                subMenuDataType = .instant_order
            default:
                subMenuDataType = .quantity_selection
            }
        }else{
            subMenuDataType = .def
        }
        time_modify = dictionary["time_modify"] as? Bool
        if let dict = dictionary["appointment"] as? NSDictionary {
            reservationModel = ReservationModel.init(dictionary: dict)
        }
        

	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.appointment_date, forKey: "appointment_date")
		dictionary.setValue(self.appointment_id, forKey: "appointment_id")
        dictionary.setValue(self.action, forKey: "action")
		return dictionary
	}
    public func dictionaryRepresentationForRestaurantReservation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(self.appointment_id, forKey: "appointment_id")
        dictionary.setValue(self.action, forKey: "action")
        dictionary.setValue(self.reservationModel?.module_id, forKey: "module_id")
        dictionary.setValue(self.reservationModel?.department_id, forKey: "department_id")
        if let people = self.reservationModel?.number_of_people {
            if people > 0{
                dictionary.setValue(self.reservationModel?.number_of_people, forKey: "number_of_people")
            }
        }
        dictionary.setValue(self.appointment_date, forKey: "appointment_date")
        dictionary.setValue(Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()), forKey: "order_date")
        
        if let promocode = self.reservationModel?.promocode {
            dictionary.setValue(promocode.dictionaryRepresentation(), forKey: "promocode")
        }
        return dictionary
    }

}

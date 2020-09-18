//
//  DateModel.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 29/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class DateModel: NSObject {
    
    var date : Int = 1
    var time : String?
    var month : String? = ""
    var monthNo : Int = 1 {
        didSet {
                    // set month string as month no.
                    switch monthNo {
                    case 1:
                        month = "Jan"
                    case 2:
                        month = "Feb"
                    case 3:
                        month = "Mar"
                    case 4:
                        month = "Apr"
                    case 5:
                        month = "May"
                    case 6:
                        month = "Jun"
                    case 7:
                        month = "Jul"
                    case 8:
                        month = "Aug"
                    case 9:
                        month = "Sep"
                    case 10:
                        month = "Oct"
                    case 11:
                        month = "Nov"
                    case 12:
                        month = "Dec"
                    default:
                        month = "Jan"
                    }

        }
    }
    
    var weekDay : String? = ""
    var weekDayNo : Int = 1{
        didSet{
            // set weekday string 
            switch weekDayNo {
            case 1:
                weekDay = "Sunday"
            case 2:
                weekDay = "Monday"
            case 3:
                weekDay = "Tuesday"
            case 4:
                weekDay = "Wednesday"
            case 5:
                weekDay = "Thursday"
            case 6:
                weekDay = "Friday"
            case 7:
                weekDay = "Saturday"
            default:
                weekDay = ""
            }
        }
    }
    
    var yearNo : Int = 2017
    var isSelected : Bool = false
    
    override init() {
        
    }
    
    required public init?(dictionary : NSDictionary) {
        if let text = dictionary["date"] as? Int {
            date = text
        }
        if let text = dictionary["month"] as? String {
            month = text
        }
        
        
        if let selected = dictionary["isSelected"] as? Bool {
            isSelected = selected
        }
    }
    

}

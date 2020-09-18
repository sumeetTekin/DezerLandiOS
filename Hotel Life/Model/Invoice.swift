//
//  Invoice.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 20/02/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import Foundation
public class Invoice: NSObject {
    public var tcode : String?
    public var tcredit : String?
    public var tdate : String?
    public var tdebit : String?
    public var tdescrip : String?
    public var tfolio : String?
    public var tnum : String?
    public var top : String?
    public var transfer : String?
    public var tunit : String?
    public var workorder : Float?
    public var paymentDetail : PaymentDetail?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Invoice]
    {
        var models:[Invoice] = []
        for item in array
        {
            if let item = item as? NSDictionary {
                models.append(Invoice(dictionary: item)!)
            }
        }
        return models
    }
    required public init?(dictionary: NSDictionary) {

        tcode = dictionary["tcode"] as? String
        tcredit = dictionary["tcredit"] as? String
        tdate = dictionary["tdate"] as? String
        tdebit = dictionary["tdebit"] as? String
        tdescrip = dictionary["tdescrip"] as? String
        tfolio = dictionary["tfolio"] as? String
        tnum = dictionary["tnum"] as? String
        top = dictionary["top"] as? String
        transfer = dictionary["transfer"] as? String
        tunit = dictionary["tunit"] as? String
        workorder = dictionary["workorder"] as? Float
        if let detail = dictionary["ccreceiptinfo"] as? NSDictionary {
            self.paymentDetail = PaymentDetail.init(dictionary: detail)
        }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.tcode, forKey: "tcode")
        dictionary.setValue(self.tcredit, forKey: "tcredit")
        dictionary.setValue(self.tdate, forKey: "tdate")
        dictionary.setValue(self.tdebit, forKey: "tdebit")
        dictionary.setValue(self.tdescrip, forKey: "tdescrip")
        dictionary.setValue(self.tfolio, forKey: "tfolio")
        dictionary.setValue(self.tnum, forKey: "tnum")
        dictionary.setValue(self.top, forKey: "top")
        dictionary.setValue(self.transfer, forKey: "transfer")
        dictionary.setValue(self.tunit, forKey: "tunit")
        dictionary.setValue(self.workorder, forKey: "workorder")
        return dictionary
    }
    
}

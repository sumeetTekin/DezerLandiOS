//
//  PaymentDetail.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 19/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

public class PaymentDetail: NSObject {
        public var name : String?
        public var arrival : String?
        public var departure : String?
        public var roomNumber : String?
        public var folio : String?
        public var cardnumber : String?
        public var invoiceNumber : String?
        public var invoiceDate : String?
        public var transactionAmount : String?

        public class func modelsFromDictionaryArray(array:NSArray) -> [PaymentDetail]
        {
            var models:[PaymentDetail] = []
            for item in array
            {
                models.append(PaymentDetail(dictionary: item as! NSDictionary)!)
            }
            return models
        }
        required public init?(dictionary: NSDictionary) {
            
            name = AppInstance.applicationInstance.user?.name
            arrival = AppInstance.applicationInstance.user?.arrival_date
            departure = AppInstance.applicationInstance.user?.departure_date
            roomNumber = AppInstance.applicationInstance.user?.room_number
            folio = dictionary["folio"] as? String
            invoiceNumber = dictionary["InvoiceNumber"] as? String
            invoiceDate = dictionary["TransactionDate"] as? String
            cardnumber = dictionary["MaskedCardNumber"] as? String
            if let amount = dictionary["TransactionAmount"] as? String {
                if let amt = Float(amount) {
                    transactionAmount = String(format : "%.2f",amt)
                }
            }
        }
}

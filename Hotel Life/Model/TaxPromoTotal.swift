//
//  TaxPromoTotal.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 22/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

public class TaxPromoTotal: NSObject {
    
    public var sub_total : Float = 0
    public var actual_sub_total : Float = 0
    public var county_tax_total : Float = 0
    public var service_charge_total : Float = 0
    public var state_tax_total : Float = 0
    public var delivery_charge_total : Float = 0
    public var order_total : Float = 0
    
    public var discounted_sub_total : Float = 0
    public var promocodeText : String = ""
    public var promocodeDiscount : Float = 0
    
    
    public func calculateTaxesForReservation(reservation : ReservationModel) -> TaxPromoTotal {
        let items : [Menu]? = reservation.items, tax : Tax? = reservation.tax, promocode : Promocode? = reservation.promocode
        if let items = items {
            sub_total = Helper.getQuantityTotal(menuArray: items)
            actual_sub_total = Helper.getActualQuantityTotal(menuArray: items)
        }
        var total : Float = 0
        var taxableAmount : Float = 0
        total = total + sub_total
        
        if let val = promocode?.value{
            if let type = promocode?.type {
                if type == "flat" {
                    promocodeDiscount = val
                    if total > 0 {
                        if promocodeDiscount >= total {
                            promocodeDiscount = total
                        }
                        total = total - val
                        if total <= 0 {
                            total = 0
                        }
                    }
                    discounted_sub_total = total
                    promocodeText = "$\(String.init(format: "%.2f", promocodeDiscount)) off"
                }
                else{
                    if total > 0 {
                        promocodeDiscount = total * val / 100
                        total = total - promocodeDiscount
                        if total <= 0 {
                            total = 0
                        }
                    }
                    discounted_sub_total = total
                    promocodeText = "\(String.init(format: "%.0f", val))% off"
                }
            }
        }
        
        taxableAmount = total
        
        if let tax = tax?.service_charge {
            service_charge_total = actual_sub_total * tax / 100
            total = total + service_charge_total
            taxableAmount = total
        }
        if let deliveryCharge = tax?.delivery_charge {
            delivery_charge_total = deliveryCharge
            total = total + deliveryCharge
            taxableAmount = total
        }
        if let tax = tax?.state_tax{
            state_tax_total = taxableAmount * tax / 100
            total = total + state_tax_total
        }
        if let ctax = tax?.county_tax{
            if let servtax = tax?.service_charge {
                let serv = self.calculateServiceCharge(charge: servtax)
                county_tax_total = (sub_total + Float(serv)!) * ctax / 100
                total = total + county_tax_total
            }
            
        }
        order_total = total
        return self
    }
    
    func calculateServiceCharge(charge : Float) -> String {
        // service charge to be added on subtotal amount
        let amount = sub_total
        let service_charge_total = amount * charge / 100
        return "\(String.init(format: "%.2f", service_charge_total))"
        
    }

}

//
//  RequestCarReusableView.swift
//  BeachResorts
//
//  Created by Apple on 17/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol RequestCarDelegate {
    func requestCarWith(ticketNumber : String)
}
class RequestCarReusableView: UICollectionReusableView {
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var ticketText: UITextField!
    @IBOutlet weak var requestBtn: UIButton!
    var delegate : RequestCarDelegate?
    func configureHeader(){
        childView.backgroundColor = .clear
        childView.layer.borderColor = UIColor.white.cgColor
        childView.layer.borderWidth = 1.0
    }
    @IBAction func requestAction(_ sender: UIButton) {
        ticketText.resignFirstResponder()
         if let ticket_number = ticketText.text {
            delegate?.requestCarWith(ticketNumber: ticket_number)
        }
        
    }
    
}

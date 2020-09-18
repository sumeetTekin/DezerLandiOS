//
//  BookingCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 07/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    var booking : Booking? {
        didSet {
            updateCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell() {
        if let name = booking?.name {
            self.lbl_name.text = name
        }
        else {
            self.lbl_name.text = ""
        }
//        if let address = booking?.address {
//            self.lbl_address.text = address
//        }
//        else {
//            self.lbl_address.text = ""
//        }
        if let email = booking?.email {
            self.lbl_email.text = getEmail(email: email)
        }
        else {
            self.lbl_email.text = ""
        }
        if let phone = booking?.phone {
            self.lbl_phone.text = "Phone: \(getPhone(phone: phone))"
        }
        else {
            self.lbl_phone.text = ""
        }
    }
    func getPhone(phone : String) -> String{
        let charArray = Array(phone)
        var newString = ""
        for i in 0...charArray.count-1 {
            if charArray[i] == "-" || i >= charArray.count-5 {
                newString = newString.appending(String.init(format: "%@", String(charArray[i])))
            }
            else{
              newString = newString.appending("X")
            }
        }
        return newString
    }
    func getEmail(email : String) -> String{
        let strArray = email.components(separatedBy: "@")
        if strArray.count > 1 {
            var newString = ""

            if let first = strArray.first {
                let charArray = Array(first)
                for i in 0...charArray.count-1 {
                    if i <= 0 {
                        newString = newString.appending(String.init(format: "%@",String(charArray[i])))
                    }
                    else{
                        newString = newString.appending("X")
                    }
                }
                newString = newString.appending("@")
            }
            if let last = strArray.last {
                let charArray = Array(last)
                for i in 0...charArray.count-1 {
                        newString = newString.appending(String.init(format: "%@", String(charArray[i])))
                }
                
            }
            return newString
            
        }
        else {
            return ""
        }
        
    }

}

//
//  CheckInVC.swift
//  BeachResorts
//
//  Created by Apple on 17/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class CheckInVC: BaseViewController {
    var titleBarText: String = "Mobile Check In"
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var txt_bookingNumber: MyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        childView.backgroundColor = .clear
        childView.addBorder(color: .white)
        self.navigationController?.navigationBar.topItem?.title = "";
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SubmitAction(_ sender: UIButton) {
        
        if validate() {
            if let no = txt_bookingNumber.text {
                self.getCheckinDetail(reservationNo: no)
            }
        }
    }
    func getCheckinDetail(reservationNo : String) {
        
        if let user = AppInstance.applicationInstance.user {
            if let name = user.getSoapParamName() {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            let obj = BusinessLayer()
            obj.userBookingEnquiry(name: name) { (status, message, booking)  in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                })
                if status {
                    let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.CHECKIN_CARD) as! CheckInCardVC
                    //objDirection.booking = booking
                    DispatchQueue.main.async(execute: {
                        self.navigationController?.pushViewController(objDirection, animated: true)
                    })
                }
                else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
                }
            }
        }
        
    }
    
    func validate() ->Bool {
        if (txt_bookingNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0 {
            return true
        }
        else{
            Helper.showAlert(sender: self, title: "Error", message: ALERTSTRING.VALID_BOOKING);
            return false
        }
    }

}

//
//  WalletPayVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 13/08/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class WalletPayVC: BaseViewController {
    
    var reservation : ReservationModel = ReservationModel()
    
    @IBOutlet var btnPay : UIButton?
    @IBOutlet var lblWalletBalance : UILabel?
    @IBOutlet var lblTotalAmount : UILabel?
    
    var titleValue : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTotalAmount?.text = "\(Int(reservation.totalSelectedPrice ?? 0.0))"
        self.setNavigationBar(title: "Dezer Bucks Wallet")

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func PayAction(_ sender : UIButton){
        
        let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "ReservationConfirmVC") as! ReservationConfirmVC
        self.definesPresentationContext = true
        objAlert.showDate = false
        objAlert.reservation = self.reservation
        objAlert.delegate = self
        objAlert.titleValue = self.titleValue!
        objAlert.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(objAlert, animated: true, completion: {
        })
        
    }

}


//MARK:  Delegate after confirmation
extension WalletPayVC: ReservationConfirmDelegate{
    func alertDismissedToRootView() {
        self.dismiss(animated: false) {
            
            //self.navigationController?.popToRootViewController(animated: true)
            if let destinationViewController = self.navigationController?.viewControllers
                                                                    .filter(
                                                  {$0 is BaseTabBarVC})
                                                                    .first {
                self.navigationController?.popToViewController(destinationViewController, animated: true)
            }
            
            
        }
    }
}

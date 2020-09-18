//
//  UpgradeSuiteVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/18/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

@objc protocol UpgradeSuiteVCDelegate {
    func updateAlertDismissed()
}

class UpgradeSuiteVC: UIViewController {
    weak var delegate : UpgradeSuiteVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Update Suite Screen", className: "UpgradeSuiteVC")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func upgradeAction(_ sender: UIButton) {
        self.showDialog(title: "", message: "Please contact front desk for room upgradation.")
//        self.dismiss(animated: true) {
//
//            self.delegate?.alertDismissed()
//        }
    }
    
    @IBAction func noThanks(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.updateAlertDismissed()
        }
    }
    func showDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CancelAlert) as! CancelAlert
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            objAlert.txtv_description.text = message
            self.present(objAlert, animated: false) {
            }
        })
    }

}

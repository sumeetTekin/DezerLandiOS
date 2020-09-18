//
//  AllergiesVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 13/06/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol AllergiesDelegate {
    func selectedNumber(model : ReservationModel, controller : AllergiesVC)
}
class AllergiesVC: UIViewController {
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lbl_howMany: UILabel!
    @IBOutlet weak var bgviewBtn: UIView!
    @IBOutlet weak var btn_selectNumber: UIButton!
    @IBOutlet weak var lbl_allergies: UILabel!
    @IBOutlet weak var btn_no: UIButton!
    @IBOutlet weak var btn_yes: UIButton!
    @IBOutlet weak var btn_continue: UIButton!
    var delegate : AllergiesDelegate?
    var reservationModel : ReservationModel?
    var count = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gesture.cancelsTouchesInView = false
        view_bg.addGestureRecognizer(gesture)
        bgviewBtn.addBorder(color: .white)
        btn_selectNumber.setTitle("\(count)", for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.actionNo(btn_no)
    }
    @objc func tapGesture() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionSelectNumber(_ sender: Any) {
        showQuantitySelection()
    }
    @IBAction func actionNo(_ sender: Any) {
            btn_no.isSelected = true
            btn_yes.isSelected = false
    }
    @IBAction func actionYes(_ sender: Any) {
        btn_no.isSelected = false
        btn_yes.isSelected = true
        self.showDialog(title: "", message: "Please contact In Room Dining Department by dialing extension 5757 to place your order")
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
    func showQuantitySelection() {
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.QuantityPickerVC) as! QuantityPickerVC
        objUpgrade.delegate = self
        self.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        objUpgrade.selectedQuantity = 1
        objUpgrade.titleHeader = "Select number of people"
        DispatchQueue.main.async(execute: {
            self.present(objUpgrade, animated: true, completion: nil)
        })
    }
    @IBAction func action_continue(_ sender: Any) {
        if btn_yes.isSelected == true {
            self.showDialog(title: "", message: "Please contact In Room Dining Department by dialing extension 5757 to place your order")
            return
        }
        if count > 0 {
            if let model = reservationModel {
                model.number_of_people = count
                delegate?.selectedNumber(model: model, controller: self)
            }
        }
        else {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Please select number of people!!!")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
extension AllergiesVC : QuantityPickerDelegate {
    func selectedPickerQuantity(quantity : Int) {
        btn_selectNumber.setTitle("\(quantity)", for: .normal)
        self.count = quantity
    }
    func selectedAmenityQuantity(amenity : Amenities) {
        ///
    }
}

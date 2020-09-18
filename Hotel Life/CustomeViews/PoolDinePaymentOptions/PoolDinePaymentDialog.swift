//
//  PoolDinePaymentDialog.swift
//  Hotel Life
//
//  Created by Adil Mir on 11/9/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol PoolDinePaymentDelegate{
    func getPaymentType(paymentType:Int)
}
class PoolDinePaymentDialog: UIViewController {

    var delegate:PoolDinePaymentDelegate?
    @IBOutlet weak var paymentLabel:UILabel!
    @IBOutlet weak var paymentOptionTF:UITextField!
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var confirmButon:UIButton!
    @IBOutlet weak var view_bg: UIView!
    let picker = UIPickerView()
    var paymentType:Int?
    var pickerItems = [String]()
//    8 for Room Charge (House Account)
//    3 for Credit Card
//    1 for Cash

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPicker()
        paymentLabel.text = TITLE.howToPay
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gesture.cancelsTouchesInView = false
        view_bg.addGestureRecognizer(gesture)
        if Helper.ReadUserObject()?.userType != UserType.hotelGuest.rawValue{
            pickerItems = [TITLE.creditCard,TITLE.cash]
        } else {
            pickerItems = [TITLE.roomCharge,TITLE.creditCard,TITLE.cash]
        }
        // Do any additional setup after loading the view.
    }
    @objc func tapGesture() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func setUpPicker(){
        
        picker.delegate = self
        picker.dataSource = self
        paymentOptionTF.inputView = picker
        paymentOptionTF.placeholder = PLACEHOLDER.selectPayment
        if let str = paymentOptionTF.placeholder {
            paymentOptionTF.attributedPlaceholder = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
    }
    
    func updateUI(){
        confirmButon.setTitle(BUTTON_TITLE.Confirm, for: .normal)
        cancelButton.setTitle(BUTTON_TITLE.Cancel, for: .normal)
        paymentOptionTF.layer.borderWidth = 1.0
        paymentOptionTF.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func actionConfirm(_ sender:UIButton){
        if (paymentOptionTF.text?.isEmpty)!{
           
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.SelectPayment)
            return
        }
        self.dismiss(animated: true) {
            if let type = self.paymentType{
               self.delegate?.getPaymentType(paymentType: type)
            }
        }
    }
    
    @IBAction func actionCancel(_ sender:UIButton){
         self.dismiss(animated: true, completion: nil)
    }
}

extension PoolDinePaymentDialog:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paymentOptionTF.text = pickerItems[row]
        paymentType = Helper.getPaymentCode(type: pickerItems[row])
    }
    
    
}

extension PoolDinePaymentDialog:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)!{
            textField.text = pickerItems[picker.selectedRow(inComponent: 0)]
            paymentType = Helper.getPaymentCode(type: pickerItems[picker.selectedRow(inComponent: 0)])
        }
    }
}

//
//  SelectChairVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/20/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol SelectChairVCDelegate {
    func selectedChair(model : ReservationModel,controller : UIViewController)
    func selectedRoom(model : ReservationModel,controller : UIViewController)
    func selectedQuantity(quantity : Int)
    func fillRoom(alohaOrderModel : AlohaOrder, reservationModel:ReservationModel,controller : UIViewController)
}

class SelectChairVC: BaseViewController {
    var delegate : SelectChairVCDelegate?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_alert: UIImageView!
    @IBOutlet weak var txt_chairNumber: UITextField!
    @IBOutlet weak var btn_done: UIButton!
    @IBOutlet weak var view_bg: UIView!
    
    var showChair : Bool = false
    var showRoom : Bool = false
    var beachDining = false
    
    var txt_picker : UITextField = UITextField()
    var pickerItems = ["U","L","Cab"]
    var pickerView : UIPickerView = UIPickerView()
    var reservationModel : ReservationModel?
    var alohaOrderModel : AlohaOrder?
    var alreadyReserved = false
    var titleBarText : String? = ""
    var alertText = ""
    
     var showRoomForOrder : Bool = false
    
//    var navController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_done.setTitle(BUTTON_TITLE.Submit, for: .normal)
        if showChair {
            if beachDining == false{
            pickerView.delegate = self
            pickerView.dataSource = self
            txt_picker.frame = CGRect(x: 1, y: 1, width: txt_chairNumber.frame.height + 15, height: txt_chairNumber.frame.height)
            txt_picker.textAlignment = .center
            txt_picker.tintColor = UIColor.clear
            txt_picker.delegate = self
            txt_picker.layer.borderColor = UIColor.lightGray.cgColor
            txt_picker.layer.borderWidth = 0.5
            txt_picker.text = pickerItems.first
            txt_picker.font = UIFont.init(name: FONT_NAME.FONT_SEMIBOLD, size: 15)
            txt_picker.inputView = pickerView
            
            
            let dropImage = UIImageView.init(image: #imageLiteral(resourceName: "dropDown"))
            dropImage.contentMode = .scaleAspectFit
            
            dropImage.frame = CGRect(x: 0, y: 0, width: 12, height: txt_picker.frame.height)
            txt_picker.rightView = dropImage as UIView
            txt_picker.rightViewMode = .always
            
            txt_chairNumber.leftView = txt_picker as UIView
                txt_chairNumber.leftViewMode = .always
            }
            
        }
        else if showRoom{
            img_alert.image = #imageLiteral(resourceName: "inRoomIcon")
            lbl_title.text = alertText
            txt_chairNumber.placeholder = "Room Number"
//            txt_chairNumber.keyboardType = .default
            if let roomNumber = Helper.getRoomNumber(), roomNumber != "" {
                txt_chairNumber.text = roomNumber
            }
            else {
                txt_chairNumber.text = ""
            }
            
        }
        
        else if showRoomForOrder{
            
            img_alert.image = #imageLiteral(resourceName: "inRoomIcon")
            lbl_title.text = alertText
            txt_chairNumber.placeholder = "Room Number"
            //            txt_chairNumber.keyboardType = .default
            txt_chairNumber.text = ""
            
        }
        
        // Do any additional setup after loading the view.
        
        if alreadyReserved && showChair{
            if let reserObj = reservationModel?.chair_number{
                let chairComponent = reserObj.components(separatedBy: "-")
                if chairComponent.count > 1{
                    txt_picker.text = chairComponent[0]
                    txt_chairNumber.text = chairComponent[1]
                }
            }
        }
        else if alreadyReserved && showRoom {
            if let reserObj = reservationModel?.room_number{
                    txt_chairNumber.text = reserObj
            }
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gesture.cancelsTouchesInView = false
        view_bg.addGestureRecognizer(gesture)
    }
    @objc func tapGesture() {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if showChair {
            if txt_chairNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.NO_CHAIR_NUMBER)
                return
            }
            if beachDining{
                chairDialog(pickerText: "")
            } else {
                if let pickerText = self.txt_picker.text {
                    chairDialog(pickerText: pickerText)
                }
            }
            
            
        }
        else if showRoom {
            if let str = txt_chairNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if str.characters.count > 0 {
                    checkRoomNumber(roomNumber: str, completion: { (status, message) in
                        if status {
                            if self.alreadyReserved{
                                if let model = self.reservationModel{
                                    model.room_number = str
                                    model.isModification = true
                                    self.delegate?.selectedRoom(model: model, controller: self)
                                }
                            }else{
                                if let model = self.reservationModel{
                                    model.room_number = str
                                    model.isModification = false
                                    self.delegate?.selectedRoom(model: model, controller: self)
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                Helper.showCancelDialog(title: ALERTSTRING.ERROR, message: message, viewController: self)
                            }
                        }
                    })
                }
                else{
                    return
                }
                }
            }
        
        else if showRoomForOrder{
            
            
            if let str = txt_chairNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if str.characters.count > 0 {
                    if let model = self.alohaOrderModel{
                        if let reserModel = self.reservationModel{
                            model.roomNumber = str
                            self.delegate?.fillRoom(alohaOrderModel: model, reservationModel: reserModel, controller: self)
                            
                        }
                    }
                }
                else{
                    return
                }
            }
            
            
        }
        
    }
    
    func chairDialog(pickerText:String){
        
        if let chairText = txt_chairNumber.text {
            let chair_num = beachDining ? chairText : pickerText.appending("-").appending(chairText)
            checkChairNumber(roomNumber: chair_num, completion: { (status, message) in
                if status {
                    if self.alreadyReserved{
                        if let model = self.reservationModel{
                            model.chair_number = chair_num
                            model.isModification = true
                            self.delegate?.selectedChair(model: model, controller: self)
                        }
                    }else{
                        if let model = self.reservationModel{
                            model.chair_number = chair_num
                            model.isModification = false
                            self.delegate?.selectedChair(model: model, controller: self)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Helper.showCancelDialog(title: ALERTSTRING.ERROR, message: message, viewController: self)
                    }
                }
            })
        }
    }
    func checkRoomNumber(roomNumber : String, completion : @escaping ((_ finished : Bool, _ message : String) -> Void)) {
        activateView(self.view, loaderText: LOADER_TEXT.loading)
        let obj = BusinessLayer()
        obj.checkRoomNumber(number: roomNumber, { (status, message) in
            DispatchQueue.main.async {
                self.deactivateView(self.view)
                completion(status, message)
            }
            
        })
        
    }
    func checkChairNumber(roomNumber : String, completion : @escaping ((_ finished : Bool, _ message : String) -> Void)) {
        activateView(self.view, loaderText: LOADER_TEXT.loading)
        let obj = BusinessLayer()
        obj.checkChairNumber(number: roomNumber, { (status, message) in
            DispatchQueue.main.async {
                self.deactivateView(self.view)
                completion(status, message)
            }
            
        })
        
    }
    func set(title : String , message : String, done_title : String ) {
        self.lbl_title.text = title
        self.btn_done.setTitle(done_title, for: .normal)
        self.btn_done.setTitleColor(UIColor.black, for: .normal)
        self.btn_done.backgroundColor = COLORS.THEME_YELLOW_COLOR
    }
    
}

extension SelectChairVC : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
//    MARK:Picker View delegates and datasources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerItems.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txt_picker.text = pickerItems[row]
    }
//    MARK:Textfield delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt_picker {
            txt_picker.text = pickerItems[pickerView.selectedRow(inComponent: 0)]
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if showChair {
            if textField == txt_chairNumber {
                let num = String(format: "%@%@", textField.text!,string)
                if num.characters.count > 4{
                    return false
                }
                else{
                    return true
                }
                
            }
        }

        return true
    }
}

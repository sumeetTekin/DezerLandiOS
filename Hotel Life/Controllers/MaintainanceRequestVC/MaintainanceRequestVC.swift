//
//  MaintainanceRequestVC.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 19/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class MaintainanceRequestVC: BaseViewController , AlertVCDelegate{
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var txt_maintenanceType: UITextField!
    @IBOutlet weak var txtv_commet: UITextView!
    @IBOutlet weak var btn_submit: UIButton!
    
    var servicesArray : [Service] = []
    var servicePicker : UIPickerView = UIPickerView()
    var titleBarText = ""
    var selectedMenu : Menu?
    var selectedService : Service?
    var keyboardHeight : CGFloat = 216
    var room_number : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Maintenance request screen", className: "MaintainanceRequestVC")

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = titleBarText
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
        servicePicker.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - keyboardHeight, width: Device.SCREEN_WIDTH, height: keyboardHeight)
        servicePicker.dataSource = self
        servicePicker.delegate = self
        servicePicker.showsSelectionIndicator = true
        self.txt_maintenanceType.inputView = servicePicker
        self.getServices(menu : selectedMenu!,{(services) in
            self.servicesArray = services
            DispatchQueue.main.async {
                self.servicePicker.reloadAllComponents()
            }
        })
        txtv_commet.text = PLACEHOLDER.addComment
        txtv_commet.textColor = UIColor.lightGray
        
    }
    @objc public func backAction(_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    func getServices(menu : Menu, _ completionHandler : @escaping ([Service]) -> Void){
        let bizObject = BusinessLayer()
        bizObject.getMaintenanceItems(menu: menu ,{ status, message, services in
            if status {
                if let array = services {
                        completionHandler(array)
                }
            }
            else{
                completionHandler([])
            }
            
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func validate() -> Bool {
        if txt_maintenanceType.text == "" {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.NO_TYPE)
            return false
        }
        else if txtv_commet.text == PLACEHOLDER.addComment || txtv_commet.text == "" {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.NO_COMMENT)
            return false
        }
        else{
            return true
        }
    }
    @IBAction func actionSubmit(_ sender: Any) {

        if !validate() {
            return
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        
        if txtv_commet.text == PLACEHOLDER.addComment {
            selectedService?.comment = ""
        }
        else{
            selectedService?.comment = txtv_commet.text
            txtv_commet.resignFirstResponder()
        }
        selectedService?.date = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM_SS, date: Date())
        selectedService?.room_number = self.room_number
        if let obj = selectedService {
            let bizObject = BusinessLayer()
            
            bizObject.submitMaintenanceRequest(obj: obj, { status, title, message in
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    self.showAlertWith(title: title, message: message)
                })
                
            })
        }
        
        
        
    }
    func showAlertWith(title : String, message : String) {
        let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
        objAlert.delegate = self
        
        self.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
        self.present(objAlert, animated: false) {
            
        }
    }
    func alertDismissed(){
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController is SubMenuVC{
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popToViewController(viewController, animated: true)
                })
                return
            }
        }
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objDashboard, animated: true)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MaintainanceRequestVC : UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate, UITextViewDelegate {
    // MARK: Picker View Delegates & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return servicesArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if servicesArray.count>0{
            return servicesArray[row].label
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < servicesArray.count {
            self.selectedService = servicesArray[row]
            self.txt_maintenanceType.text = servicesArray[row].label
        }
    }
    
//    MARK:Textfield delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt_maintenanceType {
            if servicePicker.selectedRow(inComponent: 0) < servicesArray.count {
                txt_maintenanceType.text = servicesArray[servicePicker.selectedRow(inComponent: 0)].label
                selectedService = servicesArray[servicePicker.selectedRow(inComponent: 0)]
            }
        }
        
    }
    
//    MARK:Textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PLACEHOLDER.addComment {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = PLACEHOLDER.addComment
            textView.textColor = UIColor.lightGray
        }
    }

}

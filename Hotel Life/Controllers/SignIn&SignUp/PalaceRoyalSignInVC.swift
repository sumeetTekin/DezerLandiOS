//
//  PalaceRoyalSignInVC.swift
//  Hotel Life
//
//  Created by Adil Mir on 11/13/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol PlaceRoyalDelegate{
    func continueAction(obj:RoyalPalace)
}
class PalaceRoyalSignInVC: BaseViewController {
    var pickerItems = [TITLE.owner,TITLE.tenant]
    @IBOutlet weak var idImageView: UIImageView!
    @IBOutlet weak var photoIdLbl: UILabel!
    
    @IBOutlet weak var TFunitNumber: MyTextField!
    @IBOutlet weak var TFtanetOwner: MyTextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let picker = UIPickerView()
    var userType:Int?
    var userRole = UserRole.tenant.rawValue
    var delegate : PlaceRoyalDelegate?
    let imageController = UIImagePickerController()
    var royalPalaceObj:RoyalPalace? = RoyalPalace()
    var titleBarText : String? = ""
    var loginType : LoginType = .normal
    var editProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        imageController.delegate = self
        imageController.allowsEditing = false
        setUpPicker()
        TFtanetOwner.text = pickerItems[0]
        self.royalPalaceObj?.userRole = UserRole.tenant.rawValue
        TFunitNumber.placeholder = PLACEHOLDER.unitNumber
        photoIdLbl.text = TITLE.residentPhotoId
        btnContinue.setTitle(BUTTON_TITLE.Continue, for: .normal)
        if editProfile{
            
            if let unitNumber = Helper.ReadUserObject()?.unitNumber{
                self.TFunitNumber.text = String(unitNumber)
                royalPalaceObj?.unitNo = unitNumber
            }
            if let userRole = Helper.ReadUserObject()?.userRole{
                self.TFtanetOwner.text = pickerItems[userRole - 1]
                self.userRole = userRole
                royalPalaceObj?.userRole = self.userRole
            }
            if let residentPhoto = Helper.ReadUserObject()?.residentPhoto{
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                let url = URL(string: residentPhoto)
                self.idImageView.sd_setImage(with: url, completed: nil)
                self.royalPalaceObj?.image = self.idImageView.image
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = titleBarText
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpPicker(){
        
        picker.delegate = self
        picker.dataSource = self
        TFtanetOwner.inputView = picker
    }
    
    func saveImageToDocumentDir(image: UIImage) -> URL
    {
        var returnFilePath: URL!
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = Helper.generateFileName(strExtention: "jpg")
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = UIImageJPEGRepresentation(image, 7.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
                returnFilePath = fileURL
            } catch {
                print("error saving file:", error)
            }
            
            return returnFilePath
        }
        return returnFilePath
    }
    
    func updateUser(updateUser:UserModel){
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.Updating)
        })
        let bizObject = BusinessLayer()
        bizObject.updateProfile(user: updateUser ,{ (status, message) in
            DispatchQueue.main.async(execute: {
              
                if status {
                    DispatchQueue.main.async(execute: {
                         self.uploadImageID()
                    })
                }
                else {
                    self.deactivateView(self.view)
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            })
        })
        
    }
    
    
    @IBAction func continueAction(_ sender: UIButton) {
        if let image = idImageView.image,image != UIImage(named: "loyality"){
            self.royalPalaceObj?.image = image
            if (TFunitNumber.text?.isEmpty)!{
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.enterUnitNumber)
                return
                
            }
            if (TFtanetOwner.text?.isEmpty)!{
                return
            }
            if self.royalPalaceObj?.image == nil {
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.selectImage)
                return
            }
            if editProfile{
                 let user:UserModel = AppInstance.applicationInstance.user!
                updateUser(updateUser: user)
            }else {
                 signUp()
            }
           
        } else {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.uploadPhoto)
            return
        }
    }
    
    //    MARK: API CALL
    func signUp() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.SigningIn)
        })
        
        let bizObject:BusinessLayer = BusinessLayer()
        bizObject.signUpNormal { (success, response) -> Void in
            
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.deactivateView(self.view)
                if(success) {
                    print(success)
                    UserDefaults.standard.set(self.loginType.rawValue, forKey: USERDEFAULTKEYS.LOGIN_TYPE)
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.uploadImageID()
                    })
                    
                }
                else {
                    Helper.DeleteUserObject()
                    Helper.printLog(response! as AnyObject?)
                    Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: response!, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                    })
                }
//            })
        }
    }
    
    func uploadImageID(){
        if let obj = self.royalPalaceObj{

            var dic = [String:Any]()
            dic["unitNumber"] = obj.unitNo
            dic["userRole"] = obj.userRole
            if let img = obj.image {
                let data = UIImageJPEGRepresentation(img, 0.7)
                BusinessLayer().uploadPhotoID(params: dic, file: data) { (success, message) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.deactivateView(self.view)
                   
                    if success{
                        print(message)
                        if self.editProfile{
                            self.RouteToDashboard()
                        } else {
                            self.RouteToThanksVC()
                        }
                        
                    }else{
                        Helper.DeleteUserObject()
                        Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                    }
                         })
                }
            }
        }
    }
    func RouteToThanksVC(){
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.THANKS) as! ThanksVC
       
            DispatchQueue.main.async(execute: { () -> Void in
                self.navigationController?.pushViewController(objDashboard, animated: true)
           })
        
    }
    func RouteToDashboard(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller is BaseTabBarVC {
                DispatchQueue.main.async(execute: {
                    self.navigationController!.popToViewController(controller, animated: true)
                })
                break
            }
        }
       
    }
//    func navigateToQuestions(userType:Int,obj:RoyalPalace?){
//        self.getQuestions(completion: { questions in
//            let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SignUpQuestionsVC") as! SignUpQuestionsVC
//            objUpgrade.questionArray = questions
//            objUpgrade.userType = userType
//            if let object = obj{
//                objUpgrade.objRoyalPalace = object
//            }
//            DispatchQueue.main.async(execute: {
//                self.deactivateView(self.view)
//                self.navigationController?.pushViewController(objUpgrade, animated: true)
//            })
//        })
//    }
//
//    func getQuestions (completion : @escaping ([SignupQuestion]) -> Void) {
//        let bizObject:BusinessLayer=BusinessLayer()
//        bizObject.getQuestionary({(status, signupQuestions) in
//
//            if status == true {
//                completion(signupQuestions!)
//            }
//            else{
//                completion([])
//            }
//        })
//
//    }
    
    @IBAction func uploadImage(_ sender: UIButton) {
        let alertController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "Camera", style: .default, handler: {action in
            self.selectImageFromSource(.camera)
        })
        alertController.addAction(actionCamera)
        
        let actionPhoto = UIAlertAction(title: "Photos", style: .default, handler: {action in
            self.selectImageFromSource(.photoLibrary)
            
        })
        alertController.addAction(actionPhoto)
        
        let actionCancel = UIAlertAction(title: BUTTON_TITLE.Cancel, style: .destructive, handler: { action in
            
        })
        alertController.addAction(actionCancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectImageFromSource(_ source : UIImagePickerControllerSourceType) {
        
        if source == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imageController.sourceType = .camera
            }
            else{
                DispatchQueue.main.async(execute: {
                    Helper.showAlert(sender: self, title: "Error", message: ERRORMESSAGE.CAMERA_NOT_AVAILABLE)
                })
                
                return
            }
        }
        else if source == .photoLibrary {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imageController.sourceType = .photoLibrary
            }
            else{
                DispatchQueue.main.async(execute: {
                    Helper.showAlert(sender: self, title: "Error", message: ERRORMESSAGE.PHOTOS_NOT_AVAILABLE)
                })
                
                return
            }
        }
        else {
            return
        }
        
        self.present(imageController, animated: true, completion: nil)
        
    }
    
}
extension PalaceRoyalSignInVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] {
            self.idImageView.image = image as? UIImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension PalaceRoyalSignInVC:UIPickerViewDelegate,UIPickerViewDataSource{
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
        TFtanetOwner.text = pickerItems[row]
        userRole = row + 1
    }
}

extension PalaceRoyalSignInVC:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.TFtanetOwner{
                textField.text = pickerItems[picker.selectedRow(inComponent: 0)]
                self.userRole = picker.selectedRow(inComponent: 0) + 1
            
            royalPalaceObj?.userRole = self.userRole
        } else if textField == self.TFunitNumber{
            if !(textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!{
                royalPalaceObj?.unitNo = Int(textField.text!)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.TFunitNumber {
            let num = String(format: "%@%@", textField.text!,string)
            if num.characters.count > 4{
                return false
            }
            else{
                return true
            }
            
        }
        return true
    }
}

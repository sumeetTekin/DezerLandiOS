//
//  SignUpVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import MRCountryPicker
class SignUpVC: BaseViewController{
    
    @IBOutlet weak var txt_fname: MyTextField!
    @IBOutlet weak var txt_lname: MyTextField!
    @IBOutlet weak var txt_email: MyTextField!
    @IBOutlet weak var txt_phoneNumber: MyTextField!
    @IBOutlet weak var txt_birthday: MyTextField!
    @IBOutlet weak var txt_anniversary: MyTextField!
    @IBOutlet weak var txt_city: MyTextField!
    @IBOutlet weak var txt_country: MyTextFieldAsButton!
    
    //Paritosh -- Adding new field for Guest/Resident
    @IBOutlet weak var txt_guestResident: MyTextFieldAsButton!
    
    @IBOutlet weak var txt_defaultLanguage: MyTextField!
    @IBOutlet weak var txt_password: MyTextField!
    @IBOutlet weak var txt_confirm_password: MyTextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextButtonYposConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonHeightConstraint: NSLayoutConstraint!
    
    var facebookUserModel : UserModel?
    
    var isEditingProfile = false
    var countriesList : [CountryModel] = []
    
    
    var countryPickerView : UIPickerView = UIPickerView()
    var languagePicker : UIPickerView = UIPickerView()
    var guestPicker : UIPickerView = UIPickerView()
    var languageArray : [Language] = []
    var guestArray : [String] = [TITLE.hotelGuest,TITLE.trumpRoyaleResident,TITLE.trumpPalaceResident]
    var userType = 1
    
    var birthdayPickerView : DateMonthPicker = DateMonthPicker()
    var anniversaryPickerView : DateMonthPicker = DateMonthPicker()
    
    var phoneButton: UIButton?
    var flagTextField : UITextField?
    var countryCodeLabel : UILabel?
    var countryPicker = MRCountryPicker()
    var keyboardHeight : CGFloat = 216
    var selectedLanguage : Language?
    var leftViewLanguage = UIView()
    var langImage = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "Sign Up")
        Helper.logScreen(screenName: "Signup screen", className: "SignUpVC")
        
        // Do any additional setup after loading the view.
        countryPicker.countryPickerDelegate = self
        self.phoneFieldSetup()
        self.setupLanguages()
        self.layoutSetup()
        
        leftViewLanguage = UIView(frame: CGRect(x: 0, y: 0, width: txt_defaultLanguage.frame.height + 5, height: txt_defaultLanguage.frame.height))
        leftViewLanguage.backgroundColor = .clear
        langImage = UIImageView(frame: CGRect(x: 10, y: 5, width: txt_defaultLanguage.frame.height - 15, height: txt_defaultLanguage.frame.height - 10))
        langImage.contentMode = .scaleAspectFit
        leftViewLanguage.addSubview(langImage)
        if let userType = Helper.ReadUserObject()?.userType {
            txt_guestResident.text = guestArray[userType - 1]
            self.userType = userType
            //txt_guestResident.isEnabled = false
        }
        else {
            txt_guestResident.text = self.guestArray.first
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txt_defaultLanguage.leftView = leftViewLanguage
        txt_defaultLanguage.leftViewMode = .always
        if let language = selectedLanguage {
            self.changeToLanguage(language)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func layoutSetup(){
        txt_fname.requiredField()
        txt_lname.requiredField()
        txt_email.requiredField()
        txt_password.requiredField()
        txt_confirm_password.requiredField()
        txt_birthday.placeholder = PLACEHOLDER.birthday
        txt_anniversary.placeholder = PLACEHOLDER.anniversary
        let user = AppInstance.applicationInstance.user
        if isEditingProfile {
            nextBtn.setTitle(BUTTON_TITLE.Update, for: .normal)
            if let fullName = user?.name {
                txt_fname.text = fullName.components(separatedBy: " ").first
                txt_lname.text = fullName.components(separatedBy: " ").last
            }
            
            txt_email.text = user?.email
            txt_phoneNumber.text = user?.mobile_number
            txt_phoneNumber.text = self.formattedNumber(number: txt_phoneNumber.text!)
            if let birthDate = user?.birthday{
                if birthDate != "" {
                    if birthDate != " "{
                        let date = Helper.getDateFromString(string: birthDate, formatString: "MMMM dd")
                        birthdayPickerView.setDate(date, animated: true)
                        txt_birthday.text = birthdayPickerView.getDateString()
                    }
                }
            }
            if let anniversaryDate = user?.anniversary{
                if anniversaryDate != "" {
                    if anniversaryDate != " "{
                        let date = Helper.getDateFromString(string: anniversaryDate, formatString: "MMMM dd")
                        anniversaryPickerView.setDate(date, animated: true)
                        txt_anniversary.text = anniversaryPickerView.getDateString()
                    }
                }
            }
            txt_city.text = user?.city
            
            if let lang = user?.default_language{
                txt_defaultLanguage.text = Helper.getLangForCode(lang)
            }
            
            txt_country.text = user?.country
            txt_password.text = ""
            if user?.country_code == ""{
                countryCodeLabel?.text = "+1"
            }else{
                countryCodeLabel?.text = user?.country_code
            }
            if user?.country == "United States"{
                countryPicker.setCountryByName((user?.country)!)
            }else{
                if let countryText = countryCodeLabel?.text{
                    countryPicker.setCountryByPhoneCode((countryText))
                }
            }
           // nextButtonYposConstraint.constant = 12
        }else{
            nextBtn.setTitle(BUTTON_TITLE.Next, for: .normal)
            //nextButtonYposConstraint.constant = 141
        }
        nextButtonHeightConstraint.constant = 40
        
        if facebookUserModel != nil {
            if let fullName = facebookUserModel?.name {
                txt_fname.text = fullName.components(separatedBy: " ").first
                txt_lname.text = fullName.components(separatedBy: " ").last
            }
            //            txt_name.text = facebookUserModel?.name
            txt_email.text = facebookUserModel?.email
            txt_birthday.text = facebookUserModel?.birthday
        }
        
        if facebookUserModel != nil || isEditingProfile{
            txt_password.isHidden = true
            txt_confirm_password.isHidden = true
        }else{
            txt_password.isHidden = false
            txt_confirm_password.isHidden = false
        }
        
        
        countryPickerView.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - keyboardHeight, width: Device.SCREEN_WIDTH, height: keyboardHeight)
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.showsSelectionIndicator = true
        self.txt_country.inputView = countryPickerView
        self.getCountries(completion: { (countryArray) in
            self.countriesList = countryArray
            DispatchQueue.main.async(execute: {
                self.countryPickerView.reloadAllComponents()
            })
            
        })
        //Guest Picker
        guestPicker.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - keyboardHeight, width: Device.SCREEN_WIDTH, height: keyboardHeight)
        guestPicker.dataSource = self
        guestPicker.delegate = self
        guestPicker.showsSelectionIndicator = true
        guestPicker.tag = 1000
        DispatchQueue.main.async(execute: {
            self.guestPicker.reloadAllComponents()
        })
        self.txt_guestResident.inputView = guestPicker
        self.guestPicker.reloadAllComponents()
        birthdayPickerView.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - keyboardHeight, width: Device.SCREEN_WIDTH, height: keyboardHeight)
        self.txt_birthday.inputView = birthdayPickerView
        
        anniversaryPickerView.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - keyboardHeight, width: Device.SCREEN_WIDTH, height: keyboardHeight)
        self.txt_anniversary.inputView = anniversaryPickerView
        
        //Country Picker
        countryPicker.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - keyboardHeight, width: Device.SCREEN_WIDTH, height: keyboardHeight)
        countryPicker.countryPickerDelegate = self
        countryPicker.showsSelectionIndicator = true
        if isEditingProfile{
            if let phoneCode = countryCodeLabel?.text{
                if user?.country == "United States" && phoneCode == "+1"{
                    countryPicker.setCountryByName("United States")
                }else{
                    countryPicker.setCountryByPhoneCode(phoneCode)
                }
            }else{
                countryPicker.setCountryByName("United States")
            }
        }else{
            countryPicker.setCountryByName("United States")
        }
    }
    func setupLanguages(){
        if let englishLanguage = Language(languageKey : LANGUAGE_KEY.ENGLISH, languageTitle : ALERTSTRING.LANGUAGE_ENGLISH, languageCode : LANGUAGE_CODE.ENGLISH, languageImage : #imageLiteral(resourceName: "flag_us")) {
            
            self.languageArray.append(englishLanguage)
        }
        if let spanishLanguage = Language(languageKey : LANGUAGE_KEY.SPANISH, languageTitle : ALERTSTRING.LANGUAGE_SPANISH, languageCode : LANGUAGE_CODE.SPANISH, languageImage : #imageLiteral(resourceName: "flag_sp")) {
            
            self.languageArray.append(spanishLanguage)
        }
        if let portugueseLanguage = Language(languageKey : LANGUAGE_KEY.PORTUGESE, languageTitle : ALERTSTRING.LANGUAGE_PORTUGUESE, languageCode : LANGUAGE_CODE.PORTUGESE_BRAZIL, languageImage : #imageLiteral(resourceName: "flag_br")) {
            
            self.languageArray.append(portugueseLanguage)
        }
        if let russianLanguage = Language(languageKey : LANGUAGE_KEY.RUSSIAN, languageTitle : ALERTSTRING.LANGUAGE_RUSSIAN, languageCode : LANGUAGE_CODE.RUSSIAN, languageImage : #imageLiteral(resourceName: "flag_ru")){
            
            self.languageArray.append(russianLanguage)
        }
        languagePicker.frame = CGRect(x: 0, y: Device.SCREEN_HEIGHT - keyboardHeight, width: Device.SCREEN_WIDTH, height: keyboardHeight)
        languagePicker.dataSource = self
        languagePicker.delegate = self
        languagePicker.showsSelectionIndicator = true
        languagePicker.tag = 999
        self.txt_defaultLanguage.inputView = languagePicker
        let user = AppInstance.applicationInstance.user
        for language in languageArray {
            if language.languageCode == user?.default_language{
                selectedLanguage = language
            }
        }
        if selectedLanguage == nil {
            selectedLanguage = languageArray.first
        }
    }
    func phoneFieldSetup(){
        let leftPaddingView = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: txt_phoneNumber.frame.size.height))
        leftPaddingView.backgroundColor = .clear
        phoneButton = UIButton(type: .custom)
        phoneButton?.frame = CGRect(x: 10, y: 10, width: 20, height: txt_phoneNumber.frame.size.height - 20)
        phoneButton?.backgroundColor = .white
        self.phoneButton?.setImage(UIImage(named: "SwiftCountryPicker.bundle/Images/US.png", in: Bundle(for: MRCountryPicker.self), compatibleWith: nil), for: .normal)
        leftPaddingView.addSubview(phoneButton!)
        
        countryCodeLabel =  UILabel(frame: CGRect(x: 35, y: 0, width: 40, height: txt_phoneNumber.frame.size.height))
        countryCodeLabel?.font = Helper.setFont(fontName: FONT_NAME.FONT_REGULAR, fontSize: 14.0)
        countryCodeLabel?.textAlignment = .center
        if let countryCode = AppInstance.applicationInstance.user?.country_code{
            if countryCode.count > 0{
                countryCodeLabel?.text = AppInstance.applicationInstance.user?.country_code
            }else{
                countryCodeLabel?.text = "+1"
            }
        }else{
            countryCodeLabel?.text = "+1"
        }
        leftPaddingView.addSubview(countryCodeLabel!)
        
        flagTextField = UITextField(frame: CGRect(x: -10, y: 0, width: 90, height: txt_phoneNumber.frame.size.height))
        flagTextField?.inputView = countryPicker
        leftPaddingView.addSubview(flagTextField!)
        txt_phoneNumber.leftView = leftPaddingView
        txt_phoneNumber.leftViewMode = .always
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if validate() {
            
            if isEditingProfile {
                let updateUser:UserModel = AppInstance.applicationInstance.user!
                
                updateUser.name = getFullName()
                updateUser.firstName = txt_fname.text
                updateUser.lastName = txt_lname.text
                updateUser.email = txt_email.text
                if txt_phoneNumber.text == ""{
                    updateUser.country_code = ""
                }
                updateUser.mobile_number = removeSpecialCharsFromString(txt_phoneNumber.text!)
                updateUser.birthday = birthdayPickerView.getDateString()
                updateUser.anniversary = anniversaryPickerView.getDateString()
                updateUser.city = txt_city.text
                updateUser.country = txt_country.text
                updateUser.default_language = AppInstance.applicationInstance.user?.default_language
                
                if let userType = Helper.ReadUserObject()?.userType,userType == self.userType{
                     updateUser.userType = self.userType
                    DispatchQueue.main.async {
                        self.updateUser(updateUser: updateUser)
                    }
                    
                } else {
                     updateUser.userType = self.userType
                    if self.userType == UserType.hotelGuest.rawValue{
                        
                        self.navigateToQuestions(userType: self.userType, editPropile: true)
                        
                        
                    } else {
                        self.navigateToPlaceRoyal(editProfile: true)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.activateView(self.view, loaderText: LOADER_TEXT.loading)
                    self.checkIfEmailAlreadyExist(emailStr: self.txt_email.text!)
                }
                    
            }
        }
        
    }
    
    func removeSpecialCharsFromString(_ str: String) -> String {
        struct Constants {
            static let validChars = Set("1234567890".characters)
        }
        return String(str.characters.filter { Constants.validChars.contains($0) })
    }
    
    func updateUser(updateUser:UserModel){
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.Updating)
        }
        
        let bizObject = BusinessLayer()
        bizObject.updateProfile(user: updateUser ,{ (status, message) in
            DispatchQueue.main.async(execute: {
                self.deactivateView(self.view)
                if status {
                    Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: message, buttonTitles: [BUTTON_TITLE.Continue], completion: { message in
                        DispatchQueue.main.async(execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                }
                else {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            })
        })

    }
    
    func getFullName() -> String {
        var fullname = ""
        if let firstname = txt_fname.text {
            fullname = fullname.appending(firstname)
            fullname = fullname.appending(" ")
        }
        if let lastname = txt_lname.text {
            fullname = fullname.appending(lastname)
        }
        return fullname
    }
    
    func validate() -> Bool {
        if (txt_fname.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! <= 0 {
            Helper.showAlertWithAction(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.VALID_NAME, { (action) in
                self.txt_fname.becomeFirstResponder()
            })
            return false
        }else if (txt_lname.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! <= 0 {
            Helper.showAlertWithAction(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.VALID_NAME, { (action) in
                self.txt_lname.becomeFirstResponder()
            })
            return false
        }else if !(txt_email.text?.isValidEmail())! {
            Helper.showAlertWithAction(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.VALID_EMAIL, { (action) in
                self.txt_email.becomeFirstResponder()
            })
            return false
        }else if txt_password.isHidden == false && isEditingProfile == false {
            if (txt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! < 6 {
                Helper.showAlertWithAction(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.VALID_PASSWORD_LEAST, { (action) in
                    self.txt_password.becomeFirstResponder()
                })
                return false
            }
            if txt_password.text != txt_confirm_password.text{
                Helper.showAlertWithAction(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.CONFIRM_PASSWORD_NOTMATCHING, { (action) in
                    self.txt_confirm_password.becomeFirstResponder()
                })
                return false
            }
        }
        return true
    }
    
    func selectPickerRowForCountry(countryStr: String){
        var i = 0
        for country in self.countriesList{
            if country.name == countryStr{
                break
            }
            i = i + 1
        }
        self.countryPickerView.selectRow(i, inComponent: 0, animated: true)
    }
    func selectPickerRowForLanguage(language : Language){
        if languageArray.contains(language) {
            if let index = languageArray.index(of: language) {
                self.languagePicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
        
    }
    
    private func changeToLanguage(_ language: Language) {
        
        AppInstance.applicationInstance.user?.default_language = Helper.getCodeForLang(language.languageKey)
        switch language.languageKey {
        case LANGUAGE_KEY.ENGLISH:
            txt_defaultLanguage.text = ALERTSTRING.LANGUAGE_ENGLISH
        case LANGUAGE_KEY.SPANISH:
            txt_defaultLanguage.text = ALERTSTRING.LANGUAGE_SPANISH
        case LANGUAGE_KEY.PORTUGESE:
            txt_defaultLanguage.text = ALERTSTRING.LANGUAGE_PORTUGUESE
        case LANGUAGE_KEY.RUSSIAN:
            txt_defaultLanguage.text = ALERTSTRING.LANGUAGE_RUSSIAN
        default:
            txt_defaultLanguage.text = ALERTSTRING.LANGUAGE_ENGLISH
            break
        }
        setupLanguageField(language: language)
        
    }
    func setupLanguageField(language : Language) {
        langImage.image = language.image
        //        txt_defaultLanguage.leftView = leftViewLanguage
        //        txt_defaultLanguage.leftViewMode = .always
    }
    
    // MARK: - Web-Service Calling
    func checkIfEmailAlreadyExist (emailStr : String) {
        
        let bizObject:BusinessLayer=BusinessLayer()
        bizObject.getEmailIfAlreadyExists(email: emailStr,{(status, message) in
            if status {
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    Helper.showAlertWithAction(sender: self, title: ALERTSTRING.ERROR, message: message ?? "This email ID is already registered.", { (action) in
                        self.txt_email.becomeFirstResponder()
                    })
                })
            }else{
                DispatchQueue.main.async {
                    Helper.hideLoader()
                    AppInstance.applicationInstance.user?.userType = self.userType
                    if self.userType == UserType.hotelGuest.rawValue{
                          self.activateView(self.view, loaderText: LOADER_TEXT.loading)
                          self.navigateToQuestions(userType: self.userType, editPropile: false)
                    } else {
                        self.navigateToPlaceRoyal(editProfile: false)
                    }
                }
                
            }
        })
    }
    
    func navigateToQuestions(userType:Int,editPropile:Bool){
//        DispatchQueue.main.async {
//            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
//        }
        
        self.getQuestions(completion: { questions in
            
            DispatchQueue.main.async {
                
                if questions.count != 0{
                    Helper.hideLoader()
                    let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SignUpQuestionsVC") as! SignUpQuestionsVC
                    objUpgrade.questionArray = questions
                    objUpgrade.userType = userType
                    objUpgrade.editProfile = editPropile
                    self.deactivateView(self.view)
                    self.navigationController?.pushViewController(objUpgrade, animated: true)
                }else{
                    if editPropile == true{
                        let user = AppInstance.applicationInstance.user!
                        self.updateUser(updateUser: user)
                    }else{
                        self.signUp()
                    }
                    
                }
                
            }
        })
    }
    
    
    //    MARK: API CALL
    func signUp() {
        
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.SigningIn)
        }
        
        let bizObject:BusinessLayer = BusinessLayer()
        bizObject.signUpNormal { (success, response) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if(success) {
                    print(success)
                    UserDefaults.standard.set(LoginType.normal.rawValue, forKey: USERDEFAULTKEYS.LOGIN_TYPE)
                    UserDefaults.standard.synchronize()
                    self.RouteToThanksVC()
                }
                else {
                    Helper.DeleteUserObject()
                    Helper.printLog(response! as AnyObject?)
                    Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: response!, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                    })
                }
            })
        }
    }
    
    
    
    
    
    
    func RouteToThanksVC(){
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.THANKS) as! ThanksVC
            self.navigationController?.pushViewController(objDashboard, animated: true)
    }

    
    
    
    func navigateToPlaceRoyal(editProfile:Bool){
        DispatchQueue.main.async{
            let controller = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PalaceRoyalSignInVC") as! PalaceRoyalSignInVC
            controller.editProfile = editProfile
            controller.titleBarText = self.guestArray[self.userType - 1]
             self.deactivateView(self.view)
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
    }
    
    func getCountries (completion : @escaping ([CountryModel]) -> Void) {
        let bizObject:BusinessLayer=BusinessLayer()
        bizObject.getCountries({(status, countries) in
            if status == true {
                completion(countries!)
            }else{
                completion([])
            }
        })
    }
    
    func getQuestions (completion : @escaping ([SignupQuestion]) -> Void) {
        let bizObject:BusinessLayer=BusinessLayer()
        bizObject.getQuestionary({(status, signupQuestions) in
            
            if status == true {
                completion(signupQuestions!)
            }
            else{
                completion([])
            }
        })
        
    }
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask.characters {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
}

extension SignUpVC : UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MRCountryPickerDelegate {
    
    //MARK: UITextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == txt_defaultLanguage {
            if let lang = selectedLanguage{
                self.selectPickerRowForLanguage(language: lang)
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if textField == txt_country {
            if let country = txt_country.text{
                if country.count>0{
                    self.selectPickerRowForCountry(countryStr: country)
                }else{
                    self.selectPickerRowForCountry(countryStr: "United States")
                }
            }
        }
        else if textField == txt_defaultLanguage {
            if let language = selectedLanguage {
                self.changeToLanguage(language)
            }
            
        }
        else if textField == txt_birthday {
            if let dateStr = textField.text{
                let date = Helper.getDateFromString(string: dateStr, formatString: "MMMM dd")
                birthdayPickerView.setDate(date, animated: true)
                if !isEditingProfile {
                    AppInstance.applicationInstance.user?.birthday = txt_birthday.text
                }
            }
        }
        else if textField == txt_anniversary{
            if let dateStr = textField.text{
                let date = Helper.getDateFromString(string: dateStr, formatString: "MMMM dd")
                anniversaryPickerView.setDate(date, animated: true)
                if !isEditingProfile {
                    AppInstance.applicationInstance.user?.anniversary = txt_anniversary.text
                }
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txt_fname {
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.name = getFullName()
                AppInstance.applicationInstance.user?.firstName = txt_fname.text
            }
        }
        if textField == txt_lname {
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.name = getFullName()
                AppInstance.applicationInstance.user?.lastName = txt_lname.text
            }
        }
        else if textField == txt_email {
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.email = txt_email.text
            }
        }
        else if textField == txt_phoneNumber {
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.mobile_number = txt_phoneNumber.text
            }
        }
        else if textField == txt_birthday {
            let dateStr = birthdayPickerView.getDateString()
            self.txt_birthday.text = dateStr
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.birthday = birthdayPickerView.getDateString()
            }
        }
        else if textField == txt_anniversary {
            let dateStr = anniversaryPickerView.getDateString()
            self.txt_anniversary.text = dateStr
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.anniversary = anniversaryPickerView.getDateString()
            }
        }
        else if textField == txt_city {
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.city = txt_city.text
            }
        }
        else if textField == txt_country {
            if countryPickerView.selectedRow(inComponent: 0) < countriesList.count {
                txt_country.text = countriesList[countryPickerView.selectedRow(inComponent: 0)].name
            }
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.country = txt_country.text
            }
        }
        else if textField == txt_password {
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.password = txt_password.text
            }
            UserDefaults.standard.set(txt_password.text, forKey: USERDEFAULTKEYS.PASSWORD)
        }else if textField ==  txt_confirm_password{
            if !isEditingProfile {
                AppInstance.applicationInstance.user?.confirm_password = txt_confirm_password.text
            }
        }
        else if textField == txt_defaultLanguage {
            if let language = selectedLanguage {
                self.changeToLanguage(language)
            }
        }
        else if textField == txt_guestResident{
            txt_guestResident.text = guestArray[guestPicker.selectedRow(inComponent: 0)]
            self.userType = guestPicker.selectedRow(inComponent: 0) + 1
            AppInstance.applicationInstance.user?.userType = self.userType
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        else if textField == txt_phoneNumber{
            txt_phoneNumber.text = self.formattedNumber(number: String.init(format: "%@%@", txt_phoneNumber.text!,string))
            return false
        }
        else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
        
    }
    
    // MARK: Picker View Delegates & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 999 {
            return languageArray.count
        }
        else if pickerView.tag == 1000 {
            return guestArray.count
        }
        else{
            return countriesList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView.tag == 999 {
            let customView = LanguageView(language: languageArray[row], frame: CGRect(x: 0, y: 0, width: Device.SCREEN_WIDTH, height: 35))
            return customView
        }
        else if pickerView.tag == 1000{
            let label : UILabel = UILabel()
            label.textAlignment = .center
            if guestArray.count>0{
                label.text = guestArray[row]
            }
            else{
                label.text = ""
            }
            return label
        }
        else{
            let label : UILabel = UILabel()
            label.textAlignment = .center
            if countriesList.count>0{
                label.text = countriesList[row].name
            }
            else{
                label.text = ""
            }
            return label
        }
    }
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        if pickerView.tag == 999 {
    //            if languageArray.count > 0 {
    //                return languageArray[row].languageTitle
    //            }
    //            return ""
    //        }
    //        else{
    //            if countriesList.count>0{
    //                return countriesList[row].name
    //            }
    //            return ""
    //        }
    //    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 999 {
            selectedLanguage = languageArray[row]
            self.changeToLanguage(selectedLanguage!)
        }
        else if pickerView.tag == 1000 {
            if row < guestArray.count {
                self.txt_guestResident.text = guestArray[row]
                self.userType = row + 1
            }
        }
        else{
            if row < countriesList.count {
                self.txt_country.text = countriesList[row].name
            }
        }
    }
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        DispatchQueue.main.async(execute: {
            AppInstance.applicationInstance.user?.country_code = phoneCode
            self.countryCodeLabel?.text = AppInstance.applicationInstance.user?.country_code
            self.phoneButton?.setImage(flag, for: .normal)
        })
    }
    
}

//
//  BusinessLayer.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import Foundation

@objc class BusinessLayer: NSObject {
    
    var commMgr:CommunicationManager
    var title = ""
    var message = "Server error."
    override init() {
        commMgr = CommunicationManager()
    }
    //    MARK: User account related
    
    func updateUserDetails(userModel : UserModel) {
        //        Update user details in user model and save it in user defaults
        AppInstance.applicationInstance.user = userModel
        AppInstance.applicationInstance.userLoggedIn = true
        UserDefaults.standard.setValue(AppInstance.applicationInstance.userLoggedIn, forKey: USERDEFAULTKEYS.ALREADY_LOGIN)
        UserDefaults.standard.synchronize()
        Helper.SaveUserObject(userModel)
    }
    func setAuthToken(dict : NSDictionary) {
        //        Set auth token
        if let data = dict["data"] as? [String: Any], let token = data["token"] as? String {
            AppInstance.applicationInstance.auth_token = token
        }
    }
    
    func signUpNormal(_ completionHandler:@escaping (_ success:Bool,_ errorMessage:String?) -> Void) {
        // basic signup process without facebook
        if let tempUser = AppInstance.applicationInstance.user
        {
            let dict = tempUser.dictionaryRepresentation()
            print(dict)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.SIGNUP_URL, jsonString: jsonString ,completionHandler: { (success, responseString) -> Void in
                    
                    if(success) {
                        guard let data = responseString.data(using: .utf8)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let msg = dict.value(forKey: "message") as? String{
                            self.message = msg
                        }
                        
                        var tempUser : UserModel?
                        var tempData : SignInData?
                        guard let signUpData = dict["data"] as? NSDictionary
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        /*guard let imagesPath = dict["imagesPath"] as? String
                            else {
                                completionHandler(false, self.message)
                                return
                        }*/
                        tempData = SignInData(dictionary: signUpData)
                        tempUser =  UserModel(dictionary: signUpData["user"] as! NSDictionary, imagePath : nil)
                        if tempUser != nil{
                            tempUser?.password = UserDefaults.standard.value(forKey: USERDEFAULTKEYS.PASSWORD) as? String
                            self.setAuthToken(dict: dict)
                            self.updateUserDetails(userModel: tempUser!)
                            completionHandler(true, self.message)
                        }
                        else{
                            completionHandler(false, self.message)
                        }
                    }else{
                        // remove user model if any
                        Helper.DeleteUserObject()
                        UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.ALREADY_LOGIN)
                        UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.PASSWORD)
                        UserDefaults.standard.synchronize()
                        
                        completionHandler(false, responseString)
                    }
                })
                
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
    }
    
    func loginNormal(_ completionHandler:@escaping (_ success:Bool, _ response: String?) -> Void) {
        // login without facebook
        if let tempUser = AppInstance.applicationInstance.user
        {
            let dict = tempUser.dictionaryRepresentation()
            print(dict)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                commMgr.POST(api: API.GUEST_LOGIN_URL, jsonString: jsonString,completionHandler: { (success, response) -> Void in
                    
                    if(success) {
                        var tempUser : UserModel?
                        var tempData : SignInData?
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let msg = dict.value(forKey: "message") as? String{
                            self.message = msg
                        }
                        guard let signInData = dict["data"] as? NSDictionary
                            else {
                                completionHandler(false, self.message)
                                return
                        }
                        /*guard let imagesPath = dict["imagesPath"] as? String
                            else {
                                completionHandler(false, self.message)
                                return
                        }*/
                        tempData = SignInData(dictionary: signInData)
                        tempUser =  UserModel(dictionary: signInData["user"] as! NSDictionary, imagePath : "")
                        if tempUser != nil{
                            tempUser?.password = UserDefaults.standard.value(forKey: USERDEFAULTKEYS.PASSWORD) as? String
                          
                            self.setAuthToken(dict: dict)
                            self.updateUserDetails(userModel: tempUser!)
                            if let lang = tempUser?.default_language {
                                Helper.setAppLanguage(lang)
                            }
                            completionHandler(true, self.message)
                        }
                    }else{
                        Helper.DeleteUserObject()
                        UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.ALREADY_LOGIN)
                        UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.PASSWORD)
                        UserDefaults.standard.synchronize()
                        completionHandler(false, response)
  
                    }
                })
                
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
        
    }
    
    func loginFacebook(_ completionHandler:@escaping (_ success : Bool, _ message : String,_ response : NSMutableDictionary?)-> Void) {
        //facebook login
        
        // get facebook user model stored in applicationInstance
        if let tempUser = AppInstance.applicationInstance.user
        {
            
            if let id = tempUser.facebook_id {
                
                var dict : [String : Any] = [:]
                dict["facebook"] = id
                dict["email"] = tempUser.email
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    
                    commMgr.POST(api: API.CHECKFACEBOOK_URL, jsonString: jsonString,completionHandler: { (success, response) -> Void in
                        
                        if(success) {
                            guard let data = response.data(using: .utf8)
                                else{
                                    completionHandler(true, ERRORMESSAGE.NO_RESPONSE,[:])
                                    return
                            }
                            
                            guard let dict = self.getResponseDictionary(data)
                                else{
                                    completionHandler(true, ERRORMESSAGE.NO_RESPONSE,[:])
                                    return
                            }
                            if let msg = dict.value(forKey: "message") as? String{
                                self.message = msg
                            }
                            var tempUser : UserModel?
                            var tempData : SignInData?
                            
                            guard let signInData = dict["data"] as? NSDictionary
                                else {
                                    completionHandler(false, self.message, [:])
                                    return
                            }
//                            guard let imagesPath = dict["imagesPath"] as? String
//                                else {
//                                    completionHandler(false, self.message, [:])
//                                    return
//                            }
                            tempData = SignInData(dictionary: signInData)
                            tempUser =  UserModel(dictionary: signInData["user"] as! NSDictionary, imagePath : "")
                            if tempUser != nil
                            {
                                self.setAuthToken(dict: dict)
                                self.updateUserDetails(userModel: tempUser!)
                                
                                // if user has selected any default language earlier user that language in app
                                if let lang = tempUser?.default_language {
                                    Helper.setAppLanguage(lang)
                                }
                                completionHandler(true, self.message,nil)
                            }else{
                                Helper.DeleteUserObject()
                            }
                        }else{
                            Helper.DeleteUserObject()
                            completionHandler(false, response,[:])
                            
                        }
                    })
                    
                } catch {
                    Helper.printLog(error.localizedDescription as AnyObject?)
                }
            }
            else{
                Helper.DeleteUserObject()
                completionHandler(false, ALERTSTRING.ERROR,[:])
            }
            
        }
        
    }
    
    
    func forgotPassword(_ completionHandler:@escaping (_ success : Bool, _ message : String)-> Void) {
        if let tempUser = AppInstance.applicationInstance.user{
            let dict = ["email":tempUser.email!]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                commMgr.GET(api: API.FORGOT_URL+tempUser.email!) { (success, response) in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let msg = dict.value(forKey: "msg") as? String{
                            self.message = msg
                        }
                        completionHandler(true, self.message)
                    }else{
                        completionHandler(false, response)
                    }
                }
                
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
        
    }
    
    
    
   /* func forgotPassword(_ completionHandler:@escaping (_ success : Bool, _ message : String)-> Void) {
        if let tempUser = AppInstance.applicationInstance.user{
            let dict = ["email":tempUser.email!]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.FORGOT_URL, jsonString: jsonString,completionHandler: { (success, response) -> Void in
                    
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let msg = dict.value(forKey: "msg") as? String{
                            self.message = msg
                        }
                        completionHandler(true, self.message)
                    }else{
                        completionHandler(false, response)
                    }
                })
                
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
        
    }*/
    
    func updateProfile(user : UserModel?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String) -> Void) {
        // update user detail from edit profile screen
        if let tempUser = user
        {
            let dict = tempUser.editUserDictionaryRepresentation()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.PUT(api: API.EDITUSER_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    
                    
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let msg = dict.value(forKey: "message") as? String{
                            self.message = msg
                        }
                        guard let detail = dict["data"] as? NSDictionary
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        var tempUser : UserModel?
                        
//                        guard let imagesPath = dict["imagesPath"] as? String
//                            else {
//                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
//                                return
//                        }
                        tempUser =  UserModel(dictionary: detail, imagePath : "")
                        
                        if tempUser != nil{
                            tempUser?.password = AppInstance.applicationInstance.user?.password

                            self.updateUserDetails(userModel: tempUser!)
                            completionHandler(true, self.message)
                        }
                    }else{
                        completionHandler(false, response)
                    }
                })
                
            }
            catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
    }
    
    //    MARK: Countries Quetions Weather
    func getQuestionary(_ completionHandler : @escaping (_ success : Bool , _ signupQuestions : [SignupQuestion]?) -> Void){
        //        get questions from api for fresh signup process.
        commMgr.GET(api: API.QUESTIONARY_URL, completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true, [])
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true, [])
                        return
                }
                
                if let msg = dict.value(forKey: "msg") as? String{
                    self.message = msg
                }
                guard let questions = dict["data"] as? NSArray
                    else {
                        completionHandler(true, [])
                        return
                }
//                guard let imagePath = dict["imagesPath"] as? String
//                    else{
//                        completionHandler(true, [])
//                        return
//                }
                completionHandler(true, SignupQuestion.modelsFromDictionaryArray(array: questions, imageBaseUrl: ""))
            }
            else
            {
                completionHandler(false, [])
            }
            
        })
        
    }
    
    func getEmailIfAlreadyExists(email : String, _ completionHandler : @escaping (_ success : Bool , _ message : String?) -> Void){
        // check if email already exists
        commMgr.GET(api: API.CHECK_EMAIL_EXIST_URL+email, completionHandler: { (success, response) -> Void in
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true, nil)
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true, nil)
                        return
                }
                guard let message = dict["msg"] as? String
                    else {
                        completionHandler(true, nil)
                        return
                }
                completionHandler(true, message)
            }else{
                completionHandler(false, nil)
            }
        })
        
    }
    
    func getCountries(_ completionHandler : @escaping (_ success : Bool , _ countries : [CountryModel]?) -> Void){
        // get countries for signup/update user process
        commMgr.GET(api: API.COUNTRIES_URL, completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true, [])
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true, [])
                        return
                }
                
                guard let countries = dict["data"] as? NSArray
                    else {
                        completionHandler(true, [])
                        return
                }
                completionHandler(true, CountryModel.modelsFromDictionaryArray(array: countries))
            }
            else
            {
                completionHandler(false, [])
            }
        })
        
    }
    
    func getWeatherData(_ completionHandler : @escaping (_ success : Bool , _ temperature : Float?) -> Void){
        // to display temperature on dashboard
        commMgr.GET(api: API.WEATHER_URL, completionHandler: { (success, response) -> Void in
            
            if(success) {
                
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, nil)
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, nil)
                        return
                }
                
                if let weatherData = (dict["data"] as? NSArray)?.firstObject as? NSDictionary {
                    if let weatherInfo = (weatherData["weatherInfo"] as? NSArray)?.firstObject as? NSDictionary {
                        if let temp = self.getTemperature(weatherInfo: weatherInfo) {
                            completionHandler(true, temp)
                        }
                        else{
                            completionHandler(false,nil)
                        }
                    }else if let weatherInfo = (weatherData["weatherInfo"] as? NSArray)?.firstObject as? String{
                        if let data = weatherInfo.data(using: .utf8) {
                            do {
                                if let weatherData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    if let temp = self.getTemperature(weatherInfo: weatherData as NSDictionary) {
                                        completionHandler(true, temp)
                                    }
                                    else{
                                        completionHandler(false,nil)
                                    }
                                }
                                else{
                                    completionHandler(false, nil)
                                }
                            } catch {
                                print(error.localizedDescription)
                                completionHandler(false, nil)
                            }
                        }else{
                            completionHandler(false, nil)
                        }
                    }else{
                        completionHandler(false, nil)
                    }
                }
                else{
                    completionHandler(false, nil)
                }
            }
            else
            {
                completionHandler(false, nil)
            }
        })
        
    }
    func getTemperature(weatherInfo : NSDictionary) -> Float? {
        if let main = weatherInfo["main"] as? NSDictionary {
            if let temp = main["temp"] as? Double{
                return Float(temp)
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
    }
    
    //    MARK: Checkin
    
    func checkinEnquiry(bookingNumber : String?, _ completionHandler:@escaping (_ success : Bool, _ message : String, _ booking : Booking?)-> Void) {
        // get checked in booking
        
        if AppInstance.applicationInstance.user != nil{
            var dict : [String : Any] = [:]
            if let number = bookingNumber {
                dict["resno"] = number
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.CHECKIN_ENQUIRY_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(true, self.message, nil)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(true, self.message, nil)
                                return
                        }
                        if let msg = dict["msg"] as? String {
                            self.message = msg
                        }
                        if let completeData = dict["data"] as? NSDictionary {
                            if let checkinresults = completeData["checkinresults"] as? NSDictionary {
                                if let shareresults = checkinresults["shareresults"] as? NSDictionary {
                                    if let booking = Booking(dictionary: shareresults) {
                                        completionHandler(true, self.message, booking)
                                        return
                                    }
                                }
                            }
                        }
                        completionHandler(false, self.message, nil)
                    }
                    else{
                        completionHandler(false, response, nil)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
        }
    }
    
    func userBookingEnquiry(name : String, _ completionHandler:@escaping (_ success : Bool, _ message : String, _ booking : [Booking])-> Void) {
        // get all the bookings with the registered name
        
        if AppInstance.applicationInstance.user != nil{
            let dict = [
                "name":name,
                ]
            print(dict)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.BOOKING_ENQUIRY_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(true, "", [])
                                return
                        }
                        
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(true, "", [])
                                
                                return
                        }
                        var bookingArray : [Booking] = []
                        if let completeData = dict["data"] as? NSDictionary {
                            if let shareresults = completeData["shareresults"] as? NSDictionary {
                                if let booking = Booking(dictionary: shareresults) {
                                    bookingArray.append(booking)
                                }
                            }
                        }
                        else if let completeData = dict["data"] as? NSArray {
                            for item in completeData {
                                if let lastResult = item as? NSDictionary {
                                    if let shareresults = lastResult["shareresults"] as? NSDictionary {
                                        if let booking = Booking(dictionary: shareresults) {
                                            bookingArray.append(booking)
                                        }
                                    }
                                }
                            }
                        }
                        if let msg = dict["msg"] as? String {
                            self.message = msg
                        }
                        else{
                            self.message = ""
                        }
                        completionHandler(true, self.message, bookingArray)
                    }
                    else{
                        completionHandler(false, response, [])
                    }
                })
                
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
        
    }
    
    func soapCheckin(bookingNumber : String?, _ completionHandler:@escaping (_ success : Bool, _ message : String)-> Void) {
        // checkin to SMS with provided booking number
        if AppInstance.applicationInstance.user != nil{
            var dict : [String : Any] = [:]
            if let number = bookingNumber {
                dict["resno"] = number
            }
            print(dict)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.SOAP_CHEKIN_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(true, "")
                                return
                        }
                        
                        
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(true, "")
                                
                                return
                        }
                        
                        if let detail = dict["data"] as? NSDictionary {
                            if let unitresults = detail["unitresults"] as? NSDictionary {
                                if let room_number = unitresults["unum"] as? String {
                                    if let booking = Helper.GetBooking() {
                                        booking.roomNumber = room_number
                                        Helper.SaveBooking(booking)
                                    }
                                    else {
                                        let objBooking = Booking()
                                        objBooking.bookingNumber = bookingNumber
                                        objBooking.roomNumber = room_number
                                        Helper.SaveBooking(objBooking)
                                    }
                                }
                            }
                        }
                        if let msg = dict["msg"] as? String {
                            self.message = msg
                        }
                        completionHandler(true, self.message)
                    }
                    else{
                        completionHandler(false, response)
                    }
                })
                
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
        
    }
    
    func soapCheckout(bookingNumber : String, _ completionHandler:@escaping (_ success : Bool, _ message : String)-> Void) {
        // SMS checkout for provided number
        if AppInstance.applicationInstance.user != nil{
            let dict = [
                "resno":bookingNumber,
                ]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.SOAP_CHECKOUT_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(true, "")
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(true, "")
                                return
                        }
                        print(dict)
                        guard let msg = dict["msg"] as? String else{
                            completionHandler(true, "")
                            return
                        }
                        completionHandler(true, msg)
                    }
                    else{
                        completionHandler(false, response)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
        }
    }
    func folioEnquiry(bookingNumber : String, _ completionHandler:@escaping (_ success : Bool, _ message : String, _ data : [Invoice]?)-> Void) {
        // get all the bill details
        if AppInstance.applicationInstance.user != nil{
            let dict = [
                "resno":bookingNumber,
                ]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.FOLIO_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(true, "", [])
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(true, "", [])
                                return
                        }
                        if let status = dict["status"] as? NSDictionary {
                            if let description = status["description"] as? String {
                                self.message = description
                            }
                        }
                        if let completeData = dict["data"] as? NSDictionary {
                            if let status = completeData["status"] as? NSDictionary {
                                if let description = status["description"] as? String {
                                    self.message = description
                                }
                            }
                            if let arr = completeData["transactionresults"] as? NSArray {
                                completionHandler(true, self.message, Invoice.modelsFromDictionaryArray(array: arr))
                                return
                            }
                            
                        }
                        completionHandler(true, self.message, [])
                    }
                    else{
                        completionHandler(false, response, nil)
                    }
                })
                
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
        
    }
    
    func checkinUser(bookingNumber : String?, roomNumber : String?, checkinTime : String?, arrival_date : String?, departure_date : String?, adults : String?, children : String?, units : String?,_ completionHandler:@escaping (_ success : Bool, _ message : String)-> Void) {
        // checkin user to go hotel life servers
        var dict : [String : Any] = [:]
        if let number = bookingNumber {
            dict["booking_number"] = number
        }
        if let number = roomNumber {
            dict["room_number"] = number
        }
        if let time = checkinTime {
            dict["check_in_time"] = time
        }
        if let date = arrival_date {
            dict["arrival_date"] = date
        }
        if let date = departure_date {
            dict["departure_date"] = date
        }
        if let adult = adults {
            dict["adults"] = adult
        }
        if let child = children {
            dict["children"] = child
        }
        if let unit = units {
            dict["units"] = unit
        }
        
        print(dict)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.CHECKIN_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, "")
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, "")
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(true, "")
                            return
                    }
                    self.message = msg
                    completionHandler(true, self.message)
                }
                else{
                    completionHandler(false, response)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
        
    }
    func folioDetailCard(resno : String, _ completionHandler:@escaping (_ success : Bool, _ message : String)-> Void) {
        // just to get credit card number
        let dict = [
            "resno":resno
        ]
        print(dict)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.FOLIO_INQUIRY_CARD, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false, "")
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false, "")
                            
                            return
                    }
                    guard let dataDict = dict["data"] as? NSDictionary
                        else{
                            completionHandler(false, "")
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false, "")
                            return
                    }
                    
                    self.message = msg
                    if let transactions = dataDict["transactionresults"] as? NSArray {
                        if let lastTransaction = transactions.lastObject as? NSDictionary{
                            if let cardNum = lastTransaction["tdescrip"] as? String {
                                completionHandler(true, cardNum)
                                return
                            }
                        }
                    }
                    completionHandler(false, self.message)
                }
                else{
                    completionHandler(false, response)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
        
    }
    func checkoutUser(bookingNumber : String, checkoutTime: String, _ completionHandler:@escaping (_ success : Bool, _ message : String, _ booking_number : String?)-> Void) {
        // checkout user form go hotel life server
        if AppInstance.applicationInstance.user != nil{
            let dict = [
                "booking_number":bookingNumber,
                "check_out_time":checkoutTime
            ]
            print(dict)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.CHECKOUT_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(true, "", nil)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(true, "", nil)
                                return
                        }
                        print(dict)
                        var number : String?
                        if let num = dict["new_booking_number"] as? String {
                            number = num
                        }
                        guard let msg = dict.value(forKey: "msg") as? String
                            else{
                                completionHandler(true, "", nil)
                                return
                        }
                        self.message = msg
                        completionHandler(true, self.message, number)
                    }
                    else{
                        completionHandler(false, response, nil)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
            
        }
        
    }
    
    //    MARK: Menu related
    func getAlohaMenu(query : String?, _ completionHandler : @escaping (_ success : Bool ,_ response : Any? , _ menus : [Tab]) -> Void){
        // get aloha menu
        var urlStr = API.GET_MENU_URL
        if let str = query {
            urlStr = urlStr.appending("?menu=\(str)")
        }
        commMgr.GET(api: (urlStr), completionHandler: { (success, response) -> Void in
            
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false , response, [])
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false , response, [])
                        return
                }
                guard let tabsData = dict["data"] as? NSArray
                    else {
                        completionHandler(false,response , [])
                        return
                }
                
                guard let message = dict["msg"] as? String
                    else {
                        print ("No msg found")
                        completionHandler(false,response , [])
                        return
                }
                if tabsData.count > 0{
                    var imagePath = ""
                    if let path = dict["imagesPath"] as? String {
                        imagePath = path
                    }
                    let tabsArray = Tab.modelsFromDictionaryArray(array: tabsData, imagePath: imagePath)
                    completionHandler(true, message, tabsArray)
                }
                else{
                    completionHandler(true, message , [])
                }
            }
            else
            {
                completionHandler(false, response,[])
            }
        })
        
    }
    func getDashboardMenu(_ completionHandler : @escaping (_ success : Bool , _ menus : [Menu]) -> Void){
        // get go hotel life dashboard menus
        commMgr.GET(api: API.DASHBOARD_URL, completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true, [])
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true, [])
                        return
                }
                
                guard let dataArr = dict["data"] as? NSArray
                    else {
                        completionHandler(true, [])
                        return
                }
               /* guard let menus = dataArr["result"] as? NSArray
                    else {
                        completionHandler(true, [])
                        return
                }
                guard let imagePath = dict["imagesPath"] as? String
                    else {
                        completionHandler(true, [])
                        return
                }*/
                completionHandler(true, Menu.modelsFromDictionaryArray(array: dataArr, imagePath: "", is_drink: false))
            }
            else
            {
                completionHandler(false, [])
            }
        })
        
    }
    
    
    
    func getQRCodeScanData(codeValue: String ,_ completionHandler : @escaping (_ success : Bool , _ menus : [QRCodeData?]) -> Void){
           // get Qrcode scan details
           commMgr.GET(api: API.QRCodeScan+codeValue, completionHandler: { (success, response) -> Void in
               
               if(success) {
                   guard let data = response.data(using: .utf8)
                       else{
                           completionHandler(true, [])
                           return
                   }
                   
                   guard let dict = self.getResponseDictionary(data)
                       else{
                           completionHandler(true, [])
                           return
                   }
                   
                   guard let dataArr = dict["data"] as? NSDictionary
                       else {
                           completionHandler(true, [])
                           return
                   }
                 
                   completionHandler(true, [QRCodeData.init(dictionary: dataArr)])
               }
               else
               {
                   completionHandler(false, [])
               }
           })
           
       }
    
    
    
    
    
    
    func getSubModuleMenu(menuId : String , _ completionHandler : @escaping (_ success : Bool ,_ message : String,  _ menus : [Menu]) -> Void){
        // departments/submenu
        commMgr.GET(api: (API.SUBMENU_URL+menuId), completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true,"", [])
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true,"", [])
                        return
                }
                guard let message = dict["message"] as? String
                    else {
                        completionHandler(false,ERRORMESSAGE.NO_RECORD_FOUND, [])
                        return
                }
                guard let menus = dict["data"] as? NSArray
                    else {
                        completionHandler(false, ERRORMESSAGE.NO_RECORD_FOUND, [])
                        return
                }
//                guard let imagePath = dict["imagesPath"] as? String
//                    else {
//                        completionHandler(false, ERRORMESSAGE.NO_RECORD_FOUND,[])
//                        return
//                }
                completionHandler(true, message,Menu.modelsFromDictionaryArray(array: menus, imagePath: "", is_drink: false))
            }else{
                completionHandler(false, response,[])
            }
        })
    }
    
    
      func getSubMenuFromDepartment(menuId : String , _ completionHandler : @escaping (_ success : Bool ,_ message : String,  _ menus : [Menu]) -> Void){
            // departments/submenu
            commMgr.GET(api: (API.DEPARTMENTSUBMENU_URL+menuId), completionHandler: { (success, response) -> Void in
                
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true,"", [])
                            return
                    }
                    
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true,"", [])
                            return
                    }
                    guard let message = dict["message"] as? String
                        else {
                            completionHandler(false,ERRORMESSAGE.NO_RECORD_FOUND, [])
                            return
                    }
                    guard let menus = dict["data"] as? NSArray
                        else {
                            completionHandler(false, ERRORMESSAGE.NO_RECORD_FOUND, [])
                            return
                    }
    //                guard let imagePath = dict["imagesPath"] as? String
    //                    else {
    //                        completionHandler(false, ERRORMESSAGE.NO_RECORD_FOUND,[])
    //                        return
    //                }
                    completionHandler(true, message,Menu.modelsFromDictionaryArray(array: menus, imagePath: "", is_drink: false))
                }else{
                    completionHandler(false, response,[])
                }
            })
        }
    
    
    
    
    
    
    
    
    
    func getTabs(departmentId : String , _ completionHandler : @escaping (_ success : Bool, _ message : String, _ departmentMenuArray : [Tab])-> Void){
        //        Tabs for quantity and tabs selection
        let QueryStr = "?time="+Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        commMgr.GET(api: (API.DEPARTMENTSUBMENU_URL+departmentId+QueryStr), completionHandler: { (success, response) -> Void in
            
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false , response, [])
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false , response, [])
                        return
                }
                guard let tabsData = dict["data"] as? NSArray
                    else {
                        completionHandler(false,response , [])
                        return
                }
                guard let imagePath = dict["imagesPath"] as? String
                    else {
                        print ("No image path found")
                        completionHandler(false,response , [])
                        return
                }
                guard let message = dict["msg"] as? String
                    else {
                        print ("No msg found")
                        completionHandler(false,response , [])
                        return
                }
                
                if tabsData.count > 0{
                    
                    let tabsArray = Tab.modelsFromDictionaryArray(array: tabsData, imagePath: imagePath)
                    completionHandler(true, message, tabsArray)
                    
                }
                else{
                    completionHandler(true, message , [])
                }
            }
            else
            {
                completionHandler(false, response,[])
            }
        })
    }
    
    func getAlertMenu(departmentId : String , _ completionHandler : @escaping (_ success : Bool, _ message : String, _ tabsArray :Menu?)-> Void){
        let QueryStr = "?time="+Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        commMgr.GET(api: (API.DEPARTMENTSUBMENU_URL+departmentId+QueryStr), completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                
                guard let departmentData = dict["data"] as? NSArray
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                guard let imagePath = dict["imagesPath"] as? String
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                guard let message = dict["msg"] as? String
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                if departmentData.count > 0{
                    let itemArray = Tab.modelsFromDictionaryArray(array: departmentData, imagePath: imagePath)
                    var alertArray : [Menu] = []
                    for tab in itemArray {
                        guard let dept = tab.departments?.first
                            else {
                                completionHandler(true,message, nil)
                                return
                        }
                        guard let menu = dept.items?.first
                            else{
                                completionHandler(true,message, nil)
                                return
                        }
                        alertArray.append(menu)
                        
                    }
                    if let alert = alertArray.first {
                        completionHandler(true,message, alert)
                    }
                    else{
                        completionHandler(true,message, nil)
                    }
                    
                }
                else{
                    completionHandler(false,message, nil)
                }
            }
            else
            {
                completionHandler(false, response, nil)
            }
        })
    }
    
    //    MARK: Loyalty Program
    func getLoyaltyMenu(_ completionHandler : @escaping (_ success : Bool , _ loyaltyMenu : [Loyalty]?, _ points : Float, _ progress : Float, _ showModule : Bool, _ trumpText : String) -> Void){
        commMgr.GET(api: API.LOYALTY_URL, completionHandler: { (success, response) -> Void in
            // For trump bucks
            if(success) {
                print(response)
                var trumpText = ""
                var points : Float = 0
                var progress : Float = 0
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true, [], points, progress, false, trumpText)
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true, [], points, progress, false, trumpText)
                        return
                }
                
                guard let menus = dict["wayToEarnPoints"] as? NSArray
                    else {
                        completionHandler(true, [], points, progress, false, trumpText)
                        return
                }
                guard let imagePath = dict["imagesPath"] as? String
                    else {
                        completionHandler(true, [], points, progress, false, trumpText)
                        return
                }
                if let pts = dict["totalPoints"] as? Float {
                    if let userPt = dict["userPoints"] as? Float {
                        points = userPt
                        progress = Float(userPt/pts)
                    }
                }
                var disabledArray : [String] = []
                if let arr = dict["used_bucks"] as? [String] {
                    disabledArray = arr
                }
                var showScreen = false
                if let show = dict["trump_bucks"] as? Bool {
                    showScreen = show
                }
                
                if let text = dict["trump_text"] as? String {
                    trumpText = text
                }
                if let text = dict["valet_number"] as? String {
                    Helper.saveValetNumber(num:text)
                }
                completionHandler(true, Loyalty.modelsFromDictionaryArray(array: menus, imagePath: imagePath, disableArray: disabledArray), points, progress, showScreen, trumpText)
            }
            else
            {
                completionHandler(false, [], 0, 0, false, "")
            }
        })
        
    }
    func getRedeemCode(_ completionHandler : @escaping (_ success : Bool , _ message : String) -> Void){
        commMgr.GET(api: API.REDEEM_URL, completionHandler: { (success, response) -> Void in
            
            if(success) {
                
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true, response)
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true, response)
                        return
                }
                
                guard let codeData = dict["data"] as? NSDictionary
                    else {
                        completionHandler(false, response)
                        return
                }
                if let message = codeData["code"] as? String{
                    completionHandler(true,message)
                }
                else{
                    completionHandler(true,response)
                }
            }
            else
            {
                completionHandler(false, response)
            }
        })
        
    }
    
    
    
    
    
    
    //    MARK: Hotel Reservation
    func reservation(obj : ReservationModel, isOrder : Bool, _ completionHandler : @escaping (_ success : Bool, _ reservationModel : ReservationModel?,_ title : String, _ message : String) -> Void){
        // make reservation
        var params = obj.dictionaryRepresentationForServiceReservation()
        if isOrder == true {
            params = obj.dictionaryRepresentationForOrderReservation()
        }
        print (params)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.RESERVATION_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let msg = dict.value(forKey: "message") as? String
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    self.message = msg
                    guard let userData = dict["data"] as? NSDictionary
                        else {
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    let reservationModel = ReservationModel.init(dictionary: userData)
                    var title = ""
                    var text = ""
                    if let txt = dict["title"] as? String {
                        title = txt
                    }
                    if let txt = dict["text"] as? String {
                        text = txt
                    }
                    completionHandler(true,reservationModel,title,text)
                    
                }
                else{
                    completionHandler(false,nil,ALERTSTRING.ERROR,response)
                }
            })
            
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    func modifyReservation(obj : ReservationModel, isOrder : Bool, _ completionHandler : @escaping (_ success : Bool, _ reservationModel : ReservationModel?,_ title : String, _ message : String) -> Void){
        let params = obj.dictionaryRepresentation()
        print (params)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.PUT(api: API.MODIFY_RESERVATION_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    self.message = msg
                    guard let userData = dict["data"] as? NSDictionary
                        else {
                            completionHandler(false,nil,ALERTSTRING.ERROR,response)
                            return
                    }
                    let reservationModel = ReservationModel.init(dictionary: userData)
                    var title = ""
                    var text = ""
                    if let txt = dict["title"] as? String {
                        title = txt
                    }
                    if let txt = dict["text"] as? String {
                        text = txt
                    }
                    completionHandler(true,reservationModel,title,text)
                }
                else{
                    completionHandler(false,nil,ALERTSTRING.ERROR,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    func getReservation(moduleId : String, departmentId : String , _ completionHandler : @escaping (_ success : Bool , _ reservationModel : ReservationModel?) -> Void){
        let QueryStr = "&department_id="+departmentId+"&time="+Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        commMgr.GET(api: (API.RESERVATION_URL+"?module_id="+moduleId+QueryStr), completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let responseData = response.data(using: .utf8)
                    else{
                        completionHandler(false, nil)
                        return
                }
                guard let dict = self.getResponseDictionary(responseData)
                    else{
                        completionHandler(false, nil)
                        return
                }
                guard let data = dict["data"] as? NSDictionary
                    else {
                        completionHandler(false, nil)
                        return
                }
                print(data)
                if data.allKeys.count > 0 {
                    let reservationModel = ReservationModel.init(dictionary: data)
                    completionHandler(true, reservationModel)
                }
                else{
                    completionHandler(false, nil)
                }
            }
            else
            {
                completionHandler(false, nil)
            }
        })
        
    }
    
    func getDirectReservation(moduleId : String, departmentId : String , _ completionHandler : @escaping (_ success : Bool , _ reservationModel : AlohaOrder?) -> Void){
        let QueryStr = "&department_id="+departmentId+"&time="+Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        commMgr.GET(api: (API.DIRECTORDER_URL+"?module_id="+moduleId+QueryStr), completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let responseData = response.data(using: .utf8)
                    else{
                        completionHandler(false, nil)
                        return
                }
                guard let dict = self.getResponseDictionary(responseData)
                    else{
                        completionHandler(false, nil)
                        return
                }
                guard let data = dict["data"] as? NSDictionary
                    else {
                        completionHandler(false, nil)
                        return
                }
                if let body = data["body"] as? NSDictionary {
                    if let result = body["ApiResult"] as? NSDictionary {
                        if let code = result["ResultCode"] as? Int {
                            if code != 0 {
                                completionHandler(false, nil)
                                return
                            }
                        }
                    }
                    if let updatedOrder = body["UpdatedOrder"] as? NSDictionary {
                        if let alohaOrder = AlohaOrder.init(dictionary: updatedOrder, imagePath: "") {
                            if let reservationDict = dict["data1"] as? NSDictionary {
                                if let model = ReservationModel.init(dictionary: reservationDict) {
                                    alohaOrder.reservationModel = model
                                }
                            }
                            completionHandler(true, alohaOrder)
                            return
                        }
                    }
                }
                completionHandler(false, nil)
                //                print(data)
                //                if data.allKeys.count > 0 {
                //                    let reservationModel = ReservationModel.init(dictionary: data)
                //                    completionHandler(true, reservationModel)
                //                }
                //                else{
                //                    completionHandler(false, nil)
                //                }
            }
            else
            {
                completionHandler(false, nil)
            }
        })
        
    }
    
    func cancelReservation(appointmentId : String, _ completionHandler : @escaping (_ success : Bool , _ response : NSDictionary) -> Void){
        
        commMgr.PUT(api: (API.CANCELRESERVATION_URL+appointmentId), jsonString: "" ,completionHandler: { (success, response) -> Void in
            if(success) {
                completionHandler(true, [:])
            }
            else{
                completionHandler(false, [:])
            }
        })
    }
    
    
    func getMaintenanceItems(menu : Menu, _ completionHandler : @escaping (_ success : Bool, _ message : String, _ maintenanceArray :[Service]?)-> Void){
        commMgr.GET(api: (API.MAINTENANCE_ITEMS_URL), completionHandler: { (success, response) -> Void in
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                guard let departmentData = dict["data"] as? NSArray
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                guard let message = dict["msg"] as? String
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                if departmentData.count > 0{
                    let arr = Service.modelsFromDictionaryArray(array: departmentData, menu : menu)
                    completionHandler(true,message,arr)
                }
                else{
                    completionHandler(false,message, nil)
                }
            }
            else
            {
                completionHandler(false, response, nil)
            }
        })
    }
    
    func submitMaintenanceRequest(obj : Service, _ completionHandler : @escaping (_ success : Bool, _ title : String, _ message : String) -> Void){
        do {
            let dict = obj.dictionaryRepresentation()
            print(dict)
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.MAINTENANCE_REQUEST_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    self.message = msg
                    var title = ""
                    var text = ""
                    if let txt = dict["title"] as? String {
                        title = txt
                    }
                    if let txt = dict["text"] as? String {
                        text = txt
                    }
                    completionHandler(true,title,text)
                }
                else{
                    completionHandler(false,ALERTSTRING.ERROR,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    func modifySuggestion(obj : NotificationModel,screenType : SubMenuDataType, _ completionHandler : @escaping (_ success : Bool, _ reservationModel : ReservationModel?,_ title : String, _ message : String) -> Void){
        var params = obj.message?.dictionaryRepresentation()
        if screenType == .reservation {
            params = obj.message?.dictionaryRepresentationForRestaurantReservation()
        }
        print (params)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.PUT(api: API.MODIFY_SUGGESTION_URL+(obj.message?.appointment_id)!, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,nil,ALERTSTRING.ERROR,ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    self.message = msg
                    guard let userData = dict["data"] as? NSDictionary
                        else {
                            completionHandler(false,nil,ALERTSTRING.ERROR,ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    let reservationModel = ReservationModel.init(dictionary: userData)
                    var title = ""
                    var text = self.message
                    if let txt = dict["title"] as? String {
                        title = txt
                    }
                    if let txt = dict["text"] as? String {
                        text = txt
                    }
                    completionHandler(true,reservationModel,title,text)
                }
                else{
                    completionHandler(false,nil,ALERTSTRING.ERROR,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    func getReorderMenuDetail(appointmentId : String? , _ completionHandler : @escaping (_ success : Bool ,_ message : String,  _ alohaOrder : AlohaOrder?, _ selectedMenu : Menu?) -> Void){
        // departments/submenu
        if let id = appointmentId {
            commMgr.GET(api: (API.APPOINTMENT_REORDER_URL+id), completionHandler: { (success, response) -> Void in
                
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true,"", nil, nil)
                            return
                    }
                    
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true,"", nil, nil)
                            return
                    }
                    guard let message = dict["msg"] as? String
                        else {
                            completionHandler(false,ERRORMESSAGE.NO_RECORD_FOUND, nil, nil)
                            return
                    }
                    guard let alohaDict = dict["aloha_request"] as? NSDictionary
                        else {
                            completionHandler(false, ERRORMESSAGE.NO_RECORD_FOUND, nil, nil)
                            return
                    }
                    guard let menuDict = dict["department"] as? NSDictionary
                        else {
                            completionHandler(false, ERRORMESSAGE.NO_RECORD_FOUND, nil, nil)
                            return
                    }
                    
                    if let alohaOrder = AlohaOrder.init(dictionary: alohaDict, imagePath: "") {
                        if let selectedMenu = Menu.init(dictionary: menuDict, imagePath: "", is_drink: false) {
                            completionHandler(true, message, alohaOrder, selectedMenu)
                        }
                        
                    }
                }else{
                    completionHandler(false, response, nil, nil)
                }
            })
        }
        
    }
    
    func requestCar(obj : NSDictionary, _ completionHandler : @escaping (_ success : Bool, _ title : String, _ message : String) -> Void){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.REQUEST_CAR_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    self.message = msg
                    var title = ""
                    var text = ""
                    if let txt = dict["title"] as? String {
                        title = txt
                    }
                    if let txt = dict["text"] as? String {
                        text = txt
                    }
                    completionHandler(true,title,text)
                }
                else{
                    completionHandler(false,ALERTSTRING.ERROR,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    func applyPromocode(obj : NSDictionary, _ completionHandler : @escaping (_ success : Bool, _ message : String,  _ promocode : Promocode?) -> Void){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.PROMOCODE_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,response, nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,response, nil)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,response, nil)
                            return
                    }
                    guard let code = dict.value(forKey: "data") as? NSDictionary
                        else{
                            completionHandler(false,response, nil)
                            return
                    }
                    let promocode = Promocode.init(dictionary: code)
                    completionHandler(true,msg,promocode)
                }
                else{
                    completionHandler(false,response ,nil)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    func confirmTrayPickup(obj : NotificationModel, _ completionHandler : @escaping (_ success : Bool, _ title : String, _ message : String) -> Void){
        do {
            let dict = obj.dictionaryRepresentationForTrayPickup()
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.PICKUP_TRAY_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    self.message = msg
                    var title = ""
                    var text = ""
                    if let txt = dict["title"] as? String {
                        title = txt
                    }
                    if let txt = dict["text"] as? String {
                        text = txt
                    }
                    completionHandler(true,title,text)
                }
                else{
                    completionHandler(false,ALERTSTRING.ERROR,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    func bookStay(room_number : String?, _ completionHandler : @escaping (_ success : Bool, _ title : String, _ message : String) -> Void){
        do {
            var dict : [String : Any] = [:]
            dict["appointment_date"] = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
            if let num = room_number {
                dict["room_number"] = num
            }
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.BOOK_STAY_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    completionHandler(true,"",msg)
                }
                else{
                    completionHandler(false,ALERTSTRING.ERROR,response)
                }
            })
        }catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    func contactus(menu : Menu,_ completionHandler : @escaping (_ success : Bool, _ title : String, _ message : String) -> Void){
        do {
            //let param = menu.dictionaryRepresentationForLocalAttraction()
            var param = [String: Any]()
            param["moduleId"] = menu.module_id
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.CONTACT_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "message") as? String
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    completionHandler(true,"",msg)
                }
                else{
                    completionHandler(false,ALERTSTRING.ERROR,response)
                }
            })
        }catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    func localAttractionRequest(reservation : ReservationModel, _ completionHandler : @escaping (_ success : Bool, _ title : String, _ message : String) -> Void){
        do {
            let param = reservation.dictionaryRepresentationForLocalAttraction()
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.LOCAL_ATTRACTION_REQUEST_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,ALERTSTRING.ERROR,response)
                            return
                    }
                    self.message = msg
                    var title = ""
                    var text = self.message
                    if let txt = dict["title"] as? String {
                        title = txt
                    }
                    if let txt = dict["text"] as? String {
                        text = txt
                    }
                    completionHandler(true,title,text)
                }
                else{
                    completionHandler(false,ALERTSTRING.ERROR,response)
                }
            })
        }
        catch {
            
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    //    func orderConfirm(arr : [AlohaMenu], model : ReservationModel, orderMode : Int, _ completionHandler : @escaping (_ success : Bool, _ alohaOrder : AlohaOrder?, _ message : String) -> Void){
    //        let params = AlohaMenu.dictionaryRepresentationForConfirmOrder(menus: arr,model: model, orderMode: orderMode)
    //        print(params)
    //        do {
    //            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    //            let jsonString = String(data: jsonData, encoding: .utf8)
    //            commMgr.POST(api: API.ORDER_CONFIRM_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
    //                if(success) {
    //                    guard let data = response.data(using: .utf8)
    //                        else{
    //                            completionHandler(false,nil,response)
    //                            return
    //                    }
    //                    guard let dict = self.getResponseDictionary(data)
    //                        else{
    //                            completionHandler(false,nil,response)
    //                            return
    //                    }
    //                    guard let msg = dict.value(forKey: "msg") as? String
    //                        else{
    //                            completionHandler(false,nil,response)
    //                            return
    //                    }
    //                    self.message = msg
    //                    guard let userData = dict["data"] as? NSDictionary
    //                        else {
    //                            completionHandler(false,nil,response)
    //                            return
    //                    }
    //                    if let body = userData["body"] as? NSDictionary {
    //                        if let result = body["ApiResult"] as? NSDictionary {
    //                            if let code = result["ResultCode"] as? Int {
    //                                if code != 0 {
    //                                    completionHandler(false, nil, self.message)
    //                                    return
    //                                }
    //                            }
    //                        }
    //                        if let updatedOrder = body["UpdatedOrder"] as? NSDictionary {
    //                            if let alohaOrder = AlohaOrder.init(dictionary: updatedOrder, imagePath: "") {
    //                                if let reservationDict = dict["data1"] as? NSDictionary {
    //                                    if let model = ReservationModel.init(dictionary: reservationDict) {
    //                                        alohaOrder.reservationModel = model
    //                                    }
    //                                }
    //                                completionHandler(true, alohaOrder, "")
    //                                return
    //                            }
    //                        }
    //                    }
    //                    completionHandler(false, nil, self.message)
    //                }
    //                else{
    //                    completionHandler(false,nil,response)
    //                }
    //            })
    //        }
    //        catch {
    //            Helper.printLog(error.localizedDescription as AnyObject?)
    //        }
    //    }
    func alohaOrderConfirm(order : AlohaOrder, orderMode : Int, _ completionHandler : @escaping (_ success : Bool, _ alohaOrder : AlohaOrder?, _ message : String) -> Void){
        let params = order.dictionaryRepresentationForConfirmOrder()
        print(params)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.ORDER_CONFIRM_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    self.message = msg
                    guard let userData = dict["data"] as? NSDictionary
                        else {
                            completionHandler(false,nil,response)
                            return
                    }
                    if let body = userData["body"] as? NSDictionary {
                        if let result = body["ApiResult"] as? NSDictionary {
                            if let code = result["ResultCode"] as? Int {
                                if code != 0 {
                                    completionHandler(false, nil, self.message)
                                    return
                                }
                            }
                        }
                        if let updatedOrder = body["UpdatedOrder"] as? NSDictionary {
                            if let alohaOrder = AlohaOrder.init(dictionary: updatedOrder, imagePath: "") {
                                if let reservationDict = dict["data1"] as? NSDictionary {
                                    if let model = ReservationModel.init(dictionary: reservationDict) {
                                        alohaOrder.reservationModel = model
                                    }
                                }
                                completionHandler(true, alohaOrder, "")
                                return
                            }
                        }
                    }
                    completionHandler(false, nil, self.message)
                }
                else{
                    completionHandler(false,nil,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    func cancelAlohaOrder(orderId : String, _ completionHandler : @escaping (_ success : Bool , _ message : String) -> Void){
        commMgr.DELETE(api: "\(API.ORDER_CANCEL_URL)\(orderId)", jsonString: "", completionHandler: {(success, response) -> Void in
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, ALERTSTRING.ORDER_NOT_CANCELLED)
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, ALERTSTRING.ORDER_NOT_CANCELLED)
                        return
                }
                guard let res = dict["data"] as? NSDictionary
                    else {
                        completionHandler(false, ALERTSTRING.ORDER_NOT_CANCELLED)
                        return
                }
                if let msg = dict["msg"] as? String {
                    self.message = msg
                }
                if let code = res["ResultCode"] as? Int {
                    if code == 0 {
                        completionHandler(true,ALERTSTRING.ORDER_CANCELLED)
                    }
                    else {
                        completionHandler(false, ALERTSTRING.ORDER_NOT_CANCELLED)
                    }
                }
                else {
                    completionHandler(false, ALERTSTRING.ORDER_NOT_CANCELLED)
                }
            }
            else{
                completionHandler(false, ALERTSTRING.ORDER_NOT_CANCELLED)
            }
        })
    }
    func calculateTax(arr : [Menu], orderMode : Int, _ completionHandler : @escaping (_ success : Bool, _ alohaOrder : AlohaOrder?, _ message : String) -> Void){
        let params = Menu.dictionaryRepresentationForTaxCalculation(menus: arr, orderMode: orderMode)
        print(params)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.PUT(api: API.CALCULATE_TAX_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    self.message = msg
                    guard let userData = dict["data"] as? NSDictionary
                        else {
                            completionHandler(false,nil,response)
                            return
                    }
                    if let body = userData["body"] as? NSDictionary {
                        if let updatedOrder = body["UpdatedOrder"] as? NSDictionary {
                            if let alohaOrder = AlohaOrder.init(dictionary: updatedOrder, imagePath: "") {
                                completionHandler(true, alohaOrder, "")
                                return
                            }
                        }
                        else {
                            completionHandler(false, nil, ERRORMESSAGE.KINDLY_TRY_AGAIN)
                            return
                        }
                    }
                    completionHandler(false, nil, self.message)
                }
                else{
                    completionHandler(false,nil,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    func calculateAlohaTax(arr : [AlohaMenu], orderMode : Int, _ completionHandler : @escaping (_ success : Bool, _ alohaOrder : AlohaOrder?, _ message : String) -> Void){
        let params = AlohaMenu.dictionaryRepresentationForTaxCalculation(menus: arr, orderMode: orderMode)
        print(params)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.PUT(api: API.CALCULATE_TAX_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,nil,response)
                            return
                    }
                    self.message = msg
                    guard let userData = dict["data"] as? NSDictionary
                        else {
                            completionHandler(false,nil,response)
                            return
                    }
                    if let body = userData["body"] as? NSDictionary {
                        if let updatedOrder = body["UpdatedOrder"] as? NSDictionary {
                            if let alohaOrder = AlohaOrder.init(dictionary: updatedOrder, imagePath: "") {
                                completionHandler(true, alohaOrder, "")
                                return
                            }
                        }
                        else {
                            completionHandler(false, nil, ERRORMESSAGE.KINDLY_TRY_AGAIN)
                            return
                        }
                    }
                    completionHandler(false, nil, self.message)
                }
                else{
                    completionHandler(false,nil,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    func checkRoomNumber(number : String, _ completionHandler : @escaping (_ success : Bool, _ message : String) -> Void){
        do {
            var obj : [String : Any] = [:]
            obj["room_number"] = number
            print(obj)
            let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.CHECK_ROOM_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,response)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,response)
                            return
                    }
                    completionHandler(true,msg)
                }
                else{
                    completionHandler(false,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    func checkChairNumber(number : String, _ completionHandler : @escaping (_ success : Bool, _ message : String) -> Void){
        do {
            var obj : [String : Any] = [:]
            obj["chair_number"] = number
            print(obj)
            let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.CHECK_CHAIR_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(false,response)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,response)
                            return
                    }
                    print(dict)
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(false,response)
                            return
                    }
                    completionHandler(true,msg)
                }
                else{
                    completionHandler(false,response)
                }
            })
        }
        catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    //MARK: - Images Related
    func getModuleImagesFromServer(_ completionHandler : @escaping (_ success : Bool , _ imagesArray : [String]?) -> Void){
        commMgr.GET(api: API.FETCH_MODULE_IMAGES_URL, completionHandler: { (success, response) -> Void in
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, [])
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, [])
                        return
                }
                guard let imageArray = dict["data"] as? NSArray
                    else {
                        completionHandler(false, [])
                        return
                }
                completionHandler(true,imageArray as? [String])
            }
            else{
                completionHandler(false, [])
            }
        })
    }
    
    func getQuestionImagesFromServer(_ completionHandler : @escaping (_ success : Bool , _ imagesArray : [String]?) -> Void){
        commMgr.GET(api: API.FETCH_QUESTION_IMAGES_URL, completionHandler: { (success, response) -> Void in
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, [])
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, [])
                        return
                }
                guard let imageArray = dict["data"] as? NSArray
                    else {
                        completionHandler(false, [])
                        return
                }
                completionHandler(true,imageArray as? [String])
            }
            else{
                completionHandler(false, [])
            }
        })
    }
    
    func getDepartmentImagesFromServer(_ completionHandler : @escaping (_ success : Bool , _ imagesArray : [String]?) -> Void){
        commMgr.GET(api: API.FETCH_DEPARTMENT_IMAGES_URL, completionHandler: { (success, response) -> Void in
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, [])
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, [])
                        return
                }
                guard let imageArray = dict["data"] as? NSArray
                    else {
                        completionHandler(false, [])
                        return
                }
                completionHandler(true,imageArray as? [String])
            }
            else{
                completionHandler(false, [])
            }
        })
    }
    //MARK:- Social Share
    func socialShare(platform : String?, _ completionHandler:@escaping (_ success : Bool, _ message : String)-> Void) {
        if AppInstance.applicationInstance.user != nil{
            var dict : [String : Any] = [:]
            if let platform = platform {
                dict["platform"] = platform
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                commMgr.POST(api: API.SOCIAL_SHARE_URL, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(true, self.message)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(true, self.message)
                                return
                        }
                        if let msg = dict["msg"] as? String {
                            self.message = msg
                        }
                        completionHandler(true, self.message)
                    }
                    else{
                        completionHandler(false, response)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
        }
    }
    
    //MARK:- Rate Service
    func giveRating(rateObj: RateModel?,_ completionHandler:@escaping (_ success:Bool, _ response: String?) -> Void) {
        if let rate = rateObj
        {
            let dict = rate.dictionaryRepresentation()
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                commMgr.POST(api: API.RATE_URL, jsonString: jsonString,completionHandler: { (success, response) -> Void in
                    
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let msg = dict.value(forKey: "message") as? String{
                            self.message = msg
                        }
                        completionHandler(true, self.message)
                    }else{
                        completionHandler(false, response)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
        }
    }
    
    func customerSupport(question: NSDictionary?,_ completionHandler:@escaping (_ success:Bool, _ response: String) -> Void) {
        if let dict = question
        {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                commMgr.POST(api: API.SUPPORT_URL, jsonString: jsonString,completionHandler: { (success, response) -> Void in
                    
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let msg = dict.value(forKey: "message") as? String{
                            self.message = msg
                        }
                        completionHandler(true, self.message)
                    }else{
                        completionHandler(false, response)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
        }
    }
    
    func serviceRequest(menuObj: Menu?,_ completionHandler:@escaping (_ success:Bool,_ title: String?, _ response: String?) -> Void) {
        if let menu = menuObj
        {
            let dict = menu.dictionaryRepresentationForServiceRequest()
            print(dict)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                commMgr.POST(api: API.SERVICE_REQUEST_URL, jsonString: jsonString,completionHandler: { (success, response) -> Void in
                    
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, self.title, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, self.title, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let title = dict.value(forKey: "title") as? String{
                            self.title = title
                        }
                        if let msg = dict.value(forKey: "msg") as? String{
                            self.message = msg
                        }
                        completionHandler(true, self.title, self.message)
                    }else{
                        
                        completionHandler(false, ALERTSTRING.ERROR, response)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
        }
    }
    
    //MARK: LoggedOut from Application
    func signOut(_ completionHandler : @escaping (_ success : Bool , _ response : String) -> Void){
        commMgr.GET(api: API.LOGOUT_URL, completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                
                guard let msg = dict.value(forKey: "msg") as? String
                    else{
                        completionHandler(true,  ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                print(dict)
                completionHandler(true, msg)
            }
            else
            {
                completionHandler(false, response)
            }
            
        })
        
    }
    
    //Update Photo ID and unit number
    
    func uploadPhotoID(params : [String:Any]?,file : Data?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String) -> Void) {
        
        commMgr.PUTMULTIPART(api: API.USER_ADDITIONAL_FIELDS, parameters: params, file: file) { (success, response) -> Void in
            
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                if let msg = dict.value(forKey: "msg") as? String{
                    guard let detail = dict["data"] as? NSDictionary
                        else{
                            completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }

                    self.message = msg
                    var tempUser : UserModel?
                    
                    guard let imagesPath = dict["imagesPath"] as? String
                        else {
                            completionHandler(false, self.message)
                            return
                    }
                    tempUser =  UserModel(dictionary: detail, imagePath : imagesPath)
                    
                    if tempUser != nil{
                        tempUser?.password = AppInstance.applicationInstance.user?.password
                        self.updateUserDetails(userModel: tempUser!)
                    }
                     completionHandler(success,msg)
                }

            }else{
                completionHandler(false, response)
            }
        }
    }
    
    // Thermostst API
    
    func getDeviceList(roomNo : String , _ completionHandler : @escaping (_ success : Bool, _ message : String, _ deviceData :DeviceData?)-> Void){
       
        commMgr.GET(api: (API.GET_DEVICE_LIST+roomNo), completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                
                guard let deviceData = dict["data"] as? NSDictionary
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                guard let message = dict["msg"] as? String
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                let ddevData = DeviceData.init(dictionary: deviceData)
                    completionHandler(success,message,ddevData)
            }
            else
            {
                completionHandler(false, response, nil)
            }
        })
    }
    
    func getDeviceInfo(deviceAddress : String , _ completionHandler : @escaping (_ success : Bool, _ message : String, _ deviceData :DeviceInfo?)-> Void){
        
        commMgr.GET(api: (API.GET_DEVICE_INFO+deviceAddress), completionHandler: { (success, response) -> Void in
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(false, response, nil)
                        return
                }
                
                guard let deviceData = dict["data"] as? NSDictionary
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                guard let message = dict["msg"] as? String
                    else {
                        completionHandler(false, response, nil)
                        return
                }
                let ddevData = DeviceInfo.init(dictionary: deviceData)
                completionHandler(success,message,ddevData)
            }
            else
            {
                completionHandler(false, response, nil)
            }
        })
    }
    
    func setDeviceInfo(prams: [String:Any],deviceAddress:String,_ completionHandler:@escaping (_ success:Bool,_ title: String?, _ response: String?) -> Void) {
        
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: prams, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                commMgr.POST(api: API.SET_DEVICE_Info+deviceAddress, jsonString: jsonString,completionHandler: { (success, response) -> Void in
                    
                    if(success) {
                        guard let data = response.data(using: .utf8)
                            else{
                                completionHandler(false, self.title, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        guard let dict = self.getResponseDictionary(data)
                            else{
                                completionHandler(false, self.title, ERRORMESSAGE.NO_RESPONSE)
                                return
                        }
                        if let title = dict.value(forKey: "title") as? String{
                            self.title = title
                        }
                        if let msg = dict.value(forKey: "msg") as? String{
                            self.message = msg
                        }
                        completionHandler(true, self.title, self.message)
                    }else{
                        
                        completionHandler(false, ALERTSTRING.ERROR, response)
                    }
                })
            } catch {
                Helper.printLog(error.localizedDescription as AnyObject?)
            }
        
    }
    
    func getResponseDictionary(_ responseData:Data) -> NSDictionary? {
        do {
            if let responseDictionary: [String : AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary as! [String : AnyObject]?
            {
                return responseDictionary as NSDictionary?
            }
        } catch let error as NSError {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
        return nil
    }
    
    func getDictionaryFromString(_ responseString:String) -> NSDictionary?
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseString, options: [])
            if let responseDictionary: [String : AnyObject] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary as! [String : AnyObject]?
            {
                return responseDictionary as NSDictionary?
            }
        } catch let error as NSError {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
        return nil
    }
    
    func getResponseArray(_ responseData:Data) -> Array<Any>? {
        do {
            if let responseDictionary: Array = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? Array<Any>
            {
                return responseDictionary as Array
            }
        } catch let error as NSError {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
        return nil
    }
    
    
    
    
    func getOrderHistory(userId:String,params : [String:Any], _ completionHandler : @escaping (_ sucsess : Bool, _ response:OrderHistoryResponse?,_ message : String) -> Void) {
        do {
            //let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            //let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.GET(api: API.GET_ORDER_HISTORY) { (success, responseString) in
                if(success) {
                    guard let data = responseString.data(using: .utf8)
                        else{
                            completionHandler(false,nil, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false,nil, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    if let msg = dict.value(forKey: "message") as? String{
                        self.message = msg
                    }
                    if let response = OrderHistoryResponse.init(dictionary: dict){
                        completionHandler(true,response, self.message)
                        return
                    }
                    else{
                        completionHandler(false,nil,self.message)
                    }
                }else{
                    completionHandler(false,nil, responseString)
                }
            }
            
            
//            commMgr.POST(api: API.GET_ORDER_HISTORY, jsonString: jsonString ,completionHandler: { (success, responseString) -> Void in
//
//
//            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    
    func rateOrderHistory(userId:String,params : [String:Any], _ completionHandler : @escaping (_ sucsess : Bool, _ message : String) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.ORDER_RATING, jsonString: jsonString ,completionHandler: { (success, responseString) -> Void in
                
                if(success) {
                    guard let data = responseString.data(using: .utf8)
                        else{
                            completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(false, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    if let msg = dict.value(forKey: "msg") as? String{
                        self.message = msg
                        completionHandler(true, self.message)
                        return
                    }
                    else{
                        completionHandler(false,self.message)
                    }
                }else{
                    completionHandler(false, responseString)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    
    func getOrderDetails(userId:String,params : [String:Any], _ completionHandler : @escaping (_ sucsess : Bool, _ response:OrderDetailsResponse?,_ message : String) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            commMgr.GET(api: API.GET_ORDER_DETAILS+userId, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    guard let message = dict["msg"] as? String
                        else {
                            completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                            return
                    }
                    let response = OrderDetailsResponse.init(dictionary: dict)
                    completionHandler(true, response, message)
                }else{
                    completionHandler(false, nil, ERRORMESSAGE.NO_RESPONSE)
                }
            })
            
            
            
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    
    
    
    //Generate Invitation Code
    
    @objc func generateInvitaionCode(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.CREATE_INVITATION_CODE, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, response,nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, response,nil)
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(true, response, nil )
                            return
                    }
                    self.message = msg
                    completionHandler(true, self.message, dict["data"] as? [String : Any])
                }
                else{
                    completionHandler(false, response,nil)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    //Delete exsiting End Point
    
    @objc func deleteEndPointID(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.DELETE_END_POINT, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, response,nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, response,nil)
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(true, response, nil )
                            return
                    }
                    self.message = msg
                    completionHandler(true, self.message, dict["data"] as? [String : Any])
                }
                else{
                    completionHandler(false, response,nil)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    //register end point Code
    
    @objc func registerEndPoint(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.POST(api: API.REGISTER_END_POINT, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, response,nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, response,nil)
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "msg") as? String
                        else{
                            completionHandler(true, response, nil )
                            return
                    }
                    self.message = msg
                    completionHandler(true, self.message, dict["data"] as? [String : Any])
                }
                else{
                    completionHandler(false, response,nil)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    
    
    
    
    
    func getSacoaCardList(_ completionHandler : @escaping (_ success : Bool ,  _ response:SacoaCardBase?, _ message : String) -> Void){
        commMgr.GET(api: API.SACOA_CARDS, completionHandler: { (success, response) -> Void in
            
            
            if(success) {
                guard let data = response.data(using: .utf8)
                    else{
                        completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                guard let dict = self.getResponseDictionary(data)
                    else{
                        completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                guard let message = dict["message"] as? String
                    else {
                        completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                        return
                }
                let response = SacoaCardBase.init(dictionary: dict)
                completionHandler(true, response, message)
            }else{
                
                //completionHandler(false, nil, ERRORMESSAGE.NO_RECORD_FOUND)
                completionHandler(false, nil, "No card found")
            }
            
        })
        
    }
    
    
    
    func getSacoaCardTransaction(cardType: String, cardNumber: String,_ completionHandler : @escaping (_ success : Bool ,  _ response:SacoaTransactionBase?, _ message : String) -> Void){
          commMgr.GET(api: API.SACOA_CARDS_TRANSECTION+"\(cardType)&page=1&perPage=10&\(cardNumber)", completionHandler: { (success, response) -> Void in
              
              
              if(success) {
                  guard let data = response.data(using: .utf8)
                      else{
                          completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                          return
                  }
                  guard let dict = self.getResponseDictionary(data)
                      else{
                          completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                          return
                  }
                  guard let message = dict["message"] as? String
                      else {
                          completionHandler(true, nil, ERRORMESSAGE.NO_RESPONSE)
                          return
                  }
                  let response = SacoaTransactionBase.init(dictionary: dict)
                  completionHandler(true, response, message)
              }else{
                  completionHandler(false, nil, ERRORMESSAGE.NO_RESPONSE)
              }
              
          })
          
      }
    
    
    @objc func addSacoaCard(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
           
           do {
               let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
               let jsonString = String(data: jsonData, encoding: .utf8)
               commMgr.POST(api: API.ADD_SACOA_CARD, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                   if(success) {
                       guard let data = response.data(using: .utf8)
                           else{
                               completionHandler(true, response,nil)
                               return
                       }
                       guard let dict = self.getResponseDictionary(data)
                           else{
                               completionHandler(true, response,nil)
                               
                               return
                       }
                       guard let msg = dict.value(forKey: "message") as? String
                           else{
                               completionHandler(true, response, nil )
                               return
                       }
                       self.message = msg
                       completionHandler(true, self.message, dict["data"] as? [String : Any])
                   }
                   else{
                       completionHandler(false, response,nil)
                   }
               })
               
           } catch {
               Helper.printLog(error.localizedDescription as AnyObject?)
           }
       }
    
    
    
    @objc func addPaymentCard(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
              
              do {
                  let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                  let jsonString = String(data: jsonData, encoding: .utf8)
                  commMgr.POST(api: API.ADD_PAYMENT_CARDS, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                      if(success) {
                          guard let data = response.data(using: .utf8)
                              else{
                                  completionHandler(true, response,nil)
                                  return
                          }
                          guard let dict = self.getResponseDictionary(data)
                              else{
                                  completionHandler(true, response,nil)
                                  
                                  return
                          }
                          guard let msg = dict.value(forKey: "message") as? String
                              else{
                                  completionHandler(true, response, nil )
                                  return
                          }
                          self.message = msg
                          completionHandler(true, self.message, dict["data"] as? [String : Any])
                      }
                      else{
                          completionHandler(false, response,nil)
                      }
                  })
                  
              } catch {
                  Helper.printLog(error.localizedDescription as AnyObject?)
              }
          }
    
    
    @objc func deletePaymentCard(id : String, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
        
        do {
            
            commMgr.DELETE(api: API.DELETE_PAYMENT_CARDS+"?customerPaymentProfileId="+id, jsonString: nil, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, response,nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, response,nil)
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "message") as? String
                        else{
                            completionHandler(true, response, nil )
                            return
                    }
                    self.message = msg
                    completionHandler(true, self.message, dict["data"] as? [String : Any])
                }
                else{
                    completionHandler(false, response,nil)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    
    
    @objc func defaultPaymentCard(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            commMgr.PUT(api: API.DEFAULT_PAYMENT_CARDS, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, response,nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, response,nil)
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "message") as? String
                        else{
                            completionHandler(true, response, nil )
                            return
                    }
                    self.message = msg
                    completionHandler(true, self.message, dict["data"] as? [String : Any])
                }
                else{
                    completionHandler(false, response,nil)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    
     func getPaymentCardsList(_ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : PaymentCardBase?) -> Void) {
        
        do {
            commMgr.GET(api: API.PAYMENT_CARDS, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, response,nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, response,nil)
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "message") as? String
                        else{
                            completionHandler(true, response, nil )
                            return
                    }
                    self.message = msg
                    
                    let response = PaymentCardBase.init(dictionary: dict)
                    completionHandler(true, self.message, response)
                }
                else{
                    completionHandler(false, response,nil)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }
    
    
    
    
    @objc func rechargePaymentCard(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
                 
                 do {
                     let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                     let jsonString = String(data: jsonData, encoding: .utf8)
                     commMgr.POST(api: API.RECHARGE_SACOA_CARDS, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                         if(success) {
                             guard let data = response.data(using: .utf8)
                                 else{
                                     completionHandler(true, response,nil)
                                     return
                             }
                             guard let dict = self.getResponseDictionary(data)
                                 else{
                                     completionHandler(true, response,nil)
                                     
                                     return
                             }
                             guard let msg = dict.value(forKey: "message") as? String
                                 else{
                                     completionHandler(true, response, nil )
                                     return
                             }
                             self.message = msg
                             completionHandler(true, self.message, dict["data"] as? [String : Any])
                         }
                         else{
                             completionHandler(false, response,nil)
                         }
                     })
                     
                 } catch {
                     Helper.printLog(error.localizedDescription as AnyObject?)
                 }
             }
    
    
    
    
    @objc func addAmountOnWallet(dict : [String:Any]?, _ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : [String:Any]?) -> Void) {
                 
                 do {
                     let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                     let jsonString = String(data: jsonData, encoding: .utf8)
                     commMgr.POST(api: API.ADD_WALLET_MONEY, jsonString: jsonString, completionHandler: { (success, response) -> Void in
                         if(success) {
                             guard let data = response.data(using: .utf8)
                                 else{
                                     completionHandler(true, response,nil)
                                     return
                             }
                             guard let dict = self.getResponseDictionary(data)
                                 else{
                                     completionHandler(true, response,nil)
                                     
                                     return
                             }
                             guard let msg = dict.value(forKey: "message") as? String
                                 else{
                                     completionHandler(true, response, nil )
                                     return
                             }
                             self.message = msg
                             completionHandler(true, self.message, dict["data"] as? [String : Any])
                         }
                         else{
                             completionHandler(false, response,nil)
                         }
                     })
                     
                 } catch {
                     Helper.printLog(error.localizedDescription as AnyObject?)
                 }
             }
    
    
    
    func getDezerBucks(_ completionHandler : @escaping (_ sucsess : Bool, _ message : String, _ responseDict : DezerBucksBase?) -> Void) {
        
        do {
            commMgr.GET(api: API.GET_WALLET_MONEY, completionHandler: { (success, response) -> Void in
                if(success) {
                    guard let data = response.data(using: .utf8)
                        else{
                            completionHandler(true, response,nil)
                            return
                    }
                    guard let dict = self.getResponseDictionary(data)
                        else{
                            completionHandler(true, response,nil)
                            
                            return
                    }
                    guard let msg = dict.value(forKey: "message") as? String
                        else{
                            completionHandler(true, response, nil )
                            return
                    }
                    self.message = msg
                    
                    let response = DezerBucksBase.init(dictionary: dict)
                    completionHandler(true, self.message, response)
                }
                else{
                    completionHandler(false, response,nil)
                }
            })
            
        } catch {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }

    
    
}



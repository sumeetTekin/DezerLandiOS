//
//  Helper.swift
//  TestSwift
//
//  Created by Gurdev Singh on 12/30/14.
//  Copyright (c) 2014 Gurdev Singh. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
public enum TYPE : Int
{
    case BOOL = 1
    case INT
    case STRING
}



typealias VSAlertActionHandler  = ((_ buttonPressed: String) -> Void)?

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) {
            $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
        }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

public func allValues< T: Hashable>(_:T.Type) -> Array<T> {
    var allValues = [T]()
    let iterator = iterateEnum(T.self)
    for item in iterator {
        allValues.append(item)
    }
    
    return allValues
}


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Helper: NSObject {

   // let appDelegate : AppDelegate = AppDelegate().sharedInstance()

    
    class func SaveUserObject(_ user:UserModel?) {
        if let user = user {
            let dataUser = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.setValue(dataUser, forKey: USERDEFAULTKEYS.USERDETAIL)
        }
        else {
            UserDefaults.standard.setValue(nil, forKey: USERDEFAULTKEYS.USERDETAIL)
        }
        
        UserDefaults.standard.synchronize()
//        let fileSaved = NSKeyedArchiver.archiveRootObject(user, toFile: GetFilePath("User.plist"))
//        Helper.printLog(fileSaved as AnyObject?)
    }
    
    @objc class func ReadUserObject() -> UserModel? {
        if let data = UserDefaults.standard.object(forKey: USERDEFAULTKEYS.USERDETAIL) {
            if let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? UserModel {
                return user
            }
//            if let user = NSKeyedUnarchiver.unarchiveObject(withFile: GetFilePath("User.plist")) as? UserModel {
//                return user
//            }
        }
        return nil
        
    }
    class func SaveBooking(_ booking : Booking?) {
        if let booking = booking {
            let data = NSKeyedArchiver.archivedData(withRootObject: booking)
            UserDefaults.standard.set(data, forKey: USERDEFAULTKEYS.BOOKING)
        }
        else {
            UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.BOOKING)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    class func GetBooking() -> Booking? {
        if let data = UserDefaults.standard.value(forKey: USERDEFAULTKEYS.BOOKING) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Booking
        }
        return nil
    }
    class func SaveTempBooking(_ booking : Booking?) {
        if let booking = booking {
            let data = NSKeyedArchiver.archivedData(withRootObject: booking)
            UserDefaults.standard.set(data, forKey: USERDEFAULTKEYS.TEMPBOOKING)
        }
        else {
            UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.TEMPBOOKING)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    class func GetTempBooking() -> Booking? {
        if let data = UserDefaults.standard.value(forKey: USERDEFAULTKEYS.TEMPBOOKING) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Booking
        }
        return nil
    }
    @objc class func getBookingNumber() -> String? {
        
        if let bookingNumber = Helper.GetBooking()?.bookingNumber {
            return bookingNumber
        }
        else if let bookingNumber = AppInstance.applicationInstance.user?.booking_number {
            return bookingNumber
        }
        else {
            return nil
        }
    }
    @objc class func getRoomNumber() -> String? {
        if let room_number = Helper.GetBooking()?.roomNumber {
            return room_number
        }
        else if let room_number = AppInstance.applicationInstance.user?.room_number {
            return room_number
        }
        else {
            return nil
        }
    }
    
    class func saveValetNumber(num : String) {
        UserDefaults.standard.set(num, forKey: USERDEFAULTKEYS.VALETNUMBER)
        UserDefaults.standard.synchronize()
    }
    class func getValetNumber() -> String{
        if let num = UserDefaults.standard.object(forKey: USERDEFAULTKEYS.VALETNUMBER) as? String {
            return num
        }
        return ""
    }

    
   class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK: AlertView methods
    class func showCancelDialog(title : String, message : String, viewController : UIViewController) {
        let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CancelAlert) as! CancelAlert
        viewController.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.lbl_title.text = title
        objAlert.txtv_description.text = message == "" ? "Temporary disabled" : message
        viewController.present(objAlert, animated: false) {
        }
    }
    class func showAlertAction(sender: UIViewController, title: String, message: String,  buttonTitles : [String], completion: ((_ buttonPressed: String) -> Void)?) {
        
        DispatchQueue.main.async(execute: {
            
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for buttonTitle in buttonTitles {
                alertView.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction) -> Void in
                    completion!(action.title!)
                }))
            }
            sender.present(alertView, animated: true, completion: nil)
        })
        
    }
    @objc class func showalert(response: String){
        let bizObj = BusinessLayer()
        if let topController = UIApplication.topViewController() {
            if let data = response.data(using: .utf8){
                if let dictt = bizObj.getResponseDictionary(data) as? [String: AnyObject]{
                    let obj = ResponseModel(data: dictt)
                    Helper.showAlertAction(sender: topController, title: ALERTSTRING.TITLE, message: obj.message!, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                        if response == ALERTSTRING.OK{
                            let bizObject:BusinessLayer=BusinessLayer()
                            bizObject.signOut({ status, message in
                                Helper.showAlert(sender: topController, title: "", message: message)
                            })
                        }
                    })
                }
            }
            
        }
    }
    
    class func showAlertWithAction(sender: UIViewController, title: String, message: String,_ completionHandler : @escaping (_ action : UIAlertAction) -> Void){
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: ALERTSTRING.OK, style: .cancel) { action -> Void in
                completionHandler(action)
                alertView.dismiss(animated: true, completion: {
                
                    })
            }
            alertView.addAction(cancelAction)
            sender.present(alertView, animated: true, completion: nil)
        }
    }
    
   @objc class func showAlert(sender: UIViewController, title: String, message: String){
    DispatchQueue.main.async {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: ALERTSTRING.OK, style: .cancel) { action -> Void in
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(cancelAction)
        sender.present(alertView, animated: true, completion: nil)
      }
    }
    
    class func showPromocodeDialog(delegate : PromocodeDelegate? , navigationController : UINavigationController? , controller : UIViewController?) {
        let promoDialog = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.PromocodeVC) as! PromocodeVC
        promoDialog.delegate = delegate
        controller?.definesPresentationContext = true
        promoDialog.headerValue = "Please Enter your credits"
        promoDialog.modalPresentationStyle = .overCurrentContext
        promoDialog.modalTransitionStyle = .crossDissolve
        promoDialog.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            navigationController?.present(promoDialog, animated: true, completion: {
            })
        })
        
    }
    
    class func showddCardDialog(delegate : AddPlayCardDelegate? , navigationController : UINavigationController? , controller : UIViewController?) {
        let promoDialog = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "AddPlayCardVC") as! AddPlayCardVC
        promoDialog.delegate = delegate
        controller?.definesPresentationContext = true
        promoDialog.modalPresentationStyle = .overCurrentContext
        promoDialog.modalTransitionStyle = .crossDissolve
        promoDialog.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            navigationController?.present(promoDialog, animated: true, completion: {
            })
        })
        
    }
    
    
    
       
    class func AppDelegateSharedInstance() -> (AppDelegate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    
    class func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dataPath = documentsURL.appendingPathComponent("MyFolder")
        do {
            try FileManager.default.createDirectory(at: dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
        return dataPath
    }
    

    
    class func GetFilePath(_ fileName:String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(fileName)
        return fileURL.path
    }

    class func DeleteUserObject() {
        // remove instance in singleton objects.
        AppInstance.applicationInstance.user = nil
        AppInstance.applicationInstance.userLoggedIn = false
        kAppDelegate.isUserCheckedIn = false
        Helper.SaveUserObject(nil)
        DeleteAllFiles()
    }
    
    class func DeleteAllFiles() {
        let fileManager:FileManager=FileManager()
        do {
            
            let folderPathURL = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
            if let directoryURLs = try? fileManager.contentsOfDirectory(at: folderPathURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) {
                let listOfFiles = try? directoryURLs.filter { $0.pathExtension == "plist" }.map { $0.lastPathComponent }
                if let files = listOfFiles {
                    for file in files {
                        try fileManager.removeItem(atPath: GetFilePath(file))
                    }
                }
            }
        }catch let error as NSError{
            Helper.printLog(error.localizedDescription as AnyObject?)
        }
    }

    
    class func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    class func getCustomReusableViewsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "CustomReusableViews", bundle: nil)
    }
    class func getDialogsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Dialogs", bundle: nil)
    }
    class func getRemoteStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Remotes",bundle: nil)
    }
    class func getOrderHidtoryStoryboard() -> UIStoryboard{
        return UIStoryboard(name: "OrderHistory", bundle: nil)
    }
   @objc class func showLoader(title : String) {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.backgroundColor = UIColor.black
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config)
        SwiftLoader.show(title, animated: true)
    }
   @objc class func hideLoader() {
        SwiftLoader.hide()
    }
    class func printLog(_ logValue:AnyObject?) {
        if let log = logValue {
            print("\(log)")
        }
        
    }

    
    //MARK: Set Font methods
    class func setFont(fontName: String, fontSize: Float) -> UIFont{
        return UIFont(name: fontName, size: CGFloat(fontSize))!
    }
    
//    MARK: Set Language
    class func getCodeForLang(_ lang: String) -> String {
            switch lang {
            case LANGUAGE_KEY.ENGLISH, LANGUAGE_CODE.ENGLISH:
                return LANGUAGE_CODE.ENGLISH
            case LANGUAGE_KEY.SPANISH, LANGUAGE_CODE.SPANISH:
                return LANGUAGE_CODE.SPANISH
            case LANGUAGE_KEY.PORTUGESE, LANGUAGE_CODE.PORTUGESE, LANGUAGE_CODE.PORTUGESE_BRAZIL:
                return LANGUAGE_CODE.PORTUGESE
            case LANGUAGE_KEY.RUSSIAN, LANGUAGE_CODE.RUSSIAN:
                return LANGUAGE_CODE.RUSSIAN
            default:
                return LANGUAGE_CODE.ENGLISH
        }
    }
    class func getLangForCode(_ langCode: String) -> String {
        switch langCode {
        case LANGUAGE_KEY.ENGLISH, LANGUAGE_CODE.ENGLISH:
            return LANGUAGE_KEY.ENGLISH
        case LANGUAGE_KEY.SPANISH, LANGUAGE_CODE.SPANISH:
            return LANGUAGE_KEY.SPANISH
        case LANGUAGE_KEY.PORTUGESE, LANGUAGE_CODE.PORTUGESE, LANGUAGE_CODE.PORTUGESE_BRAZIL:
            return LANGUAGE_KEY.PORTUGESE
        case LANGUAGE_KEY.RUSSIAN, LANGUAGE_CODE.RUSSIAN:
            return LANGUAGE_KEY.RUSSIAN
        default:
            return LANGUAGE_KEY.ENGLISH
        }
    }
        
    class func changeToLanguage(_ langCode: String) {
        self.setAppLanguage(langCode)
        self.killApp()
    }
    class func setAppLanguage(_ langCode: String){
        UserDefaults.standard.set([self.getCodeForLang(langCode)], forKey: USERDEFAULTKEYS.APPLE_LANGUAGES)
        UserDefaults.standard.synchronize()
    }
    class func killApp(){
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        exit(EXIT_SUCCESS)
    }
    
    
    
    
    class func getCheckedTotal(menuArray : [Menu]) -> Float{
        var total : Float = 0
        for menu in menuArray {
            if menu.isChecked! {
                if let price = menu.item_price {
                    total = total + Float(price)!
                }
            }
        }
        return total
    }
    
    class func getQuantityTotal(menuArray : [Menu]) -> Float{
        var total : Float = 0
        for menu in menuArray {
            if let quantity = menu.quantity{
                if quantity > 0 {
                    if let price = menu.item_price {
                        if let pr = Float(price) {
                            total = total + pr * Float(quantity)
                        }
                    }
                }
            }
        }
        return total
    }
    class func getActualQuantityTotal(menuArray : [Menu]) -> Float{
        var total : Float = 0
        for menu in menuArray {
            if let quantity = menu.quantity{
                if quantity > 0 {
                    if let price = menu.before_discount_price {
                        if let pr = Float(price)  {
                            total = total + pr * Float(quantity)
                        }
                    }
                }
            }
        }
        return total
    }
    class func getAlohaQuantityTotal(menuArray : [Menu]) -> Float{
        var total : Float = 0
        let quantity = 1
        for menu in menuArray {
            
                    if let price = menu.item_price {
                        if let pr = Float(price) {
                            total = total + (pr * Float(quantity))
                        }
                    }
                    // Add modifier price
                    for modi in menu.selectedModifierArray{
                        //                            for modi in modiArray{
                        if let priceStr = modi.price {
                            if let price = Float(priceStr) {
                                total = total + price
                            }
                        }
                        //                            }
            }
        }
        return total
    }
    class func getAlohaMenuQuantityTotal(menuArray : [AlohaMenu]) -> Float{
        var total : Float = 0
        let quantity = 1
        for menu in menuArray {
            
            let price = menu.item_price
                total = total + (price * Float(quantity))
            // Add modifier price
            for subitem in menu.subItems{
                //                            for modi in modiArray{
                let price = subitem.item_price
                    total = total + price
                //                            }
            }
        }
        return total
    }
    class func getNumFrom(str : String) -> String? {
        let array =  (str.components(separatedBy: CharacterSet.decimalDigits.inverted))
        return (array as NSArray).componentsJoined(by:"");
    }
    class func call(number : String){
        if let num = Helper.getNumFrom(str: number) {
            let callStr = "tel://\(num)"
            if let url = URL(string: callStr) {
                self.callURL(url: url)
            }
        }
    }
    class func callURL(url : URL){
                UIApplication.shared.openURL(url)
    }
    class func getCellHeight(reservation : ReservationModel) -> CGFloat {
        return getCellHeight(tax: reservation.tax, taxPromoTotal: reservation.taxPromoTotal)
    }
    class func getCellHeight(tax : Tax?, taxPromoTotal : TaxPromoTotal?) -> CGFloat {
        let tax : Tax? = tax
        let taxPromo : TaxPromoTotal? = taxPromoTotal
        var height : CGFloat = 0
        if let sub_total = taxPromo?.sub_total {
            height = height + (tax != nil ? 25 : (sub_total == 0 ? 0 : 25))
        }
        if let discount = taxPromo?.promocodeDiscount {
            height = height + (discount == 0 ? 0 : 25) // for discount row
            height = height + (discount == 0 ? 0 : 25) // for discount subtotal row
        }
        if let service_charge_total = taxPromo?.service_charge_total {
            height = height + (tax?.state_tax != nil ? 25 : (service_charge_total == 0 ? 0 : 25))
        }
        if let delivery_charge_total = taxPromo?.delivery_charge_total {
            height = height + (delivery_charge_total == 0 ? 0 : 25)
        }
        if let state_tax_total = taxPromo?.state_tax_total {
            height = height + (tax?.state_tax != nil ? 25 : (state_tax_total == 0 ? 0 : 25))
        }
        if let county_tax_total = taxPromo?.county_tax_total {
            height = height + (tax?.county_tax != nil ? 25 : (county_tax_total == 0 ? 0 : 25))
        }
        
        height = height + (height > 0 ? 5 : 0)
        return height
    }
    
    //MARK: - Hide Loading Indicator
    class func deactivateView(_ view: UIView) {
        SwiftLoader.hide()
    }
    
//    MARK: HTML TEXT
    class func getHTMLAttributedString(text : String) -> NSMutableAttributedString? {
        do {
            let attributedString = try NSAttributedString(data: text.data(using: String.Encoding.unicode)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            let mutableString : NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            let range : NSRange = NSMakeRange(0, attributedString.length)
            mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: range)
            
            mutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: FONT_NAME.FONT_REGULAR, size: 15) ?? UIFont.systemFont(ofSize: 15)
                , range: range)
            return mutableString
            
        }
        catch let error {
            print (error.localizedDescription)
        }
        return nil
    }
    class func getCustomHTMLAttributedString(text : String) -> NSMutableAttributedString? {
        do {
            let attributedString = try NSAttributedString(data: text.data(using: String.Encoding.unicode)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            let mutableString : NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            let range : NSRange = NSMakeRange(0, attributedString.length)
            mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: range)
            
//            mutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: FONT_NAME.FONT_REGULAR, size: 15) ?? UIFont.systemFont(ofSize: 15)
//                , range: range)
            return mutableString
            
        }
        catch let error {
            print (error.localizedDescription)
        }
        return nil
    }
    class func getHTMLAttributedString(text : String, alignment : NSTextAlignment) -> NSMutableAttributedString? {
        
        do {
            let attributedString = try NSAttributedString(data: text.data(using: String.Encoding.unicode)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            let mutableString : NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            let range : NSRange = NSMakeRange(0, attributedString.length)
            mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: COLORS.LIGHTGREY_TEXT, range: range)
            mutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: FONT_NAME.FONT_REGULAR, size: 15) ?? UIFont.systemFont(ofSize: 15)
                , range: range)
//            let boldTag = "<b>"
//            if text.contains(find: boldTag) {
//                let index = text.index(after: boldTag.startIndex)
//                mutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.init(name: FONT_NAME.FONT_BOLD, size: 15) ?? UIFont.systemFont(ofSize: 15)
//                    , range: range)
//            }
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            mutableString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraph, range: range)
            return mutableString
        }
        catch let error {
            print (error.localizedDescription)
        }
        return nil
    }
    
//    MARK: Custom
    class func getFloatVal(str : String) -> Float {
        if let val = Float(str) {
            return val
        }
        return 0
    }
    class func getFirstName() -> String {
        #if DISTRIBUTION
            if let nameArray = AppInstance.applicationInstance.user?.name?.components(separatedBy: " ") {
                if let firstname = nameArray.first {
                    return firstname
                }
            }
            return ""
        #elseif LIVEDEV
                if let nameArray = AppInstance.applicationInstance.user?.name?.components(separatedBy: " ") {
                    if let firstname = nameArray.first {
                        return firstname
                    }
            }
        return ""
        #else
            return "DO NOT MAKE"
        #endif
        
    }
    class func getLastName() -> String {
        #if DISTRIBUTION
        if let nameArray = AppInstance.applicationInstance.user?.name?.components(separatedBy: " ") {
                if let lastname = nameArray.last {
                    return lastname
                }
            }
            return ""
        #elseif LIVEDEV
        if let nameArray = AppInstance.applicationInstance.user?.name?.components(separatedBy: " ") {
            if let lastname = nameArray.last {
                return lastname
            }
        }
        return ""
        #else
            return "DO NOT MAKE"
        #endif
    }
    class func getModifiersString(arr : [Modifier]) -> String {
        var modifiers = ""
        if arr.count > 0 {
            for index in 0...(arr.count - 1) {
                if let name = arr[index].name {
                    modifiers = modifiers.appending(name)
                    if (index < arr.count - 1) {
                        modifiers = modifiers.appending(" + ")
                    }
                }
            }
        }
        
        return modifiers
    }
    class func getStatusOfOrder(status : Int) -> String{
        switch status {
        case 0:
            return "Order submitted"
        case 1:
            return "The Kitchen has not started preparing the food";
        case 2:
            return "Preparing the food"
        case 3:
            return "Cooking the food"
        case 4:
            return "Cutting the food"
        case 5:
            return "Arranging the food on the plate"
        case 6:
            return "Place the food into a bag"
        case 7:
            return "Expediting the food"
        case 8:
            return "Work done in the Kitchen is complete"
        case 9:
            return "The food has been served"
        default:
            return "Order submitted"
        }
    }
    class func logScreen(screenName : String, className : String) {
        Analytics.logEvent(Event.Name, parameters: [
            Event.Name: screenName,
            Event.Class: className
            ])
    }
    class func getOrderMode(screenType : SubMenuDataType,beachLocation:Bool) -> Int {
        switch screenType {
        //Beach Dining 7
        case .tabs_quantity_selection: // beach pool
            if beachLocation{
                return 7 //Beach
            }
            return 9 //Pool
        case .quantity_selection: // in room dining
            return 3
        default:
            return 3
        }
    }
    class func getScreenType(orderMode : Int) -> SubMenuDataType {
        switch orderMode {
        case 9,7: // beach pool
            return .tabs_quantity_selection
        case 3: // in room dining
            return .quantity_selection
        default:
            return .quantity_selection
        }
    }
    class func getPaymentCode(type : String) -> Int {
        switch type {
        case TITLE.roomCharge:
            return 8
        case TITLE.creditCard:
            return 3
        case TITLE.cash:
            return 1
        default:
            return 3
        }
    }
    class func getPaymentType(orderMode : Int) -> String {
        switch orderMode {
        case 8:
            return TITLE.roomCharge
        case 3:
            return TITLE.creditCard
        case 1:
            return TITLE.cash
        default:
            return TITLE.creditCard
        }
    }
    class func getDepartment(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Department]?) -> Void) {
        
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status,message, deptItemArray) in
            if status {
                if deptItemArray.count > 0 {
                    completionHandlar(true,message,deptItemArray.first?.departments)
                }else{
                    completionHandlar(true,message, nil)
                }
            }else{
                if let controller = UIApplication.topViewController() {
                    Helper.showAlert(sender: controller, title: ALERTSTRING.ERROR, message: message)
                }
            }
        })
    }
    class func getCustomerNameDict() -> NSMutableDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(Helper.getFirstName(), forKey: "FirstName")
        dictionary.setValue(Helper.getLastName(), forKey: "LastName")
        return dictionary
        
    }
    
    
    //    MARK:DATE TIME ________________
    class func toLocalTime(getDate : Date)-> (Date){
        let tz = NSTimeZone.default
        let seconds = tz.secondsFromGMT(for: getDate)
        return Date.init(timeInterval: TimeInterval(seconds), since: getDate)
    }
    class func toGlobalTime(getDate : Date)-> (Date){
        let tz = NSTimeZone.default
        let seconds = -tz.secondsFromGMT(for: getDate)
        return Date.init(timeInterval: TimeInterval(seconds), since: getDate)
    }
    class func getDateModel() -> DateModel{
        let currentDate = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let weekday = calendar.component(.weekday, from: currentDate)
        let date = DateModel()
        date.date = day
        date.monthNo = month
        date.weekDayNo = weekday
        //        date.time = Helper.getStringFromDate(format: DATEFORMATTER.HA, date: currentDate)
        return date
    }
    class func getTimeModel() -> DateModel{
        let currentDate = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        let date = DateModel()
        date.weekDayNo = weekday
        // UTC time
        date.time = Helper.getStringFrom(date: currentDate, format: DATEFORMATTER.hhmma, zone: "ISO")
        return date
    }
//    class func checkTimeBetween(date1 : Date, date2: Date, current : Date) -> Bool{
//
//
//        let calendar = Calendar.current
//        var openingTime : DateComponents = DateComponents()
//        openingTime.hour = calendar.component(.hour, from: date1)
//        openingTime.minute = calendar.component(.minute, from: date1)
//
//        var closingTime : DateComponents = DateComponents()
//        closingTime.hour = calendar.component(.hour, from: date2)
//        closingTime.minute = calendar.component(.minute, from: date2)
//        var currentTime : DateComponents = DateComponents()
//        currentTime.hour = calendar.component(.hour, from: current)
//        currentTime.minute = calendar.component(.minute, from: current)
////        let currentTime : DateComponents = calendar.dateComponents(Set.init(arrayLiteral: .hour,.minute), from: current)
//
//        let times : NSMutableArray = [openingTime, closingTime, currentTime]
//        times.sort { (t1, t2) -> ComparisonResult in
//            if (t1 as! DateComponents).hour > (t2 as! DateComponents).hour {
//                return .orderedDescending
//            }
//            if ((t1 as! DateComponents).hour < (t2 as! DateComponents).hour) {
//                return .orderedAscending
//            }
//            if (t1 as! DateComponents).minute > (t2 as! DateComponents).minute {
//                return .orderedDescending
//            }
//            if ((t1 as! DateComponents).minute < (t2 as! DateComponents).minute) {
//                return .orderedAscending
//            }
//            return .orderedSame;
//        }
//        // if in middle
//        if times.index(of: currentTime) == 1 {
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
    class func getDateFromString(string: String, formatString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString //"yyyy-MM-dd HH:mm"
        dateFormatter.locale = NSLocale.current
        if let dateObj: Date = dateFormatter.date(from: string){
            return dateObj
        }
        return Date()
    }
    class func getDateFrom(formatString: String, dateString: String, toFormatString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString //"yyyy-MM-dd HH:mm"
        dateFormatter.locale = NSLocale.current
        if let dateObj: Date = dateFormatter.date(from: dateString){
            dateFormatter.dateFormat = toFormatString
            let newDateStr = dateFormatter.string(from: dateObj)
            if let newDate = dateFormatter.date(from: newDateStr) {
                return newDate
            }
            return dateObj
        }
        return Date()
    }
    
    class func getOptionalDateFromString(string: String, formatString: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString //"yyyy-MM-dd HH:mm"
        dateFormatter.locale = NSLocale.current
        return dateFormatter.date(from: string)
    }
    class func getOptionalTimeFromString(string: String, formatString: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString //"yyyy-MM-dd HH:mm"
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: string)
    }
    class func getStringFrom(date: Date, format: String, zone : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: zone)
        return dateFormatter.string(from: date)
    }
    class func getOptionalTimeFromString(string: String, formatString: String, zone : String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString //"yyyy-MM-dd HH:mm"
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: zone)
        return dateFormatter.date(from: string)
    }
    class func getTimeStringFromDate(format: String, date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    class func getStringFromDate(format: String, date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date)
    }
    class func getDateFrom(string: String, format: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: string)
    }
    
    class func getStringFromUTCDate(format: String, date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    
    class func getCurrentDateTime() -> Date {
        let calendar = Calendar.current
        let dateString =  "\(calendar.component(.year, from: Date()))-\(calendar.component(.month, from: Date()))-\(calendar.component(.day, from: Date())) \(calendar.component(.hour, from: Date())):\(calendar.component(.minute, from: Date()))"
        if let date = self.getOptionalDateFromString(string: dateString, formatString: DATEFORMATTER.YYYY_MM_DD_HH_MM) {
            return date
        }
        return Date()
    }
    
    class func getCurrentDateTimeString() -> String{
        let calendar = Calendar.current
        return "\(calendar.component(.year, from: Date()))-\(calendar.component(.month, from: Date()))-\(calendar.component(.day, from: Date())) \(Helper.getStringFromDate(format: DATEFORMATTER.HH_MM, date: Date()))"
        //        ""appointment_date"": ""2017-09-29 03:00""
    }
    class func getCurrentTimestampString() -> String {
        return "\(Date().timeIntervalSince1970)".trimmingCharacters(in: CharacterSet.init(charactersIn: "."))
    }
    class func generateFileName(strExtention: String) -> String{
        let randNum = arc4random() % (999999999 - 100000000) + 999999999; //create the random number.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        let dateString = formatter.string(from: Date())
        let name = "GoHotel" + dateString + "_\(randNum)" + "." + strExtention
        return name
    }
    
    
}



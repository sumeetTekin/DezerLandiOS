//
//  Constants.swift
//  TestSwift
//
//  Created by Gurdev Singh on 12/22/14.
//  Copyright (c) 2014 Gurdev Singh. All rights reserved.
//
import UIKit

let kAppDelegate  = UIApplication.shared.delegate as! AppDelegate
public var unlockFailedReason = ""
struct Device {
    
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT       = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH   = max(SCREEN_WIDTH, SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH   = min(SCREEN_WIDTH, SCREEN_HEIGHT)
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}
//Check weather mobileKeysDidStartup or not.
public var mobileKeysDidStartup = false
#if DEVELOPMENT
    public let baseURL =  "http://54.71.18.74:4122/api/v1/"//"http://52.34.207.5:4122/api/v1/"
#elseif LOCAL
    public let baseURL =  "http://172.24.5.13:4122/api/v1/"//"http://172.24.1.69:4001/api/v1/"
#elseif ALOHA
    public let baseURL =  "http://52.34.207.5:4155/api/v1/"
#elseif LIVEDEV
    public let baseURL =  "http://api.gohotellife.com:8080/api/v1/"
#elseif DEMO
    public let baseURL = "http://54.190.192.105:6042/api/v1/"//"http://54.71.18.74:4122/api/v1/"//"http://demo.gohotellife.com:8080/api/v1/"
#else
    public let baseURL =  "http://api.gohotellife.com:8080/api/v1/"
#endif

public let baseURLToGetInvitationVode =  "http://172.24.5.13:4001/api/v1/"//"http://localhost:4001/api/v1/"

public let trumpUrl = "http://www.trumpmiami.com"
struct KEYS {
    #if DISTRIBUTION
    static var TwitterConsumerKey:String = "Gw0dIGRSUg417OGYzRkbRdCPi"//"m5hWq79Nid41ZRhZdJx2uBnfg"
    static var TwitterConsumerSecret:String = "3PwG9OzDwxHidal3222g6nOlW2ql67eJ5xotRsJKjpEq56uuud"//"fvLyIV47k2WWtddN7CEbVj4KgIGyqtEFI7LfutLJnQ7cUy60A3"
    #else
    static var TwitterConsumerKey:String = "Gw0dIGRSUg417OGYzRkbRdCPi"//"sJv3HxE60KO4AJM5LtFB5p9Ei"
    static var TwitterConsumerSecret:String = "3PwG9OzDwxHidal3222g6nOlW2ql67eJ5xotRsJKjpEq56uuud"//"s32VfmVS4o87e4FE0pJn46qRl0cBu40lksPQjhf2ftCKjYOKxp"
    #endif
    
}
struct API {
    
    static var LOGIN_URL:String = baseURL+"login"
    static var GUEST_LOGIN_URL:String = baseURL+"guest/login"
    static var SIGNUP_URL:String = baseURL+"guest" //"signup"
    static var CHECK_EMAIL_EXIST_URL:String = baseURL+"guest/"//"user/"
    static var QUESTIONARY_URL:String = baseURL+"guest/questionary"//"questionary"
    static var COUNTRIES_URL:String = baseURL+"countries"
    static var CHECKFACEBOOK_URL:String = baseURL+"checkFaceBook"
    static var FORGOT_URL:String = baseURL+"forgotPassword?email="//"forgot"
    static var EDITUSER_URL:String = baseURL+"guest"//"account"
    static var DASHBOARD_URL:String = baseURL+"guestModules"//"modules"
    static var QRCodeScan:String = baseURL+"automobileSlug?slug="//"modules"
    //static var DASHBOARD_URL:String = baseURL+"guest/modules"
    
//    static var DASHBOARD_URL:String = baseURL+"demomodules"
    static var WEATHER_URL:String = baseURL+"guestWeather"//"weather"
    static var CHECKIN_URL:String = baseURL+"checkin"
    static var CHECKOUT_URL:String = baseURL+"checkout"
    static var SUBMENU_URL:String = baseURL+"getDepartments?_id="//"department/"
    static var DEPARTMENTSUBMENU_URL:String = baseURL+"getSubmenus?_id="//"submenu/"
    static var RESERVATION_URL:String = baseURL+"booking"//"appointment"
    static var DIRECTORDER_URL:String = baseURL+"appointmentoftime"
    
    static var MODIFY_RESERVATION_URL:String = baseURL+"changeorderrequest"
    static var CANCELRESERVATION_URL:String = baseURL+"appointment/"
    static var FETCH_MODULE_IMAGES_URL:String = baseURL+"getImages"
    static var FETCH_QUESTION_IMAGES_URL:String = baseURL+"questionaryImages"
    static var FETCH_DEPARTMENT_IMAGES_URL:String = baseURL+"departmentImages"
    static var RATE_URL:String = baseURL+"guest/rate"//"rate"
    static var SUPPORT_URL:String = baseURL+"guestCustomerSupport"//"customersupport"
    static var MAINTENANCE_ITEMS_URL:String = baseURL+"maintenacneitems"
    static var MAINTENANCE_REQUEST_URL:String = baseURL+"maintenancerequest"
    static var SERVICE_REQUEST_URL:String = baseURL+"servicerequest"
    static var LOGOUT_URL:String = baseURL+"guestLogout"//"logout"
    static var MODIFY_SUGGESTION_URL:String = baseURL+"suggestorder/"
    static var LOYALTY_URL : String = baseURL+"loyality/user"
    static var REQUEST_CAR_URL : String = baseURL+"requestcar"
    static var REDEEM_URL : String = baseURL+"generateCode"
    static var PROMOCODE_URL : String = baseURL+"applyPromoCode"
    static var PICKUP_TRAY_URL : String = baseURL+"pickTrayWebNotification"
    static var CONTACT_URL : String = baseURL+"guestContactReq"//"contactrequest"
    static var LOCAL_ATTRACTION_REQUEST_URL : String = baseURL+"localattractionrequest"
    static var SOCIAL_SHARE_URL : String = baseURL+"socialshare"
    static var BOOK_STAY_URL : String = baseURL+"bookyournextstay"
    static var CHECK_ROOM_URL : String = baseURL+"checkRoomNumber"
    static var CHECK_CHAIR_URL : String = baseURL+"checkChairNumber"
    static var APPOINTMENT_REORDER_URL : String = baseURL+"appointmentforreorder/"

//    MARK: ALOHA SMS
    static var BOOKING_ENQUIRY_URL : String = baseURL+"bookingEnqueryCheck"
    static var CHECKIN_ENQUIRY_URL : String = baseURL+"checkininquiry"
    static var SOAP_CHEKIN_URL : String = baseURL+"check_inSOAP"
    static var SOAP_CHECKOUT_URL : String = baseURL+"check_outSOAP"
    static var FOLIO_URL : String = baseURL+"folioinquiry"
    static var FOLIO_INQUIRY_CARD : String = baseURL+"folioinquiry_b"
    static var GET_MENU_URL:String = baseURL+"getmenuAloha"
    static var CALCULATE_TAX_URL:String = baseURL+"alohaCalculateTax"
    static var ORDER_CONFIRM_URL:String = baseURL+"alohaOrderConfirm"
    static var ORDER_CANCEL_URL:String = baseURL+"alohaOrderCancel/"
    static var USER_ADDITIONAL_FIELDS:String = baseURL+"userAdditionalFields"
    
    //Thermostat
    static var GET_DEVICE_LIST:String = baseURL + "getThermoDevice/"
    static var GET_DEVICE_INFO:String = baseURL + "getThermoDeviceInfo/"
    static var SET_DEVICE_Info:String = baseURL + "setThermoDeviceInfo/"
    
    
    // MARK ----Order History-----
    static var GET_ORDER_HISTORY:String = baseURL + "booking"//"user_orders/"
    // MARK ----Order Details -----
    static var GET_ORDER_DETAILS:String = baseURL + "get_appointment/"
    static var ORDER_RATING:String = baseURL + "orderRating"
    
    
    static var CREATE_INVITATION_CODE:String = baseURL+"createInvitationCode"
    static var REGISTER_END_POINT:String = baseURL+"registerEndpoint"
    static var DELETE_END_POINT:String = baseURL + "deleteEndPoint"
    static var SACOA_CARDS:String = baseURL + "getSacoaCard"
    static var ADD_SACOA_CARD:String = baseURL + "addSacoaCard"
    static var PAYMENT_CARDS:String = baseURL + "paymentCards"
    static var ADD_PAYMENT_CARDS:String = baseURL + "paymentCards"
    static var DELETE_PAYMENT_CARDS:String = baseURL + "paymentCards"
    static var DEFAULT_PAYMENT_CARDS:String = baseURL + "paymentCards"
    static var RECHARGE_SACOA_CARDS:String = baseURL + "rechargeSacoaCard"
    static var ADD_WALLET_MONEY:String = baseURL + "dezerBucks"
    static var GET_WALLET_MONEY:String = baseURL + "dezerBucks"
    static var SACOA_CARDS_TRANSECTION:String = baseURL + "getTransactions?cardType="
}

struct UBER {
    static var CLIENT_ID = "4RU4oe5VnwcxihdfcbKo5EkkMmMLJmqB"
}

struct LYFT {
    static var CLIENT_ID = "aEe7nWGO9Dbi"
}

struct RESPONSECODE{
enum CODE:Int {
    case SUCCESS = 200
    case NOTFOUND = 204
 }
}

struct COLORS {
    static let THEME_BLUE_COLOR : UIColor = UIColor(red: 80.0/255, green: 193.0/255, blue: 178.0/255 , alpha: 1.0)
    static let GREEN_COLOR : UIColor = UIColor(red: 60.0/255, green: 176.0/255, blue: 163.0/255 , alpha: 1.0)
    static let DARKGREY_COLOR : UIColor = UIColor(red: 30.0/255, green: 38.0/255, blue: 45.0/255 , alpha: 1.0)
    static let LIGHTGREY_COLOR_WITH_ALPHA : UIColor = UIColor(red: 30.0/255, green: 38.0/255, blue: 45.0/255 , alpha: 0.5)
    static let LIGHTGREY_TEXT : UIColor = UIColor(red: 117.0/255, green: 130.0/255, blue: 137.0/255 , alpha: 1.0)
    static let LIGHTBLUE_SEAT : UIColor = UIColor(red: 70.0/255, green: 142.0/255, blue: 183.0/255 , alpha: 1.0)
    static let THEME_YELLOW_COLOR : UIColor = UIColor(red: 255.0/255, green: 212.0/255, blue: 41.0/255 , alpha: 1.0)
}

struct APPDETAILS {
    static var ITUNES_STORE_URL = ""
}

struct DEVICES {
    enum enDeviceFamily:Int {
        case iPhone4S
        case iPhone5Family
        case iPhone6
        case iPhone6Plus
    }
    static var DEVICE : enDeviceFamily = enDeviceFamily.iPhone6Plus
}

struct CONNECTIONMODE {
    enum enBuildConnection:Int {
        case LIVE
        case Staging
        case Dev
    }
}

struct SHARINGMODE {
    enum enShareUsing:Int {
        case c
        case TWITTER
        case EMAIL
    }
}

struct SUB_MENU_TYPE {
    enum enSubMenu:Int {
        case DIRECTIONS_TO_AIRPORT
    }
}

enum CellType {
    case checkboxCell
    case countCell
    case none
}

enum SubMenuDataType {
    
    case service_selection
    case quantity_selection
    case restaurant
    case reservation
    case service_request
    case sharing
    case link
    case attraction
    case tabs_quantity_selection
    case submenu_selection
    case maintenance_request
    case kid_zone
    case instant_order
    case def
    
}

enum ItemType {
    case contact
    case website
    case local_attraction
    case def
}
enum OrderType {
    case direct
    case indirect
}
enum SubModuleType {
    case directions
    case checkout
    case subCell
    case textDirection
    case socialMediaShare
    case subMenu
    case booking
    case sacoaCard
}
enum LoginType : Int{
    case normal = 0
    case facebook = 1
}

enum UserType : Int {
    case hotelGuest = 1
    case trumpRoyaleResident = 2
    case trumpPalaceResident = 3
}
enum UserRole : Int{
    case tenant = 1
    case owner = 2
}
func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

enum FanSpeed : String{
    case auto
    case high
    case low
    case medium
}

enum Mode : String{
    case auto
    case off
    case cool
    
}

struct USERDEFAULTKEYS {
    static var PASSWORD = "password"
    static var ALREADY_LOGIN = "already_login"
    static var RECIEVE_NOTIFICATION = "RecieveNotification"
    static var APPLE_LANGUAGES = "AppleLanguages"
    static var DEVICE_TOKEN =  "DeviceTokenString"
    static var LOGIN_TYPE =  "LoginType"
    static var BOOKING =  "BOOKING"
    static var TEMPBOOKING =  "TEMPBOOKING"
    static var USERDETAIL =  "USERDETAIL"
    static var VALETNUMBER =  "VALETNUMBER"
}

struct STORYBOARD {//Don't add localization
    static let LAUNCH = "LaunchVC"
    static let LOGIN = "LoginVC"
    static let SIGNUP = "SignUpVC"
    static let DASHBOARD = "Dashboard"
    static let HOME = "HomeVC"
    static let LOYALITY = "LoyalityVC"
    static let FEEDBCAK = "FeedbackVC"
    static let ALERT = "AlertView"
    static let DIRECTIONS_MENU = "DirectionsMenuVC"
    static let SUB_MENU = "SubMenuVC"
    static let CHECKIN = "CheckInVC"
    static let CHECKOUT = "CheckOutVC"
    static let CHECKIN_CARD = "CheckInCardVC"
    static let UPGRADE_SUITE = "UpgradeSuiteVC"
    static let THANKS = "ThanksVC"
    static let EDIT_CARD = "EditCardVC"
    static let SUGESTIONVC = "SuggestionVC"
    static let NotificationDialogVC = "NotificationDialogVC"
    static let NotificationMarketingVC = "NotificationMarketingVC"
    static let RedeemVC = "RedeemVC"
    static let SupportVC = "SupportVC"
    static let ThermostatVC = "ThermostatVC"
    static let ShareOnSocialMediaVC = "ShareOnSocialMediaVC"
    static let QRCodeScanVC = "QRCodeScanVC"
    static let ReservationFirstVC = "ReservationFirstVC"
    static let ReservationSecondVC = "ReservationSecondVC"
    static let CarDetailVC = "CarDetailVC"

}

struct REUSABLEVIEWS{//Don't add localization
    static let CustomTable = "CustomTable"
    static let QRTimerVC = "QRTimerVC"
    static let DateTimeVC = "DateTimeVC"
    static let ConfirmationVC = "ConfirmationVC"
    static let CustomAlertView = "CustomAlertView"
    static let MaintainanceRequestVC = "MaintainanceRequestVC"
    static let BeachPoolTabVC = "BeachPoolTabVC"
    static let OrderVC = "OrderVC"
    static let PostcardVC = "PostcardVC"
    static let BookingDayVC = "BookingDayVC"
    static let PreviewVC = "PreviewVC"
    static let PreviewReservationVC = "PreviewReservationVC"
    static let AlohaOrderPreview = "AlohaOrderPreview"
    static let PoolDinePaymentDialog = "PoolDinePaymentDialog"
    
//    static let PreviewInstantOrderVC = "PreviewInstantOrderVC"
    static let BookingDetailVC = "BookingDetailVC"
    static let PlanetKidsOrderVC = "PlanetKidsOrderVC"
    static let RestaurantMenuVC = "RestaurantMenuVC"
    static let RestaurantInformation = "RestaurantInformationVC"
    static let ExtraAmenitiesVC = "ExtraAmenitiesVC"
    static let QuantityPickerVC = "QuantityPickerVC"
    static let PromocodeVC = "PromocodeVC"
    static let CoupleDialog = "CoupleDialog"
    static let DisclaimerVC = "DisclaimerVC"
    static let CancelAlert = "CancelAlert"
    static let ItemDescriptionVC = "ItemDescriptionVC"
    static let InvoiceVC = "InvoiceVC"
    static let SelectBookingsVC = "SelectBookingsVC"
    static let RemoveMenuVC = "RemoveMenuVC"
    
}

struct SEGUE_IDENTIFIER {//Don't add localization
    static let PROFESSIONAL_OBJECTIVE = "ProfessionalObjective"
    static let INTERESTS_HOBBIES = "InterestesHobbies"
    static let BASIC_INFO = "BasicInfo"
    static let DASHBOARDSEGUE = "DashboardSegue"
    static let FACEBOOKLOGIN = "FacebookLogin"
    static let SIGNUP = "SignupSegue"
}
struct NotificationIdentifiers {
    static let open = "Open"
    static let customPush = "CustomPush"
}

struct CELL_IDENTIFIER {//Don't add localization
    //CollectionView
    static let DASHBOARD = "DashboardCell"
    static let LOYALITY = "LoyalityCell"
    static let DIRECTIONS = "DirectionsCell"
    static let DATECELL = "DateCell"
    static let REMOVE_MENU_CELL = "RemoveCell"
    static let SEAT_CELL = "seatCell"
    

    
    //CollectionReusable view
    static let LOYALITY_HEADER = "LoyalityHeaderView"
    static let REQUEST_CAR_HEADER = "RequestCarReusableView"
    static let DASHBOARD_FOOTER = "DashboardFooterReusableView"
    
    //TableView
    static let SUB_MENU = "SubMenuCell"
    static let LOCAL_ATTRACTION = "LocalAttractionCell"
    static let CHECKIN_CREDIT = "CreditCard"
    static let CHECKIN_DATES = "Dates"
    static let CHECKIN_UPGRADE = "UpgradeButton"
    
    static let CUSTOM_CELL = "customCell"
    static let CUSTOM_TABLE_CELL = "CustomTableCell"
    static let CUSTOM_TABLE_CELL_NO_SPACE = "CustomTableCellNoSpace"
    
    static let CUSTOM_TABLE_CHECK_CELL = "CustomTableCheckCell"
    
    static let CONFIRMATION_NUMBER = "ConfirmationNumber"
    static let BOOKING_DATE = "BookingDate"
    static let BOOKING_DATE_TIME = "BookingDateTime"
    
    static let BOOKING_ORDER_CHAIR = "OrderChairCell"
    static let BOOKING_DAY = "DayCell"
    static let BOOKING_ORDER = "OrderCell"
    static let BOOKING_CHAIR = "ChairCell"
    static let BOOKING_People = "PeopleCell"
    static let TAX_CELL = "TaxCell"
    static let PROMO_CELL = "PromoCell"
    static let HEADER_CELL = "HeaderCell"
    
    
    static let BOOKING_NUMBER = "BookingNumber"
    static let BOOKING_QUANTITY = "BookingQuantity"
    static let BOOKING_QUANTITY_DELETE = "BookingQuantityDelete"
    static let BOOKING_TOTAL = "BookingTotal"
    static let BOOKING_GENDER = "BookingGender"
    static let BOOKING_CANCEL = "BookingCancel"
    static let BOOKING_OCCASION = "BookingOccasion"
    static let INVOICE_CELL = "InvoiceCell"
    static let AmenitiesCell = "AmenitiesCell"
    static let MODIFIER_CELL = "ModifierCell"
    static let DESCRIPTION_CELL = "DescriptionCell"
    static let PAYMENT_DETAIL_CELL = "PaymentDetailCell"
    static let ALOHA_MENU_CELL = "AlohaMenuCell"
    static let ALOHA_ORDER_STATUS_CELL = "AlohaOrderStatusCell"
    static let BOOKING_INSTRUCTOR_CELL = "BookingInstructor"
    static let ORDER_TIME_CELL = "OrderTimeCell"
    static let CarDetailCell = "CarDetailCell"
    static let VideoCell = "VideoCell"
    static let ImageCell = "ImageCell"
    static let textFieldCell = "TextFieldCell"
    static let dateTimeCell = "DateTimeCell"
    static let ReservationDetailCell = "ReservationDetailCell"

    
    
    //Card
    static let CARD_CELL = "CardCell"
    static let CARD_ADD = "CardCellAdd"
    static let CARD_SAVE = "CardCellSave"
    static let CARD_CHECKOUT = "CardCellCheckOut"
    static let BOOKING_CELL = "BookingCell"
    
}

struct DATEFORMATTER {//Don't add localization
    static var YYYYMMDD = "yyyy-MM-dd"
    static var DDMMYYYYMM = "dd-MM-yyyy"
    static var DDMMYYYY = "dd/MM/yyyy"
    static var MMDDYYYY = "MM/dd/yyyy"
    static var MMDDYYYY_HH_MM = "MM/dd/yyyy HH:mm"
    static var MMDDYYYY_HH_MM_A = "MM/dd/yyyy hh:mm a"
    static var YYYY_MM_DD = "yyyy/MM/dd"
    static var DD_MMM = "dd MMM"
    static var DD_MMMM = "dd MMMM"
    static var DD_MMM_YYYY = "dd MMM yyyy"
    static var DD_MMMM_YYYY = "dd MMMM yyyy"
    static var DD_MM_YYYY = "dd-MM-yyyy"
    static var DD_MMMYYYY = "dd MMM, yyyy"
    static var DD_MMM_YYYY_HH_MM_A = "dd MMM yyyy hh:mm a"
    static var HH_MM_A = "h:mm a"
    static var HH_MMA = "h:mma"
    static var hhmma = "hh:mma"
    static var HHmma = "HH:mma"
    
    static var H_MM = "H:mm"
    static var HH_MM = "HH:mm"
    static var YYYY_MM_DD_HH_MM = "yyyy-MM-dd HH:mm"
    static var YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss"
    static var YYYY_MM_DD_HH_MM_ZZZZZ = "yyyy-MM-dd HH:mm ZZZZZ"
    static var DD = "d"
    static var H = "H"
    static var h = "h"
    static var HA = "h a"
    static var MMM = "MMM"
    static var MMMM = "MMMM"
    static var YYYY = "yyyy"
    static var YYYY_MM_DD_T_HH_MM_SS_A = "yyyy-MM-dd'T'HH:mm:ssZZZ"
    static var YYYY_MM_DD_T_HH_MM_SS = "yyyy-MM-dd'T'HH:mm:ss"
    static var YYYY_MM_DD_T_HH_MM_SS_SSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static var ZZZZZ = "ZZZZZ"

}

struct FONT_NAME {//Don't add localization
    static let FONT_LIGHT = "GothamRounded-Light"
    static let FONT_REGULAR = "GothamRounded-Book"
    static let FONT_SEMIBOLD = "GothamRounded-Medium"
    static let FONT_BOLD = "GothamRounded-Bold"
}

struct LANGUAGE_KEY {//Don't add localization here as these are keys
    static let ENGLISH = "English"
    static let SPANISH = "Spanish"
    static let PORTUGESE = "Portuguese"
    static let RUSSIAN = "Russian"
}
struct LANGUAGE_CODE {//Don't add localization here as these are keys
    static let ENGLISH = "en"
    static let SPANISH = "es"
    static let PORTUGESE = "pt"
    static let PORTUGESE_BRAZIL = "pt-BR"
    static let RUSSIAN = "ru"
}
struct BOOKINGSTATUS {
    static let INH = "INH"
    static let NEW = "NEW"
    static let CNF = "CNF"
    static let CL = "C/L"
    static let CAN = "CAN"
    static let OUT = "OUT"
}
struct Event {
    static let Name = "screen_view"
    static let Class = "screen_class"
  
}

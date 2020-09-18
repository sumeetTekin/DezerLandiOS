//
//  ConstantStrings.swift
//  Quealth
//
//  Created by isteam on 07/10/15.
//  Copyright © 2015 Gurdev Singh. All rights reserved.
//

import UIKit

public typealias KeyValue  = [String : Any]

public let KMainStoryboard  =  "Main"

struct TITLE {
    static let HOME     = LocalizedString("Home")
    static let LOYALTY = LocalizedString("Dezer Bucks")
    static let FEEDBACK = LocalizedString("How's your experience?")
    static let FOOD = LocalizedString("Food")
    static let BEVERAGES = LocalizedString("Beverages")
    static let POST_MERIDIAN = LocalizedString("post_meridian")
    static let ANTE_MERIDIAN = LocalizedString("ante_meridian")
    static let MaintenanceRequest = LocalizedString("Maintenance Request")
    static let Total = LocalizedString("Total")
    static let Modify = LocalizedString("Modify")
    static let Cancel = LocalizedString("Cancel")
    static let Confirm = LocalizedString("Confirm")
    static let Call = LocalizedString("Call Department")
    static let Order = LocalizedString("Order")
    static let Proceed = LocalizedString("Proceed")
    static let Required = LocalizedString("Required")
    static let Breakfast_Menu = LocalizedString("Breakfast Menu")
    static let Lunch_Menu = LocalizedString("Lunch Menu")
    static let Dinner_Menu = LocalizedString("Dinner Menu")
    static let All_day_dining = LocalizedString("All day dining")
    static let Mobile_Check_Out = LocalizedString("Mobile Check Out")
    static let Welcome = LocalizedString("Welcome")
    static let Disclaimer = LocalizedString("Disclaimer")
    static let NumberOfPeople = LocalizedString("NumberOfPeople")
    static let Therapist = LocalizedString("Therapist")
    static let DailyEvent = LocalizedString("DailyEvent")
    static let RoomNumber = LocalizedString("Room Number")
    static let ChairRoomNumber = LocalizedString("ChairRoomNumber")
    static let ChairNumber = LocalizedString("ChairNumber")
    static let BeachLocation = LocalizedString("BeachLocation")
    static let OrderNumber = LocalizedString("Order Number")
    static let subTotal = LocalizedString("Sub Total")
    static let totalDiscount = LocalizedString("Total Discount")
    static let subtotalAfterDiscount = LocalizedString("Sub Total After Discount")
    static let orderStatus = LocalizedString("Order Status")
    static let prepTime = LocalizedString("Preparation Time")
    static let orderTime = LocalizedString("Order Time")
    static let deliveryTime = LocalizedString("Delivery Time")
    static let tax = LocalizedString("Tax")
    static let statetax = LocalizedString("StateTax")
    static let countytax = LocalizedString("CountyTax")
    static let serviceCharge = LocalizedString("ServiceCharge")
    static let deliveryCharge = LocalizedString("DeliveryCharge")
    static let date = LocalizedString("Date")
    static let duration = LocalizedString("Duration")
    static let instructor = LocalizedString("Instructor")
    static let howMany = LocalizedString("How Many")
    static let checkedOut = LocalizedString("Checked out")
    static let roomCharge = LocalizedString("Room Charge")
    static let creditCard = LocalizedString("Credit Card")
    static let cash = LocalizedString("Cash")
    static let howToPay = LocalizedString("HowToPay?")
    static let tenant = LocalizedString("Tenant")
    static let owner = LocalizedString("Owner")
    static let residentPhotoId = LocalizedString("Resident Photo Id")
    static let trumpPalaceResident = LocalizedString("Trump Palace Resident")
    static let trumpRoyaleResident = LocalizedString("Trump Royale Resident")
    static let hotelGuest = LocalizedString("Hotel Guest")
    static let beachNote = LocalizedString("BeachNote")
    static let pickSection = LocalizedString("PickSection")
    
    static let ChooseDate = LocalizedString("Choose Date")
    static let ChooseTime = LocalizedString("Choose Time")
    static let booked = LocalizedString("Booked")
    static let yourSelection = LocalizedString("Your selection")
    
    static let bowlingReservation = LocalizedString("Bowling Reservation")
    static let reservationName = LocalizedString("Reservation Name:")
    static let kidsTitle = LocalizedString("Kids:")
    static let numberofguests = LocalizedString("Number of people:")
    static let nameTitle = LocalizedString("Name:")
    static let emailTitle = LocalizedString("Email:")
    static let durationTitle = LocalizedString("Duration:")
    static let dateTitle = LocalizedString("Date:")
    static let timeTitle = LocalizedString("Time:")
    
    static let modelTitle = LocalizedString("Model:")
    static let makeTitle = LocalizedString("Make:")
    static let yearTitle = LocalizedString("Year:")
    static let bodyStyleTitle = LocalizedString("Body Style:")
    static let transmission = LocalizedString("Transmission:")
    static let description = LocalizedString("Description:")
    static let movieTitle = LocalizedString("Movie:")
    static let invalidQrCode = LocalizedString("Invalid QR Code")
    
    static let status = LocalizedString("Status")
    static let cardNumber = LocalizedString("Card Number")
    static let balance = LocalizedString("Balance")
    static let tickets = LocalizedString("Tickets")
    static let bonus = LocalizedString("Bonus")
     static let amount = LocalizedString("Amount")
    
    
    
    
}

struct MENU_ITEM {
    static let DIRECTIONS_TO_AIRPORT = "Directions\nto Airport"
    static let DIRECTION_TO_HOTEL = "Directions to Hotel"
    static let MOBILE_CHECK_IN = "Mobile Check In"
    static let MOBILE_CHECK_OUT = "Mobile Check Out"
    static let BEACH_AND_POOL = "Beach and Pool"
    static let SPA_AND_HAIR_SALON = "Spa and Hair Salon"
    static let DINE_NOW = "Dine Now"
    static let DINE_LATER = "Dine Later"
    static let RECREATION = "Recreation"
    static let REQUEST_CAR = "Request Car"
    static let HOUSE_KEEPING = "HouseKeeping"
    static let OFFERS_AND_LOCAL_ATTRACTIONS = "Offers and Local Attractions"
}

struct PLACEHOLDER {
    static var Email = LocalizedString("Email")
    static var Password = LocalizedString("Password")
    static var birthday = LocalizedString("Birthday (Month and Day)")
    static var anniversary = LocalizedString("Anniversary (Month and Day)")
    static var addComment = LocalizedString("Add Comment")
    static var specialRequest = LocalizedString("Special Requests")
    static var selectOccasion = LocalizedString("Select Occasion")
    static var selectDuration = LocalizedString("Select Duration")
    static var question = LocalizedString("Question")
    static var selectPayment = LocalizedString("Select_Payment")
    static var unitNumber = LocalizedString("Unit Number")
    static var choose_duration = LocalizedString("Choose Duration")
    
}

struct BUTTON_TITLE {
    static var Update = LocalizedString("Update")
    static var Next = LocalizedString("Next")
    static var Continue = LocalizedString("Continue")
    static var Confirm = LocalizedString("Confirm")
    static var Submit = LocalizedString("Submit")
    static var CloseNow = LocalizedString("Close now")
    static var Cancel = LocalizedString("Cancel")
    static var Yes = LocalizedString("Yes")
    static var No = LocalizedString("No")
    static var Change_request = LocalizedString("Change Request")
    static var Customer_support = LocalizedString("Customer Support")
    static var I_AGREE = LocalizedString("I_AGREE")
    static var Room_Temprature = LocalizedString("Room Temprature")
    static var Order_History = LocalizedString("Order History")
    static var Go_Back = LocalizedString("Go Back")
    static var Delete = LocalizedString("Delete")
    static var addCard = LocalizedString("Add Card")
    static var recharge = LocalizedString("Recharge")
    static var paymentHistory = LocalizedString("Payment History")
    
}

struct LOADER_TEXT {
    static var loading = LocalizedString("Loading")
    static var Updating = LocalizedString("Updating")
    static var SigningIn = LocalizedString("Signing In")
    static var SigningUp = LocalizedString("Signing Up")
    static var SigningOut = LocalizedString("Logging Out")
}

struct ALERTSTRING {
    static var TITLE                    = LocalizedString("Dezerland")
    static var ERROR                    = LocalizedString("Error")
    static var REQUIRED                 = LocalizedString("Required")
    static var OK                       = LocalizedString("OK")
    static var VALID_NAME               = LocalizedString("Please enter a name.")
    static var VALID_EMAIL              = LocalizedString("Please enter a valid email address.")
    static var VALID_PHONE              = LocalizedString("Please enter a valid phone number.")
    static var VALID_BIRTHDATE          = LocalizedString("Please enter a valid date in format MM/DD.")
    static var VALID_CITY               = LocalizedString("Please enter a valid city.")
    static var VALID_COUNTRY            = LocalizedString("Please select a country.")
    static var VALID_PASSWORD_LEAST     = LocalizedString("Please enter at least 6 character password.")
    static var VALID_BOOKING            = LocalizedString("Please enter a valid booking number.")
    static var CONFIRM_PASSWORD_NOTMATCHING = LocalizedString("Confirm Password is not matching with Password.")
    static var FORGOT_PASSWORD_SUCCESS  = LocalizedString("We have emailed you a link to reset your password.")
    static var SELECT_LANGUAGE          = LocalizedString("Select Language")
    static var LANGUAGE_ENGLISH         = LocalizedString("English")
    static var LANGUAGE_SPANISH         = LocalizedString("Spanish")
    static var LANGUAGE_PORTUGUESE      = LocalizedString("Portuguese")
    static var LANGUAGE_RUSSIAN      = LocalizedString("Russian")
    static var CANCEL                   = LocalizedString("Cancel")
    static var LANGUAGE_CHANGE_MESSAGE  = LocalizedString("In order to change the language, the App must be closed and reopened by you.")
    static var APP_RESTART_REQUIRED     = LocalizedString("App restart required")
    static var THANKS_FOR_FEEDBACK     = LocalizedString("Thanks for Feedback")
    static var REACHED_MAXIMUM_LIMIT = LocalizedString("You have reached to the maximum limit for this item.")
    static var THANKS                  = LocalizedString("Thanks")
    static var POSTED                  = LocalizedString("Posted")
    static var PAST_DATE = LocalizedString("Please select future Date & Time.")
    static var FACEBOOK_EMAIL_REQUIRED = LocalizedString("Facebook email permission is required.")
    static var SELECT_AN_ITEM = LocalizedString("Please select an item.")
    static var REQUIRED_QUANTITY = LocalizedString("Please enter required quantity.")
    static var ROOM_NUMBER = LocalizedString("Please enter room number.")
    static var EMPTY_COMMENT_BOX = LocalizedString("Please enter your comment.")
    static var NO_DESCRIPTION = LocalizedString("Please enter some text(Max. 140).")
    static var NO_COMMENT = LocalizedString("Please enter some comment.")
    static var NO_CHAIR_NUMBER = LocalizedString("Please enter your chair number.")
    static var ORDER_NOT_CANCELLED = LocalizedString("Order not cancelled.")
    static var ORDER_CANCELLED = LocalizedString("Order cancelled.")
    static let AgreeTerms = LocalizedString("AgreeTerms")
    static let DiscountText = LocalizedString("DiscountText")
    static let CancelOrder = LocalizedString("CancelOrder")
    static let contactus = LocalizedString("ContactUs")
    static let wouldYouLike = LocalizedString("WouldYouLike")
    static let SelectPayment = LocalizedString("SelectPayment")
    static let uploadPhoto = LocalizedString("UploadPhoto")
    static let enterUnitNumber = LocalizedString("EnterUnitNumber")
    static let selectImage = LocalizedString("PleaseSelectImage")
    static let WouldYouLikeToGetDigitalKey = LocalizedString("Would you like to get digital key ?")
    static let RoomUpgradation = LocalizedString("Please contact front desk for room upgradation")
    static let removeCard = LocalizedString("Do you want to remove this card?")
    static let defaultCard = LocalizedString("Do you want to make this card your Default payment method?")
    static let expires = LocalizedString("Expires ")
}

struct ERRORMESSAGE {
    static var NO_RESPONSE = LocalizedString("No response")
    static var INCORRECT_RESPONSE = LocalizedString("Incorrect response")
    static var TRY_AGAIN = LocalizedString("Please try again.")
    static var INVALID_REQUEST = LocalizedString("Invalid Request.")
    static var NO_RECORD_FOUND = LocalizedString("No record found.")
    static var CAMERA_NOT_AVAILABLE = LocalizedString("Camera not available.")
    static var PHOTOS_NOT_AVAILABLE = LocalizedString("Photos not available.")
    static var FACEBOOK_NOT_AVAILABLE  = LocalizedString("Facebook app not available.")
    static var TWITTER_NOT_AVAILABLE   = LocalizedString("Twitter app not available.")
    static var INSTAGRAM_NOT_AVAILABLE = LocalizedString("Instagram app not available.")
    static var NO_IMAGE = LocalizedString("No image selected")
    static var NO_TYPE = LocalizedString("No type selected")
    static var KINDLY_TRY_AGAIN = LocalizedString("Try again")
}

struct RATING_EXPERINECE {
    static var WORST = LocalizedString("Worst")
    static var BAD = LocalizedString("Bad")
    static var NORMAL = LocalizedString("Normal")
    static var GOOD = LocalizedString("Good")
    static var BEST = LocalizedString("Best")
    static var PLACEHOLDER_TEXT = LocalizedString("Leave a comment...")
}

struct LOCKERRORCODES {
    static  var errorEndpointDeleted = LocalizedString("error_endpoint_deleted")
    static  var GuestCardOverridden = LocalizedString("GuestCardOverridden")
    static var CardNotValidYet = LocalizedString("CardNotValidYet")
    static var CardHasExpired = LocalizedString("CardHasExpired")
    static var CardCancelled = LocalizedString("CardCancelled")
    static var CardUsergroupBlocked = LocalizedString("CardUsergroupBlocked")
    static var NoAccessToThisRoom = LocalizedString("NoAccessToThisRoom")
    static var WrongSystemNumberOnCard = LocalizedString("WrongSystemNumberOnCard")
    static var NotValidAtThisTime = LocalizedString("NotValidAtThisTime")
    static var DoorUnitDeadBolted = LocalizedString("DoorUnitDeadBolted")
    static var NotValidDueToPrivacyStatus = LocalizedString("NotValidDueToPrivacyStatus")
    static  var AccessDeniedDueToBatteryAlarm = LocalizedString("AccessDeniedDueToBatteryAlarm")
    static  var NotValidDueToAntiPassback = LocalizedString("NotValidDueToAntiPassback")
    static  var NotValidDueToDoorNotClosed = LocalizedString("NotValidDueToDoorNotClosed")
    static var WrongPIN = LocalizedString("WrongPIN")
    static  var CommandNotValidForThisLock = LocalizedString("CommandNotValidForThisLock")
}
@objc class LockErrorCodes : NSObject {
    private override init() {}
    
   @objc class func errorEndpointDeleted() -> String { return LOCKERRORCODES.errorEndpointDeleted }
   @objc class func GuestCardOverridden() -> String { return LOCKERRORCODES.GuestCardOverridden }
   @objc class func CardNotValidYet() -> String { return LOCKERRORCODES.CardNotValidYet }
   @objc class func CardHasExpired() -> String { return LOCKERRORCODES.CardHasExpired }
   @objc class func CardCancelled() -> String { return LOCKERRORCODES.CardCancelled }
   @objc class func CardUsergroupBlocked() -> String { return LOCKERRORCODES.CardUsergroupBlocked }
   @objc class func NoAccessToThisRoom() -> String { return LOCKERRORCODES.NoAccessToThisRoom }
   @objc class func WrongSystemNumberOnCard() -> String { return LOCKERRORCODES.WrongSystemNumberOnCard }
   @objc class func NotValidAtThisTime() -> String { return LOCKERRORCODES.NotValidAtThisTime }
   @objc class func AccessDeniedDueToBatteryAlarm() -> String { return LOCKERRORCODES.AccessDeniedDueToBatteryAlarm }
   @objc class func NotValidDueToAntiPassback() -> String { return LOCKERRORCODES.NotValidDueToAntiPassback }
   @objc class func NotValidDueToDoorNotClosed() -> String { return LOCKERRORCODES.NotValidDueToDoorNotClosed }
   @objc class func WrongPIN() -> String { return LOCKERRORCODES.WrongPIN }
   @objc class func CommandNotValidForThisLock() -> String { return LOCKERRORCODES.CommandNotValidForThisLock }
    @objc class func DoorUnitDeadBolted() -> String { return LOCKERRORCODES.DoorUnitDeadBolted }
}


struct THERAPIST{
    static let male = "male"
    static let female = "female"
}
struct QUERY {
    static let IRD = "IRD"
}

struct DEPARTMENTTYPE {
    
    static let QUANTITY_SELECTION  = LocalizedString("quantity_selection");
    static let TAB                 = LocalizedString("tabs");
    
}

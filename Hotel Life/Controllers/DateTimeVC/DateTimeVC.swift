
//
//  DateTimeVC.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 18/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class DateTimeVC: BaseViewController, AlertVCDelegate {
    
    
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var tableViewHeightLayout: NSLayoutConstraint!
    
    var totalSelectedPrice : Double? = 0
    var slectedPackages : [Base_packages]? = [Base_packages]()
    
    @IBOutlet weak var view_dateBg: UIView!
    @IBOutlet weak var view_timeBg: UIView!
    @IBOutlet weak var view_PersonBg: UIView!
    @IBOutlet weak var picker_hour: UIPickerView!
    @IBOutlet weak var datePickerCollection: UICollectionView!
    @IBOutlet weak var personViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_totalPerson: UILabel!
    @IBOutlet weak var dateViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_occasion: UIView!
    @IBOutlet weak var view_specialRequest: UIView!
    
    @IBOutlet weak var view_durationInstructor: UIView!
    @IBOutlet weak var view_selectDuration: UIView!
    @IBOutlet weak var txt_occasion: UITextField!
    @IBOutlet weak var txt_duration: UITextField!
    @IBOutlet weak var txtv_specialRequest: MyTextView!
    @IBOutlet weak var constraintSpecialRequest: NSLayoutConstraint!
    @IBOutlet weak var constraintOccasion: NSLayoutConstraint!
    @IBOutlet weak var constraint_timeDurationBackground: NSLayoutConstraint!
    @IBOutlet weak var view_gender: UIView!
    @IBOutlet weak var view_instructor: UIView!
    @IBOutlet weak var constraint_gender: NSLayoutConstraint!
    @IBOutlet weak var btn_maleTherapist: UIButton!
    @IBOutlet weak var btn_femaleTherapist: UIButton!
    @IBOutlet weak var btn_reserve: UIButton!
    @IBOutlet weak var lbl_offer: UILabel!
    @IBOutlet weak var lbl_preferredDate: UILabel!
    @IBOutlet weak var lbl_preferredTime: UILabel!
    @IBOutlet weak var lbl_numberOfPeople: UILabel!
    @IBOutlet weak var lbl_therapist: UILabel!
    var pickerView : UIPickerView?
    var pickerDuration : UIPickerView?

    @IBOutlet weak var btn_instructor: UIButton!
    var instructor : Bool = false
    var selectedMenu : Menu = Menu()
    var selectedDate : DateModel?
    // for count cells we will have multiple menu items
    var selectedArray : [Menu]?
    var titleBarText : String? = ""
    var timeArray : [String] = []
    var dateArray : [DateModel] = []
    var selectedIndex : Int = 1
    var reservationModel : ReservationModel?
    var totalPerson = 2
    var showDateView = false
    var showTimeView = false
    var showPersonView = false
    var showSpecialRequest = false
    var showOccation = false
    var showOperatingHours = false
    var showDuration = false
    var showGender = false
    
    var centrePoint : CGPoint = CGPoint(x: 0, y: 0)
    var centerIndexPath : IndexPath = IndexPath(row: 1, section: 0)
    var alreadyReserved = false
    var promocode : Promocode?
    var suggestion = false
    var tableCellType : CellType = .countCell
    var screenType : SubMenuDataType = .reservation
    var defaultTime = "8 PM"
    var notificationObj : NotificationModel?
    var selectedTherapist : String?
    var pickerItems = ["Birthday","Anniversary","Date","Business Meal","Special Occasion"]
    var durationItems = ["30 mins","60 mins","90 mins","120 mins"]
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Date time selection screen", className: "DateTimeVC")

        lbl_numberOfPeople.text = TITLE.NumberOfPeople
        lbl_therapist.text = TITLE.Therapist
        if let val = selectedMenu.is_operating {
            if val == true {
                showOperatingHours = val
            }
        }
        
        if selectedMenu.is_discount {
            let text = String(format: ALERTSTRING.DiscountText, "\(String(format : "%.2f",selectedMenu.discount))%")
            self.lbl_offer.text = text
        }
        dateArray = getDateArray()
        if dateArray.count <= 0 {
            view_dateBg.setDisabled()
//            btn_reserve.setDisabled()
        }
        
        if showOperatingHours == true {
            if let date = self.selectedDate {
                updateTimeValues(date: date)
            }
        }
        else{
            timeArray = getTimeValues()
        }
        
        if let gender = selectedMenu.items_attributes?.ask_gender, gender == true {
           showGender = gender
           selectedTherapist = THERAPIST.female
        }
        if let gender = reservationModel?.gender, gender != "" {
           selectedTherapist = gender
        }
        centrePoint = datePickerCollection.center
        picker_hour.reloadAllComponents()
        datePickerCollection.reloadData()
        lbl_totalPerson.text = "\(totalPerson)"
        if showTimeView {
            checkCurrentTime()
        }
        setupPicker()
        
        self.btn_reserve.setTitle("Next", for: .normal)
    }
    
    func setupPicker(){
        
        let pickerDuration =  UIPickerView()
        pickerDuration.delegate = self
        pickerDuration.dataSource = self
        pickerDuration.tag = 888
        txt_duration.inputView = pickerDuration
        txt_duration.placeholder = PLACEHOLDER.selectDuration
        self.pickerDuration = pickerDuration
        
        if let str = txt_duration.placeholder {
            txt_duration.attributedPlaceholder = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
        
//        if let occasion = self.reservationModel?.occasion {
//            if durationItems.contains(occasion) {
//                if let index = durationItems.index(of: occasion) {
//                    pickerDuration.selectRow(index, inComponent: 0, animated: true)
//                }
//            }
//            txt_duration.text = occasion
//        }
        let pickerView =  UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 999
        txt_occasion.inputView = pickerView
        txt_occasion.placeholder = PLACEHOLDER.selectOccasion
        self.pickerView = pickerView
        
        if let str = txt_occasion.placeholder {
            txt_occasion.attributedPlaceholder = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
        
        if let occasion = self.reservationModel?.occasion {
            if pickerItems.contains(occasion) {
                if let index = pickerItems.index(of: occasion) {
                    pickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
            txt_occasion.text = occasion
        }
        if let req = self.reservationModel?.specialRequest {
            txtv_specialRequest.set(text : req, placeholder: PLACEHOLDER.specialRequest, placeholderColor: UIColor.white, text_color: UIColor.white)
        }
        else{
            txtv_specialRequest.set(text : "", placeholder: PLACEHOLDER.specialRequest, placeholderColor: UIColor.white, text_color: UIColor.white)
        }
        
    }
    override func viewDidLayoutSubviews() {
        scrollToIndex(index: selectedIndex)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if titleBarText != "" {
            self.navigationItem.title = titleBarText
        }
        else {
            self.navigationItem.title = "Reservations"
        }
        
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        self.setupViews()
        
        self.view.layoutIfNeeded()
        self.tableViewHeightLayout.constant = CGFloat(self.tableView?.contentSize.height ?? 0)
      
    }
    func setupViews() {
        view_specialRequest.clipsToBounds = true
        view_occasion.clipsToBounds = true
        view_dateBg.addBorder(color: .white)
        view_timeBg.addBorder(color: .white)
        view_PersonBg.addBorder(color: .white)
        view_occasion.addBorder(color: .white)
        view_specialRequest.addBorder(color: .white)
        view_selectDuration.addBorder(color: .white)
        view_selectDuration.clipsToBounds = true
        view_gender.addBorder(color: .white)
        view_instructor.addBorder(color: .white)
        view_instructor.clipsToBounds = true
        
        switch screenType{
        case .service_selection, .reservation, .kid_zone:
            view_PersonBg.isHidden = true
            totalPerson = 0
            personViewHeightConstraint.constant = 0
            constraintSpecialRequest.constant = showSpecialRequest ? 120 : 0
            constraintOccasion.constant = showOccation ? 40 : 0
            
        default:
            view_PersonBg.isHidden = false
            totalPerson = 2
            constraintSpecialRequest.constant = 0
            constraintOccasion.constant = 0
            personViewHeightConstraint.constant = 60
            constraintSpecialRequest.constant = showSpecialRequest ? 120 : 0
            constraintOccasion.constant = showOccation ? 40 : 0
            
        }
        constraint_timeDurationBackground.constant = showDuration ? 150 : 0
//        constraint_timeDurationBackground.constant = 0
        view_durationInstructor.clipsToBounds = true
        if timeArray.count > 1 {
            if timeArray.contains(defaultTime.uppercased()){
                picker_hour.selectRow(timeArray.index(of: defaultTime.uppercased())!, inComponent: 0, animated: true)
            }
        }
        view_dateBg.isHidden = showDateView ? false : true
        view_timeBg.isHidden = showTimeView ? false : true
        dateViewHeightConstraint.constant = showDateView ? 135 : 0
        timeViewHeightConstraint.constant = showTimeView ? 135 : 0
        
        view_PersonBg.isHidden = showPersonView ? false : true
        personViewHeightConstraint.constant = showPersonView ? 60 : 0
        totalPerson = showPersonView ? 2 : 0
        
        view_gender.isHidden = showGender ? false : true
        constraint_gender.constant = showGender ? 60 : 0
        
        btn_maleTherapist.isSelected = selectedTherapist == THERAPIST.male ? true : false
        btn_femaleTherapist.isSelected = selectedTherapist == THERAPIST.female ? true : false
        
    }
//    MARK: Date time related functions
    
    func checkCurrentTime () {
        let currentTime = Helper.getStringFromDate(format: DATEFORMATTER.H, date: Date())
        let selectedTime = Helper.getDateFromString(string: defaultTime, formatString: DATEFORMATTER.HA)
        let tempTime = Helper.getStringFromDate(format: DATEFORMATTER.H, date: selectedTime)
        print( currentTime, tempTime)
        if Int(currentTime)! > Int(tempTime)! {
            self.nextDateSelected()
        }
    }
    func getEmptyDateModel() -> DateModel {
        let date : DateModel = DateModel()
        date.date = 0
        date.month = ""
        date.monthNo = 0
        date.isSelected = false
        date.weekDay = ""
        date.weekDayNo = 0
        return date
    }
    func getDateArray() -> [DateModel]{
        var array : [DateModel] = []
        let currentDate = Date()
        let calendar = Calendar.current
        var component = DateComponents()
        for i in 0...150 {
            component.day = i;
            let tempDate = calendar.date(byAdding: component, to: currentDate)
            let day = calendar.component(.day, from: tempDate!)
            let month = calendar.component(.month, from: tempDate!)
            let weekday = calendar.component(.weekday, from: tempDate!)
            let date = DateModel()
            date.date = day
            date.monthNo = month
            date.weekDayNo = weekday
            if showOperatingHours {
                if getTimeArray(date: date).count > 0 {
                    if array.count <= 0 {
                        array.append(self.getEmptyDateModel())
                    }
                    
                    if array.count == 1  {
                        date.isSelected = true
                        self.selectedDate = date
                    }
                    else{
                        date.isSelected = false
                    }
                    array.append(date)
                }
            }
            else{

                if array.count <= 0 {
                        array.append(self.getEmptyDateModel())
                }
                if array.count == 1  {
                    date.isSelected = true
                    self.selectedDate = date
                }
                else{
                    date.isSelected = false
                }
                array.append(date)

            }
        }
        if array.count > 0 {
            array.append(self.getEmptyDateModel())
        }
        return array
    }
    func updateTimeValues(date : DateModel) {
        if showOperatingHours == true {
            timeArray = []
            if selectedMenu.is_operating == true {
                self.timeArray = getTimeArray(date: date)
            }
            if timeArray.count > 0 {
                view_timeBg.setEnabled()
//                btn_reserve.setEnabled()
            }
            else{
                view_timeBg.setDisabled()
//                btn_reserve.setDisabled()
            }
            picker_hour.reloadAllComponents()
        }
        
    }
    func getTimeArray(date : DateModel) -> [String] {
        var arrayTime : [String] = []
//        if let operatingHours = selectedMenu.operatingHours{
        if let operatingHours = selectedMenu.operatingHoursSlots{
            if let weekday = date.weekDay {
                let obj = operatingHours.filter {
                    $0.day!.contains(weekday)
                }
                if obj.count > 0{
                    if let array = obj.first?.timeArray {
                        arrayTime = array
                    }
                }
            }
        }
        return arrayTime
    }
    func getTimeValues() -> [String]{
        var array : [String] = []
        for dayTime in 0...1 {
            for i in 1...12 {
                if dayTime == 0 {
                    array.append("\(i) \(TITLE.ANTE_MERIDIAN)")
                }
                else{
                    array.append("\(i) \(TITLE.POST_MERIDIAN)")
                }
            }
        }
        return array
    }
    
    @IBAction func therapistSelected(_ sender: UIButton) {
        if sender == btn_maleTherapist {
            btn_femaleTherapist.isSelected = false
            btn_maleTherapist.isSelected = true
            self.selectedTherapist(gender: THERAPIST.male)
        }
        else{
            btn_femaleTherapist.isSelected = true
            btn_maleTherapist.isSelected = false
            self.selectedTherapist(gender: THERAPIST.female)
            
        }
    }
    func selectedTherapist(gender : String){
        selectedTherapist = gender
    }
    @IBAction func selectedInstructor(_ sender: Any) {
            instructor = !btn_instructor.isSelected
            btn_instructor.isSelected = instructor
    }
    //    MARK: Reservation
    
    @IBAction func reserveAction(_ sender: Any) {

        if showTimeView {
            if timeArray.count < 1 {
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Cannot reserve for selected date and time.")
                return
            }
        }
        if showDateView{
            if dateArray.count < 1 {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Cannot reserve for selected date and time.")
                    return
            }
        }
        
        if Int(calculateTotalPrice() ?? 0.0) < 1 {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Please select atleast one package.")
            return
        }
        
        let timeOffset = Helper.getStringFromDate(format: DATEFORMATTER.ZZZZZ, date: Date())
        let date = Helper.getDateFromString(string: getDateTime()+" "+timeOffset, formatString: DATEFORMATTER.YYYY_MM_DD_HH_MM_ZZZZZ)
        if date.minutes(from: Date()) < 0{
            print("minutes->\(date.minutes(from: Date()))")
            if showTimeView{
                Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: ALERTSTRING.PAST_DATE)
                return
            }
        }
        reserve()
    }
    func reserve() {
        if suggestion{
            if let obj = notificationObj{
                obj.message?.appointment_date = getDateTime()
                obj.message?.action = "suggestion_by_user"
                let bizObject = BusinessLayer()
                bizObject.modifySuggestion(obj: obj, screenType : self.screenType, { (status, reservationObj, title, message) in
                    DispatchQueue.main.async(execute: {
                        self.reservationCompletedWith(status: status, model: reservationObj, alertTitle: title, alertMessage: message)
                    })
                })
            }
        }else if alreadyReserved{
            
            let model : ReservationModel = ReservationModel()
            if let id = selectedMenu.order_Id{
                model._id = id
            }
            model.module_id = selectedMenu.module_id
            model.department_id = selectedMenu.department_Id
            if selectedMenu.is_discount {
                model.discount = selectedMenu.discount
            }
            model.tax = selectedMenu.tax
            if let menuItems = selectedArray {
                model.items = menuItems
            }
            else{
                model.items = [selectedMenu]
            }
            model.promocode = self.promocode
            model.number_of_people = totalPerson
            model.appointment_date = getDateTime()
            model.isModification = true
            if self.showDuration == true {
                model.duration = txt_duration.text
                model.instructor = btn_instructor.isSelected
            }
            if let order = selectedMenu.items_attributes?.instant_order {
                model.instant_order = order
            }
            
            if let occasion = self.txt_occasion.text, occasion != ""{
                model.occasion = occasion
            }
            if let specialRequest = self.txtv_specialRequest.text, specialRequest != "", specialRequest != PLACEHOLDER.specialRequest{
                model.specialRequest = specialRequest
            }
            model.gender = selectedTherapist
            model.couple_name = selectedMenu.couple_name
            
            
            self.showRoomDialog(model: model)
        }else{
            let model : ReservationModel = ReservationModel()
            model.module_id = selectedMenu.module_id
            model.department_id = selectedMenu.department_Id
            if selectedMenu.is_discount {
                model.discount = selectedMenu.discount
            }
            
            if let menuItems = selectedArray {
                model.items = menuItems
            }
            else{
                model.items = [selectedMenu]
            }
            model.number_of_people = totalPerson
            model.appointment_date = getDateTime()
            model.appointment_time = getTime()
            model.isModification = false
            if let order = selectedMenu.items_attributes?.instant_order {
                model.instant_order = order
            }
            if let occasion = self.txt_occasion.text, occasion != ""{
                model.occasion = occasion
            }
            if let specialRequest = self.txtv_specialRequest.text, specialRequest != "", specialRequest != PLACEHOLDER.specialRequest{
                model.specialRequest = specialRequest
            }
            model.tax = selectedMenu.tax
            model.gender = selectedTherapist
            model.couple_name = selectedMenu.couple_name
            if self.showDuration == true {
                model.duration = txt_duration.text
                model.instructor = btn_instructor.isSelected
            }
            model.totalSelectedPrice = calculateTotalPrice()//totalSelectedPrice
            model.selectedPackages = self.selectedMenu.base_packages//slectedPackages
            self.showRoomDialog(model: model)
        }
    }
    func showPreviewWith(reservation : ReservationModel) {
        if screenType == .reservation {
            let objPreviewVC : PreviewReservationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.PreviewReservationVC) as! PreviewReservationVC
            objPreviewVC.reservation = reservation
            objPreviewVC.selectedMenu = selectedMenu
            objPreviewVC.titleBarText = self.titleBarText
            objPreviewVC.delegate = self
            objPreviewVC.showRoom = true

            objPreviewVC.screenType = self.screenType
            if tableCellType == .countCell {
                objPreviewVC.showDate = true
                objPreviewVC.showTime = false
            }
            else{
                objPreviewVC.showDate = true
                objPreviewVC.showTime = true
            }
            objPreviewVC.showPromo = true
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(objPreviewVC, animated: true)
            })
        }
        else{
            let objPreviewVC : PreviewVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.PreviewVC) as! PreviewVC
            objPreviewVC.reservation = reservation
            objPreviewVC.titleBarText = self.titleBarText
            objPreviewVC.delegate = self
            objPreviewVC.screenType = self.screenType
            objPreviewVC.selectedMenu = self.selectedMenu
            if tableCellType == .countCell {
                objPreviewVC.showDate = true
                objPreviewVC.showTime = false
            }
            else{
                objPreviewVC.showDate = true
                objPreviewVC.showTime = true
            }
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(objPreviewVC, animated: true)
            })
        }
    }
    
    private func calculateTotalPrice() -> Double?{
        
        var totalPrice = 0
         for (index, value) in self.selectedMenu.base_packages!.enumerated() {
            totalPrice = totalPrice + ((Int(value.price ?? "0") ?? 0) * (value.quantity ?? 0))
            
        }
        return Double(totalPrice)
    }
    
    
    func showRoomDialog(model : ReservationModel){
        if let room_number = Helper.getRoomNumber(), room_number != "" {
            model.room_number = room_number
            self.showPreviewWith(reservation: model)
        }
        else {
           /* let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SelectChairVC") as! SelectChairVC
            objUpgrade.delegate = self
            objUpgrade.titleBarText = self.titleBarText
            objUpgrade.showRoom = true
            objUpgrade.reservationModel =  model
            objUpgrade.alreadyReserved = alreadyReserved
            objUpgrade.alertText = ALERTSTRING.ROOM_NUMBER
            self.definesPresentationContext = true
            objUpgrade.modalPresentationStyle = .overCurrentContext
            objUpgrade.modalTransitionStyle = .crossDissolve
            objUpgrade.view.backgroundColor = .clear
            DispatchQueue.main.async(execute: {
                self.navigationController?.present(objUpgrade, animated: true, completion: nil)
            })*/
            
            
            if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ReservationSecondVC) as? ReservationSecondVC{
                vc.titleValue = titleBarText
                vc.showDate = showDateView
                vc.showTime = showTimeView
                vc.reservation = model
                vc.titleBarText = self.titleBarText
                vc.screenType = self.screenType
                vc.selectedMenu = self.selectedMenu
                
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func getDateTime() -> String {
        let date = dateArray[selectedIndex]
        let calendar = Calendar.current
        return "\(date.monthNo)/\(date.date)/\(calendar.component(.year, from: Date()))" //"\(calendar.component(.year, from: Date()))-\(date.monthNo)-\(date.date) \(getTime())"
//        ""appointment_date"": ""2017-09-29 03:00""
    }
    func getTime() -> String {
        if !showTimeView{
            let timeStr = Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: Date())
            return timeStr

//            return "11:00" //default
        }
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        
        if let time = timeArray[picker_hour.selectedRow(inComponent: 0)] as? String {
            let timeStrArray = time.components(separatedBy: " ")
            guard let hourStr = timeStrArray.first
                else{
                    return "00:00"
            }
            
            if timeStrArray.contains(TITLE.ANTE_MERIDIAN) {
                dateComponent.hour = Int(hourStr)
                dateComponent.minute = 0
                
            }
            else{
                dateComponent.hour = Int(hourStr)! + 12
                dateComponent.minute = 0

            }
            guard let date = calendar.date(from: dateComponent)
                else {
                    return "00:00"
            }
            let timeStr = Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: date)
            return timeStr
        }
        else{
            return "00:00"
        }
    }
    
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            objAlert.delegate = self
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.present(objAlert, animated: false) {
            }
        })
    }
    
    func alertDismissed(){
    
        switch screenType {

        case .service_selection:
            let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
            if let name = self.reservationModel?.module_name{
                titleBarText = name
            }
            controller.titleBarText = titleBarText
            controller.reservation = reservationModel
            controller.screenType = self.screenType
            controller.showDate = true
//            controller.showModify = true
            controller.showTime = true
            controller.selectedMenu = self.selectedMenu
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(controller, animated: true)
            })
        case .quantity_selection:
            let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
            if let name = self.reservationModel?.module_name{
                titleBarText = name
            }
            controller.titleBarText = titleBarText
            controller.reservation = reservationModel
            controller.screenType = self.screenType
            controller.showDate = true
            controller.selectedMenu = self.selectedMenu
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(controller, animated: true)
            })
        case .reservation:
            let controller : ConfirmationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ConfirmationVC) as! ConfirmationVC
            if reservationModel?.instructor != nil {
                controller.navTitle = titleBarText
            }else {
                if let name = self.reservationModel?.module_name{
                    titleBarText = name
                }
            }
            controller.showRoom = true
            controller.selectedMenu = self.selectedMenu
            controller.navTitle = titleBarText
            controller.reservationModel = self.reservationModel
            controller.screenType = self.screenType
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(controller, animated: true)
            })
        default:
            
            if reservationModel?.number_of_people == 0 || reservationModel?.number_of_people == nil {

                let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
                if let name = self.reservationModel?.module_name{
                    titleBarText = name
                }
                controller.titleBarText = titleBarText
                controller.reservation = reservationModel
                controller.screenType = self.screenType
                controller.showDate = true
                controller.showTime = true
                controller.selectedMenu = self.selectedMenu
                DispatchQueue.main.async(execute: {
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            }else{
                let controller : ConfirmationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ConfirmationVC) as! ConfirmationVC
                if let name = self.reservationModel?.module_name{
                    titleBarText = name
                }
                controller.navTitle = titleBarText
                controller.reservationModel = self.reservationModel
                controller.screenType = self.screenType
                DispatchQueue.main.async(execute: {
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            }
        }
    }
    
    
    @IBAction func decreaseAction(_ sender: UIButton) {
        
        if totalPerson > 1 {
            totalPerson = totalPerson - 1
        }
        lbl_totalPerson.text = "\(totalPerson)"
        
    }

    @IBAction func increaseAction(_ sender: UIButton) {
        totalPerson = totalPerson + 1
        lbl_totalPerson.text = "\(totalPerson)"
    }
    @IBAction func nextDateAction(_ sender: UIButton) {
       nextDateSelected()
    }
    @IBAction func previousDateAction(_ sender: UIButton) {
       previousDateSelected()
    }
    
    func nextDateSelected(){
        
        if dateArray.count > selectedIndex {
            if selectedIndex + 1 == (dateArray.count - 1) {
                return
            }
            self.updateDateArray(index: selectedIndex + 1)
            scrollToIndex(index: selectedIndex)
        }
        
    }
    
    func previousDateSelected(){
        if selectedIndex > 0 {
            if selectedIndex - 1 == 0 {
                return
            }
            self.updateDateArray(index: selectedIndex - 1)
            scrollToIndex(index: selectedIndex)
            
        }
    }
    
    func updateDateArray(index : Int){
        for date in dateArray {
            date.isSelected = false
        }
        selectedIndex = index
        dateArray[selectedIndex].isSelected = true
    }
    func scrollToIndex(index : Int){
        if dateArray.count > selectedIndex {
            updateTimeValues(date: dateArray[selectedIndex])
            let index = IndexPath.init(row: index, section: 0)
            datePickerCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            datePickerCollection.reloadData()
        }
    }
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }

    
    
}
extension DateTimeVC : UIPickerViewDelegate, UIPickerViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PreviewDelegate, PreviewReservationDelegate, UITextFieldDelegate, SelectChairVCDelegate{
    func fillRoom(alohaOrderModel: AlohaOrder, reservationModel: ReservationModel, controller: UIViewController) {
        
    }
    
    
    
    
//    MARK: PICKER VIEW DELEGATE
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 999 {
            return pickerItems.count
        }
        else if pickerView.tag == 888 {
            return durationItems.count
        }
        return timeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 999 {
            return pickerItems[row]
        }
        else if pickerView.tag == 888 {
            return durationItems[row]
        }
        return timeArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 999 {
            return NSAttributedString(string: pickerItems[row] , attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
        }
        else if pickerView.tag == 888 {
            return NSAttributedString(string: durationItems[row] , attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
        }
        else{
            return NSAttributedString(string: timeArray[row] , attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 999 {
            if pickerItems.count > row{
                txt_occasion.text = pickerItems[pickerView.selectedRow(inComponent: 0)]
            }
        }
        if pickerView.tag == 888 {
            if durationItems.count > row{
                txt_duration.text = durationItems[pickerView.selectedRow(inComponent: 0)]
            }
        }
    }
    
    //    MARK:Textfield delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt_occasion {
            txt_occasion.text = pickerItems[(pickerView?.selectedRow(inComponent: 0))!]
        }
        else if textField == txt_duration {
            txt_duration.text = durationItems[(pickerDuration?.selectedRow(inComponent: 0))!]
        }
    }
    
//    MARK: Collection Delegates And Datasources
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let date = dateArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.DATECELL, for: indexPath) as! DateCollectionCell
        cell.configureDateCell(date: date)
        
        if date.isSelected {
            selectedIndex = indexPath.row
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centrePoint = CGPoint(x:(scrollView.center.x + scrollView.contentOffset.x),y:(scrollView.center.y))
        print (centrePoint)
        updateCollectionView(point : centrePoint)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            centrePoint = CGPoint(x:(scrollView.center.x + scrollView.contentOffset.x),y:(scrollView.center.y))
            print (centrePoint)
            updateCollectionView(point : centrePoint)
        }
    }
    
    func updateCollectionView(point : CGPoint) {
        if let pt = datePickerCollection.indexPathForItem(at: point) {
            centerIndexPath = pt
            selectedIndex = centerIndexPath.row
            updateDateArray(index: selectedIndex)
            scrollToIndex(index: selectedIndex)
        }
    }

//    MARK: PreviewDelegate
    func reservationCompletedWith(status : Bool, model: ReservationModel?, alertTitle : String, alertMessage: String) {

            if status {
                self.reservationModel = model
                if !(self.reservationModel?.subMenuDataType == .def){
                   screenType = (model?.subMenuDataType)!
                }
                self.reservationModel?.alertTitle = alertTitle
                self.reservationModel?.alertMessage = alertMessage
                self.alertDismissed()
            }
            else{
                Helper.showAlert(sender: self, title: alertTitle, message: alertMessage)
            }
        
    }
    
//    MARK: Select Chair Dialog
    func selectedRoom(model : ReservationModel,controller : UIViewController) {
        controller.dismiss(animated: true, completion: {
//            if let arr = self.selectedArray {
//                self.getTaxDetail(model: model, menuArr: arr)
//            }
//            else {
                self.showPreviewWith(reservation: model)
//            }
            
            
        })
    }
    func selectedChair(model: ReservationModel, controller: UIViewController) {
//        for later use
    }
    
    func selectedQuantity(quantity: Int) {
//        for later use
    }
    
}


extension DateTimeVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedMenu.base_packages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceDetailCell", for: indexPath as IndexPath) as! PriceDetailCell
        cell.selectionStyle = .none
        cell.btnSelect?.tag = indexPath.row
        cell.btnPlus?.tag = indexPath.row
        cell.btnMinus?.tag = indexPath.row
        
        cell.lblTitle?.text = self.selectedMenu.base_packages?[indexPath.row].name
        cell.lblPrice?.text = (self.selectedMenu.base_packages?[indexPath.row].price ?? "") + " Dezer Bucks"
        cell.lblQuantity?.text = "\(self.selectedMenu.base_packages?[indexPath.row].quantity ?? 0)"
        
        cell.plusButtonClosure = { sender in
            
            if let quantity = self.selectedMenu.base_packages?[indexPath.row].quantity{
                self.selectedMenu.base_packages?[indexPath.row].quantity = quantity + 1
            }
            cell.lblQuantity?.text = "\(self.selectedMenu.base_packages?[indexPath.row].quantity ?? 0)"
        }
        
        cell.minusButtonClosure = { sender in
            
            if let quantity = self.selectedMenu.base_packages?[indexPath.row].quantity{
                if quantity != 0{
                    self.selectedMenu.base_packages?[indexPath.row].quantity = quantity - 1
                }
            }
            cell.lblQuantity?.text = "\(self.selectedMenu.base_packages?[indexPath.row].quantity ?? 0)"
        }
        
        
        
        
        
        cell.buttonClosure = { sender in
            if sender.isSelected{
                sender.isSelected = false
                if let package = self.selectedMenu.base_packages?[indexPath.row],let selectedPrice = package.price , let inDouble = Double(selectedPrice){
                    self.totalSelectedPrice = (self.totalSelectedPrice ?? 0.0) - inDouble
                    print(self.totalSelectedPrice)
                    
                    if let packageName = package.name{
                        for (index, value) in self.slectedPackages!.enumerated() {
                            if let name = value.name{
                                if name == packageName{
                                    self.slectedPackages?.remove(at: index)
                                }
                            }
                        }
                    }
                    
                }
                
            }else{
                sender.isSelected = true
                if let package = self.selectedMenu.base_packages?[indexPath.row],let selectedPrice = package.price , let inDouble = Double(selectedPrice){
                    self.totalSelectedPrice = (self.totalSelectedPrice ?? 0.0) + inDouble
                    print(self.totalSelectedPrice)
                    
                    self.slectedPackages?.append(package)
                    
                }
            }
            
        }
        return cell
    }
    
    
}


//MARK: PriceDetailCell
class PriceDetailCell : UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblPrice: UILabel?
    @IBOutlet weak var btnSelect: UIButton?
    
    @IBOutlet weak var lblQuantity: UILabel?
    @IBOutlet weak var btnPlus: UIButton?
    @IBOutlet weak var btnMinus: UIButton?
    
    var buttonClosure : ((UIButton) -> Void)?
    var plusButtonClosure : ((UIButton) -> Void)?
    var minusButtonClosure : ((UIButton) -> Void)?
    
    override func awakeFromNib() {
    super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
    
    @IBAction func selectAction(_ sender: UIButton){
        self.buttonClosure!(sender)
    }
    
    @IBAction func plusAction(_ sender: UIButton){
        self.plusButtonClosure!(sender)
    }
    
    @IBAction func minusAction(_ sender: UIButton){
        self.minusButtonClosure!(sender)
    }
    
}


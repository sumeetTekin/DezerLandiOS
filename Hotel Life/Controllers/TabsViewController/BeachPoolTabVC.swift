//
//  TabsVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 11/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class BeachPoolTabVC: TabImageTitleVC {
    var isReload = false
    var titleBarText: String = ""
    var alreadyReserved = false
    var selectedMenu : Menu?
    var department :[Department]?
    var tab :[Tab]?
    var selectedArray : [Menu] = []
    var controllerArray : [CustomTableVC] = []
    var pages : [PageModel] = []
    var orderTotal : Float = 0
    var reservation : ReservationModel?
    var showChairNumberDialog : Bool = false
    var showRoomNumberDialog : Bool = false
    
    @IBOutlet weak var lbl_titleHeader: UILabel!
    @IBOutlet weak var view_bottom_order: UIView!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var btn_order: UIButton!
    @IBOutlet weak var lbl_description: UILabel!
    var subMenuSubTableCellType : CellType = .countCell

    var screenType : SubMenuDataType = .reservation
    
    
    
    override func viewDidLoad() {
        Helper.logScreen(screenName: "Tabs menu screen listing", className: "BeachPoolTabVC")
        super.viewDidLoad()
        self.tabMargin = 15
        setupViewControllers()
        self.getInitialTotalAmount()
        switch screenType {
        case .tabs_quantity_selection:
            showChairNumberDialog = true
            showRoomNumberDialog = true
            break
        case .quantity_selection:
            showRoomNumberDialog = true
            break
        default:
            break
        }
    }
    
    
    func checkTime() -> Bool {
        let date = Helper.getTimeModel()
        if selectedMenu?.is_operating == true {
//            if let operatingHours = selectedMenu?.operatingHours{
            if let operatingHours = selectedMenu?.operatingHoursSlots{
                if let weekday = date.weekDay {
                    let obj = operatingHours.filter {
                        $0.day!.contains(weekday)
                    }
                    if obj.count > 0{
                        if let operatingHourOnDay = obj.first {
                            for slot in operatingHourOnDay.slotsArray {
                                if let startTime = slot.startTime {
                                    if let endTime = slot.endTime {
                                        if let time = date.time {
                                            if let currentTime = Helper.getOptionalTimeFromString(string: time, formatString: DATEFORMATTER.hhmma) {
                                                if currentTime.isBetween(startDate: startTime, endDate: endTime) {
                                                    return true
                                                }
//                                                if Helper.checkTimeBetween(date1: startTime, date2: endTime, current: currentTime) {
//                                                    return true
//                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return false
        }
        return true
    }
    @IBAction func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.shouldRotate = false
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = titleBarText
        self.lbl_titleHeader.text = titleBarText
        self.view.bringSubview(toFront: self.view_bottom_order)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInitialTotalAmount() {
        for obj in controllerArray{
            if obj.selectedArray.count > 0{
                obj.orderTotal = Helper.getAlohaQuantityTotal(menuArray: obj.selectedArray)
            }
        }
        
        //        TODO: ---
        //self.orderUpdated()
        if alreadyReserved{
            btn_order.setTitle(TITLE.Modify, for: .normal)
        }else{
            btn_order.setTitle(TITLE.Order, for: .normal)
        }
        self.lbl_description.text = TITLE.Total
    }
    
    @IBAction func actionOrder(_ sender: UIButton) {
        
        self.selectedArray.removeAll()
        var isDrink = false
        for obj in controllerArray {
            for menu in obj.selectedArray {
                if menu.is_drink == true {
                    isDrink = true
                }
                if !self.selectedArray.contains(menu) {
                    
                    self.selectedArray.append(menu)
                }
            }
        }
        if screenType == .quantity_selection {
            print ("Direct Order")
            if !(checkTime()) {
                if let message = self.selectedMenu?.items_attributes?.time_error {
                    Helper.showCancelDialog(title: self.titleBarText, message: message, viewController: self)
                }
                return
            }
            self.reserveAction(sender)
            return
        }
        
        if orderTotal > 0{
            if screenType == .tabs_quantity_selection {
                if !(checkTime()) {
                    if let message = self.selectedMenu?.items_attributes?.time_error {
                        Helper.showCancelDialog(title: self.titleBarText, message: message, viewController: self)
                    }
                    return
                }
            }
            
            var model : ReservationModel = ReservationModel()
            if let reserObj = self.reservation{
                model = reserObj
            }
            if let id = selectedMenu?.order_Id{
                model._id = id
            }
            model.module_id = selectedMenu?.module_id
            model.department_id = selectedMenu?.department_Id
            model.discount = selectedMenu?.discount
            model.appointment_date = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
            model.items = self.selectedArray
            if let tax = selectedMenu?.tax {
                model.tax = tax
            }
            model.is_drink = isDrink
            
            checkChairDialog(model: model)
        }else{
            Helper.showAlert(sender: self, title: "Required", message: "Please select an item.")
        }
    }
    func checkChairDialog(model : ReservationModel){
        
//        if Helper.ReadUserObject()?.userType != UserType.hotelGuest.rawValue &&
        if self.selectedMenu?.items_attributes?.is_map_seat == true {
            let controller = Helper.getDialogsStoryboard().instantiateViewController(withIdentifier: "SelectSeatVC") as! SelectSeatVC
            controller.delegate = self
            controller.reservationModel =  model
            
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(controller, animated: true)
            })
        }
        else {
            showChairDialog(model: model)
        }
        
    }
    
    func showChairDialog(model : ReservationModel){
            let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SelectChairVC") as! SelectChairVC
            objUpgrade.delegate = self
            objUpgrade.reservationModel =  model
            objUpgrade.alreadyReserved = alreadyReserved
            objUpgrade.titleBarText = self.titleBarText
            objUpgrade.showChair = true
        if self.selectedMenu?.items_attributes?.is_map_seat == true{
            objUpgrade.beachDining = true
        }
            //objUpgrade.navController = self.navigationController
            self.definesPresentationContext = true
            objUpgrade.modalPresentationStyle = .overCurrentContext
            objUpgrade.modalTransitionStyle = .crossDissolve
            objUpgrade.view.backgroundColor = .clear
            DispatchQueue.main.async(execute: {
                self.navigationController?.present(objUpgrade, animated: true, completion: {
                })
            })
    }
    func showRoomDialog(model : ReservationModel){
        let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SelectChairVC") as! SelectChairVC
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
        })
    }
    func showAllergyDialog(model : ReservationModel){
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: "AllergiesVC") as! AllergiesVC
        objUpgrade.delegate = self
        objUpgrade.reservationModel = model
        self.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            self.navigationController?.present(objUpgrade, animated: true, completion: nil)
        })
    }
    @IBAction func reserveAction(_ sender: UIButton) {
        if orderTotal > 0{
            if let instant = selectedMenu?.items_attributes?.instant_order {
                if instant == true{
                    let model : ReservationModel = ReservationModel()
                    model.module_id = selectedMenu?.module_id
                    model.department_id = selectedMenu?.department_Id
                    model.discount = selectedMenu?.discount
                    model.tax = selectedMenu?.tax
                    model.items = selectedArray
                    model.isModification = false
                    model.room_number = self.reservation?.room_number
                    model.appointment_date = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
                    model.instant_order = instant
                    if let room_number = Helper.getRoomNumber(), room_number != "" {
                        model.room_number = room_number
                        self.getTaxDetail(model: model)
                    }
                    else {
                        showRoomDialog(model: model)
                    }
                    return
                }
            }
            let objDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
            objDateTime.titleBarText = titleBarText
            objDateTime.alreadyReserved = self.alreadyReserved
            objDateTime.screenType = self.screenType
            objDateTime.tableCellType = .countCell
            if let menu = selectedMenu {
                objDateTime.selectedMenu = menu
            }
            objDateTime.selectedArray = selectedArray
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(objDateTime, animated: true)
            })
        }else{
            Helper.showAlert(sender: self, title: TITLE.Required, message: ALERTSTRING.SELECT_AN_ITEM)
        }
    }
    
    func instantReseravtion(model : ReservationModel) {
        showPreviewWith(reservation: model)
    }
    
    func setupViewControllers() {
    
        for tabObj in tab!{
            
            let objCustom : CustomTableVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.CustomTable) as! CustomTableVC
//            objCustom.itemInfo.title = tabObj.name!
            objCustom.tableCellType = subMenuSubTableCellType
            objCustom.titleBarText = titleBarText
            objCustom.delegate = self
            objCustom.hideBottomView = true
            objCustom.navController = self.navigationController
            if let dept = tabObj.departments{
                objCustom.department = dept
                for objDept in dept {
                    if let items = objDept.items {
                        for menu in items {
                            for selectedMenu in selectedArray {
                                if (menu.item_name == selectedMenu.item_name) && (menu.item_price == selectedMenu.item_price){
                                    if selectedMenu.removeInNextOrder == false{
                                        objCustom.selectedArray.append(menu)
                                        selectedMenu.removeInNextOrder = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            objCustom.delegate = self
            objCustom.alreadyReserved = alreadyReserved
            controllerArray.append(objCustom)
            
            let pageModel = PageModel()
            pageModel.imageURL = tabObj.unSelectedImageUrl
            pageModel.highlightedImageUrl = tabObj.selectedImageUrl
            pageModel.title = tabObj.name!
            pageModel.viewController = objCustom
            
            if self.pages.count <= 0 {
                pageModel.isSelected = true
            }
            else{
                pageModel.isSelected = false
            }
            
            self.pages.append(pageModel)
        }
        for item in selectedArray {
            item.removeInNextOrder = false
        }
        self.setPageModelArray(self.pages)
    }

    
    func showPreviewWith(reservation : ReservationModel) {
        let objPreviewVC : PreviewVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.PreviewVC) as! PreviewVC
        objPreviewVC.reservation = reservation
        if self.alreadyReserved {
            objPreviewVC.reservation.isModification = true
            if let id = selectedMenu?.order_Id{
                objPreviewVC.reservation._id = id
            }
            if let promocode = self.reservation?.promocode {
                objPreviewVC.reservation.promocode = promocode
            }
            if let tax = self.reservation?.tax {
                objPreviewVC.reservation.tax = tax
            }
        }
        
        objPreviewVC.titleBarText = self.titleBarText
        objPreviewVC.screenType = self.screenType
        objPreviewVC.delegate = self
        objPreviewVC.showDate = false
        objPreviewVC.showChair = true
        objPreviewVC.selectedMenu = self.selectedMenu
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objPreviewVC, animated: true)
        })
        
    }
    func orderCompleted(reservation: ReservationModel) {
        let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
        controller.titleBarText = titleBarText
        controller.alreadyReserved = false
        controller.reservation = reservation
        controller.selectedMenu = self.selectedMenu
        controller.screenType = self.screenType
//        controller.showModify = true
        if selectedMenu?.orderType == .direct {
            controller.showDate = false
        }
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(controller, animated: true)
        })
        
    }
    
}
extension BeachPoolTabVC : CustomTableVCDelegate , SelectChairVCDelegate, PreviewDelegate{
    func fillRoom(alohaOrderModel: AlohaOrder, reservationModel: ReservationModel, controller: UIViewController) {
        
    }
    
    
    //MARK: - Custom TableVC Delegate
    func orderUpdated() {
        var total : Float = 0
        for obj in controllerArray{
            total = obj.orderTotal + total
        }
        self.orderTotal = total
        lbl_total.text = "$\(String.init(format: "%.2f", Float(self.orderTotal)))"
    }
    func showDescriptionDialog(menu : Menu) {
        var title = ""
        var desc = ""
        if let text =  menu.label {
            title = text
        }
        if let text =  menu.labelDescription {
            desc = text
        }
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            objAlert.img_alert.sd_setImage(with: menu.imageURL, placeholderImage: #imageLiteral(resourceName: "img_info_green"), options: [], completed: nil)
            
            objAlert.showDescription(title:title, message: desc, done_title: ALERTSTRING.OK)
            self.present(objAlert, animated: false) {
            }
        })
    }
    
    //MARK: - Select Chair Delegate
    func selectedChair(model : ReservationModel,controller : UIViewController) {
        controller.dismiss(animated: true, completion: {
            if self.showChairNumberDialog == true && self.showRoomNumberDialog == true {
                 if self.selectedMenu?.items_attributes?.is_map_seat == true{
                     self.getTaxDetail(model: model)
                } else if let room_number = Helper.getRoomNumber(), room_number != "" {
                    model.room_number = room_number
                    self.getTaxDetail(model: model)
                }
                else {
                    self.showRoomDialog(model: model)
                }
            }else{
                self.getTaxDetail(model: model)
            }
        })
    }
    func selectedRoom(model : ReservationModel,controller : UIViewController) {
        controller.dismiss(animated: true, completion: {
            if self.selectedMenu?.subMenuDataType == .quantity_selection {
                self.showAllergyDialog(model: model)
            }
            else {
                self.getTaxDetail(model: model)
            }
        })
    }
    
    func getTaxDetail(model : ReservationModel) {
        self.checkRoom(model : model)
    }
    func checkRoom(model : ReservationModel) {
        self.makeReservation(model: model)
    }
    func makeReservation(model : ReservationModel) {
        if let menuArr = model.items {
            let obj = BusinessLayer()
            DispatchQueue.main.async {
                Helper.showLoader(title: LOADER_TEXT.loading)
            }
            var beachLocation = false
            if (model.beach_location) != nil && model.beach_location != ""{
                beachLocation = true
            }else {
                beachLocation = false
            }
            obj.calculateTax(arr: menuArr, orderMode : Helper.getOrderMode(screenType: screenType, beachLocation: beachLocation)) { (status, alohaOrder, message) in
                
                DispatchQueue.main.async {
                    Helper.hideLoader()
                }
                if status
                {
                    if let order = alohaOrder {
                        order.subTotal = "\(String.init(format: "%.2f", Helper.getAlohaQuantityTotal(menuArray: menuArr)))"
                        order.afterDiscount = order.calculateSubTotalAfterDiscount()
                        if let charge = self.selectedMenu?.tax?.service_charge {
                            order.serviceCharge = order.calculateServiceCharge(charge: charge)
                        }
                        if let charge = self.selectedMenu?.tax?.delivery_charge {
                            order.deliveryCharge = order.calculateDeliveryCharge(charge: charge, percent: 0)
                            if let percent = self.selectedMenu?.tax?.delivery_charge_percent {
                                order.deliveryCharge = order.calculateDeliveryCharge(charge: charge, percent: percent)
                            }
                        }
                        if let charge = self.selectedMenu?.tax?.state_tax {
                            order.stateTax = order.calculateStateTax(charge: charge)
                        }
                        if let charge = self.selectedMenu?.tax?.county_tax {
                            order.countyTax = order.calculateCountyTax(charge: charge)
                        }
                        order.total = order.calculateTotal()
                        
                        // save is drink status in aloha menu
                        if let items = model.items {
                            for item in items {
                                if item.is_drink == true {
                                    if let alohaMenus = order.alohaMenu {
                                        for menu in alohaMenus {
                                            if menu.posItemId == item.posItemId {
                                                menu.is_drink = item.is_drink
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        self.showAlohaPreviewWith(order: order, model: model)
                    }
                }
                else {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            }
        }
    }
    func showAlohaPreviewWith(order : AlohaOrder, model : ReservationModel) {
        let objPreviewVC : AlohaOrderPreview = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.AlohaOrderPreview) as! AlohaOrderPreview
        objPreviewVC.order = order
        objPreviewVC.order.reservationModel = model
//        objPreviewVC.reservationModel = model
        objPreviewVC.screenType = screenType
        objPreviewVC.selectedMenu = self.selectedMenu
        objPreviewVC.titleBarText = self.titleBarText
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objPreviewVC, animated: true)
        })
    }
    func selectedQuantity(quantity : Int) {
//        let model : ReservationModel = ReservationModel()
//        model.module_id = selectedMenu?.module_id
//        model.department_id = selectedMenu?.department_Id
//        model.tax = selectedMenu?.tax
//        model.items = selectedArray
//        model.isModification = false
//        model.appointment_date = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
//        model.room_number = "\(quantity)"
//        if self.showChairNumberDialog == true && self.showRoomNumberDialog == true {
//            self.showPreviewWith(reservation: model)
//        }else{
//            self.instantReseravtion(model : model)
//        }
    }
    
    //    MARK: PreviewDelegate
    func reservationCompletedWith(status : Bool, model: ReservationModel?, alertTitle : String, alertMessage: String) {
        DispatchQueue.main.async(execute: {
            if status {
                if let reservationModel = model{
                    reservationModel.alertTitle = alertTitle
                    reservationModel.alertMessage = alertMessage
                    self.orderCompleted(reservation: reservationModel)
                }
            }
            else{
                Helper.showAlert(sender: self, title: alertTitle, message: alertMessage)
            }
        })
    }
}
extension BeachPoolTabVC : AllergiesDelegate {
    func selectedNumber(model: ReservationModel, controller : AllergiesVC) {
        controller.dismiss(animated: true, completion: nil)
        makeReservation(model: model)
    }
}

extension BeachPoolTabVC : SelectSeatVCDelegate {
    func selectedSeat(model: ReservationModel?) {
//        if let room_number = Helper.getRoomNumber(), room_number != "" {
//            model.room_number = room_number
//            self.getTaxDetail(model: model)
//        }
//        else {
//            self.showRoomDialog(model: model)
//        }
        if let model = model {
            showChairDialog(model: model)
//            self.getTaxDetail(model: model)
        }
        
    }
    
    
}

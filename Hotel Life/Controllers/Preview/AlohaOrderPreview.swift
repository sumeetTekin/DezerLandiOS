//
//  AlohaOrderPreview.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 30/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
// only for Aloha order preview and confirm screen
class AlohaOrderPreview: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_totalText: UILabel!
    @IBOutlet weak var btn_confirm: UIButton!
//    var reservationModel : ReservationModel?
    var screenType : SubMenuDataType = .reservation
    var orderCompleted : Bool = false
    var order : AlohaOrder!
    var selectedMenu : Menu?
//    var selectedArray : [Menu] = []
    var titleBarText : String? = ""
    var showOrder = true
    var showTax = false
    var showPromo = false
    var showFailedItems = false
    var customCancelDialog = false
    var orderNumberCell = 0
    var peopleCell = 0
    var statusCell = 0
    var taxCell = 0
    var promoCell = 0
    var firstCellIndex = 0
    var itemsCount = 0
    var failedItemsCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        lbl_totalText.text = TITLE.Total
        tableView.estimatedRowHeight = 400
        showTax = true
        
        taxCell = showTax ? 1 : 0
        promoCell = showPromo ? 1 : 0
        orderNumberCell = showOrder ? 1 : 0
        statusCell = orderCompleted ? 1 : 0
        if let people = order.reservationModel?.number_of_people {
            peopleCell = people > 0 ? 1 : 0
        }
        
        firstCellIndex = orderNumberCell + statusCell + peopleCell
        if let count = order.alohaMenu?.count {
            itemsCount = count
        }
        if let count = order.failedMenu?.count, count > 0 {
            showFailedItems = true
            failedItemsCount = count
        }
        if let total = order.total {
            lbl_price.text = "$\(total)"
        }
        else {
            lbl_price.text = "--"
        }
        if let customDialog = selectedMenu?.items_attributes?.hide_cancel, customDialog == true {
            customCancelDialog = customDialog
        }
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = titleBarText
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        if orderCompleted {
            Helper.logScreen(screenName: "Aloha Order Completed", className: "AlohaOrderPreview")
         btn_confirm.setTitle(BUTTON_TITLE.Continue, for: .normal)
        }
        else {
            Helper.logScreen(screenName: "Aloha Order preview", className: "AlohaOrderPreview")
            btn_confirm.setTitle(BUTTON_TITLE.Confirm, for: .normal)
        }
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @objc func backAction(_ sender: UIButton) {
        if orderCompleted {
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
        else {
            DispatchQueue.main.async(execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        if orderCompleted {
            self.backAction(btn_confirm)
        }
        else {
            
            if let total = order.total {
                if let floatTotal = Float(total), floatTotal <= 0 {
                    return
                }
            }
            if let is_payment_selection = selectedMenu?.items_attributes?.is_payment_selection, is_payment_selection == true{
//                if Helper.ReadUserObject()?.userType != UserType.hotelGuest.rawValue && self.selectedMenu?.items_attributes?.is_map_seat == true {
//                    showDisclaimer()
//                }
//                else {
                    paymentOption()
//                }
            }
            else {
                showDisclaimer()
            }
            
            
        }
    }
    func showDisclaimer() {
        if let disclaimer = selectedMenu?.disclaimer, disclaimer != "" {
            let controller = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.DisclaimerVC) as! DisclaimerVC
            controller.disclaimerText = disclaimer
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func paymentOption(){
        let controllerPoolPayment : PoolDinePaymentDialog = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.PoolDinePaymentDialog) as! PoolDinePaymentDialog
        controllerPoolPayment.modalPresentationStyle = .overCurrentContext
        controllerPoolPayment.delegate = self
        self.navigationController?.present(controllerPoolPayment, animated: false, completion: {
        })
    }
    func makeReservation() {
        self.confirmAlohaOrder(order: order)
    }

    func confirmAlohaOrder(order : AlohaOrder) {
        print("Subtotal is : \(self.order.subTotal)")
        
        let obj = BusinessLayer()
        DispatchQueue.main.async {
            Helper.showLoader(title: LOADER_TEXT.loading)
        }
        var beachLocation = false
        if (order.reservationModel?.beach_location) != nil && (order.reservationModel?.beach_location) != ""{
            beachLocation = true
        }else {
            beachLocation = false
        }
        order.orderMode = Helper.getOrderMode(screenType: screenType, beachLocation: beachLocation)
        obj.alohaOrderConfirm(order: order, orderMode: Helper.getOrderMode(screenType: screenType, beachLocation: beachLocation)) { (status, alohaOrder, message) in
            DispatchQueue.main.async {
                Helper.hideLoader()
            }
            if status {
                if let order = alohaOrder {
                    order.subTotal = self.order.subTotal
                    order.afterDiscount = self.order.afterDiscount
                    order.serviceCharge = self.order.serviceCharge
                    order.deliveryCharge = self.order.deliveryCharge
                    order.stateTax = self.order.stateTax
                    order.countyTax = self.order.countyTax
                    order.total = order.calculateTotal()
                    self.showAlohaOrderWith(order: order)
                }
            }
            else{
                Helper.showAlert(sender: self, title: "Error", message: message)
            }
        }
//        obj.orderConfirm(arr: menuArr, model: reservationModel, orderMode : Helper.getOrderMode(screenType: screenType)) { (status, alohaOrder, message) in
//            DispatchQueue.main.async {
//                Helper.hideLoader()
//            }
//            if status {
//                if let order = alohaOrder {
//                    order.subTotal = self.order.subTotal
//                    order.afterDiscount = self.order.afterDiscount
//                    order.serviceCharge = self.order.serviceCharge
//                    order.deliveryCharge = self.order.deliveryCharge
//                    order.stateTax = self.order.stateTax
//                    order.countyTax = self.order.countyTax
//                    order.total = order.calculateTotal()
//                    self.showAlohaOrderWith(order: order)
//                }
//            }
//            else{
//                Helper.showAlert(sender: self, title: "Error", message: message)
//            }
//        }
    }
    func showAlohaOrderWith(order : AlohaOrder) {
        let objPreviewVC : AlohaOrderPreview = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.AlohaOrderPreview) as! AlohaOrderPreview
        
        objPreviewVC.order = order
        objPreviewVC.order.reservationModel = self.order.reservationModel
        objPreviewVC.orderCompleted = true
        objPreviewVC.screenType = screenType
        objPreviewVC.titleBarText = self.titleBarText
        objPreviewVC.selectedMenu = self.selectedMenu
        
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objPreviewVC, animated: true)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func cancelAction(_ sender: UIButton) {
        if orderCompleted {
            if customCancelDialog {
                let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CancelAlert) as! CancelAlert
                self.definesPresentationContext = true
                objAlert.modalPresentationStyle = .overCurrentContext
                objAlert.view.backgroundColor = .clear
                //            objAlert.lbl_message.textColor = .white
                objAlert.lbl_title.text = self.titleBarText
                var mobile_number = "5757"
                if let number = self.selectedMenu?.mobile_number {
                    mobile_number = number
                }
                if let type = selectedMenu?.subMenuDataType {
                    if type == .quantity_selection {
                        objAlert.setClickableText(completeText: "We are already preparing your order. Please dial extension 5757 to cancel it.", clickableText: mobile_number)
                        }
                        else
                    {
                        objAlert.setClickableText(completeText: "We are already preparing your order. Please ask a pool server to change your order.", clickableText: mobile_number)
                    }
                    self.present(objAlert, animated: false) {
                    }
                }                
                //            objAlert.lbl_title.text = "Title"
                // yes action pending
                
                return
            }
//            self.showCancelAlert()
            
        }
        else {
            DispatchQueue.main.async(execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    private func showCancelAlert() {
        let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CustomAlertView) as! CustomAlertView
        objAlert.delegate = self
        self.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.set(imageURL :nil, message: ALERTSTRING.CancelOrder)
        objAlert.img_icon.image = #imageLiteral(resourceName: "img_info_green")
        self.present(objAlert, animated: false) {
        }
    }
}
extension AlohaOrderPreview : UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        if showFailedItems {
            return 3
        }
        return 2
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch section {
            case 0:
                return 0
            case 1:
            if showFailedItems {
                return 50
            }
            else {
                fallthrough
            }
            default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.HEADER_CELL) as! CustomTableCell
        switch section {
        case 0:
                cell.lbl_headerTitle.text = ""
        case 1:
                if showFailedItems {
                    cell.lbl_headerTitle.text = "Below selected items failed to order. Please contact hotel staff."
                }
                else {
                    fallthrough
            }
        default:
                cell.lbl_headerTitle.text = ""
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            if let items = order.alohaMenu {
                return (orderNumberCell + peopleCell + statusCell + items.count + taxCell + promoCell)
            }
            return (orderNumberCell + peopleCell + statusCell + taxCell + promoCell)
        case 1:
            if showFailedItems {
                return failedItemsCount
            }
            else {
                fallthrough
            }
        default:
            return 1
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0 :
                if showOrder {
                    var cell : BookingDetailCell!
                    if orderCompleted {
                        cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_ORDER_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                        if let chair = order.orderNumber {
                            cell.lbl_subTitle.text = chair
                        }
                    }
                    else {
                        cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                    }
                    
                    if screenType == .quantity_selection  {
                        /*if let room_number = order.reservationModel?.room_number {
                            cell.timeLabel.text = room_number
                        }*/
                        if let room_number = order.roomNumber {
                            cell.timeLabel.text = room_number
                        }
                        cell.lbl_title.text = TITLE.RoomNumber
                    }
                    else if screenType == .tabs_quantity_selection {
                        var completeNumber = ""
                        if let chair_number = order.reservationModel?.chair_number{
                            completeNumber = completeNumber.appending(chair_number)
                        }
                        
//                        if  Helper.ReadUserObject()?.userType != UserType.hotelGuest.rawValue &&
                        if self.selectedMenu?.items_attributes?.is_map_seat == true {
                            cell.lbl_title.text = TITLE.BeachLocation + "/" + TITLE.ChairNumber
                            if let beach_location = order.reservationModel?.beach_location{
                                let chairNumber = completeNumber
                                completeNumber = beach_location.appending("/")
                                completeNumber = completeNumber.appending(chairNumber)
                            }
                         
                            
                        }
                        else {
                            if let room_number = order.reservationModel?.room_number {
                                if completeNumber != "" {
                                    completeNumber = completeNumber.appending("/")
                                }
                                completeNumber = completeNumber.appending(room_number)
                            }
                            cell.lbl_title.text = TITLE.ChairRoomNumber
                        }
                        
                        cell.timeLabel.text = completeNumber
                        cell.img_cellImage.image = #imageLiteral(resourceName: "img_chair")
                    }
                    return cell
                }
                else{
                    fallthrough
                }
            case 0...peopleCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_People, for: indexPath as IndexPath) as! BookingDetailCell
                if let people = order.reservationModel?.number_of_people {
                    cell.lbl_title.text = "Number of people: \(people)"
                }
                else {
                    cell.lbl_title.text = ""
                }
                return cell
                
            case 0...peopleCell + statusCell:
                if orderCompleted {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.ORDER_TIME_CELL, for: indexPath as IndexPath) as! AlohaMenuCell
                    cell.setupTimeCellFor(alohaOrder: order)
                    return cell
                }
                else {
                    fallthrough
                }
            case 0...(orderNumberCell + statusCell + peopleCell + itemsCount - 1):
                if itemsCount > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.ALOHA_MENU_CELL, for: indexPath as IndexPath) as! AlohaMenuCell
                    if let item = order.alohaMenu?[indexPath.row  - firstCellIndex] {
                        cell.setupCellFor(alohaMenu: item, delegate : self)
                    }
                    return cell
                }
                else {
                    fallthrough
                }
            case 0...(orderNumberCell + statusCell + peopleCell + (itemsCount - 1) + taxCell):
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.TAX_CELL, for: indexPath as IndexPath) as! AlohaTaxCell
//                if let text = order.tax, text != "" {
//                    cell.lbl_Tax.text = "$\(text)"
//                }
//                else {
//                    cell.lbl_Tax.text = "$0.00"
//                }
                if let text = order.subTotal {
                    cell.lbl_subTotal.text = "$\(text)"
                }
                if let text = order.discount {
                    cell.lbl_totalDiscount.text = "$\(text)"
                }
                if let text = order.afterDiscount {
                    cell.lbl_discountedSubtotal.text = "$\(text)"
                }
                if let text = order.serviceCharge {
                    cell.lbl_serviceCharge.text = "$\(text)"
                    cell.constraint_serviceCharge.constant = 25
                }
                else {
                    cell.constraint_serviceCharge.constant = 0
                }
                if let text = order.deliveryCharge {
                    cell.lbl_deliveryCharge.text = "$\(text)"
                    cell.constraint_delivery.constant = 25
                }
                else {
                    cell.constraint_delivery.constant = 0
                }
                if let text = order.stateTax {
                    cell.lbl_stateTax.text = "$\(text)"
                }
                if let text = order.countyTax {
                    cell.lbl_countyTax.text = "$\(text)"
                }

                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                
                cell.cancelBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            }
        case 1:
            if showFailedItems {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.ALOHA_MENU_CELL, for: indexPath as IndexPath) as! AlohaMenuCell
                if let item = order.failedMenu?[indexPath.row] {
                    cell.setupCellFor(alohaMenu: item, delegate : self)
                }
                return cell
            }
            else {
                fallthrough
            }
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
            
            cell.cancelBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
            cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
            cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
            cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
            return cell
        }
    }
}
extension AlohaOrderPreview : AlohaMenuDelegate {
    
}
extension AlohaOrderPreview : DisclaimerDelegate {
    //    MARK: Disclaimer Delegate
    func disclaimerAgreed(){
        makeReservation()
    }
}

extension AlohaOrderPreview : PoolDinePaymentDelegate{
    func getPaymentType(paymentType: Int) {
        self.order.reservationModel?.paymentType = paymentType
        showDisclaimer()
        //self.makeReservation()
    }
    
    
}
extension AlohaOrderPreview : CustomAlertViewDelegate {
    func alertDismissed() {
        
    }
    
    func yesAction() {
        if let id = self.order.orderId {
            let obj = BusinessLayer()
            DispatchQueue.main.async {
                Helper.showLoader(title: LOADER_TEXT.loading)
            }
            obj.cancelAlohaOrder(orderId: id, { (status, message) in
                DispatchQueue.main.async {
                    Helper.hideLoader()
                }
                if status {
                    self.backAction(self.btn_confirm)
                }
                else{
                    Helper.showAlert(sender: self, title: "Error", message: message)
                }
            })
        }
    }
    
    func noAction() {
        
    }
    
}



















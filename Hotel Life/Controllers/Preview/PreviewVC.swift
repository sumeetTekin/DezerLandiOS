//
//  PreviewVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 24/10/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol PreviewDelegate {
    func reservationCompletedWith(status : Bool, model: ReservationModel?, alertTitle : String, alertMessage: String)
}
class PreviewVC: BaseViewController {
    var delegate : PreviewDelegate?
    var titleBarText : String? = ""
    var reservation : ReservationModel = ReservationModel()
    var alreadyReserved = false
    var selectedMenu : Menu?
    var showDate = true
    var showTime = false
    var showChair = true
    var showTax = false
    var showPromo = false
    var showGender = false
    var showDuration = false

    var chairCell = 0
    var dateTimeCell = 0
    var taxCell = 0
    var promoCell = 0
    var firstCellIndex = 0
    var genderCell = 0
    var durationCell = 0

    var orderTotal : Float = 0
    var screenType : SubMenuDataType = .reservation
    
    @IBOutlet weak var tbl_items: UITableView!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    @IBOutlet weak var constraint_totalLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var bottom_view: UIView!
   
    
    override func viewWillAppear(_ animated: Bool) {
        Helper.logScreen(screenName : "Order Preview", className : "PreviewVC")
        tbl_items.rowHeight = UITableViewAutomaticDimension
        tbl_items.estimatedRowHeight = 200
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        self.updateTaxAndPromocode()
        
        if let taxPromo = reservation.taxPromoTotal {
            showTax = taxPromo.sub_total > Float(0) ? true : false
            showPromo = showTax
        }
        
        switch screenType {
        case .quantity_selection , .tabs_quantity_selection:
            self.lbl_total.isHidden = false
            self.lbl_subtitle.isHidden = false
            self.constraint_totalLabelWidth.constant = 125
        default:
            self.lbl_total.isHidden = (orderTotal <= 0) ? true : false
            self.lbl_subtitle.isHidden = (orderTotal <= 0) ? true : false
            self.constraint_totalLabelWidth.constant = (orderTotal <= 0) ? 0 : 125
        }
        
        if screenType == .quantity_selection && reservation.instant_order == false{
            showPromo = false
        }
        if let gender = selectedMenu?.items_attributes?.ask_gender, gender == true {
            self.showGender = true
        }
        if (reservation.chair_number != nil && reservation.chair_number != "") || (reservation.room_number != nil && reservation.room_number != "") {
            self.showChair = true
        }
        self.checkCells()

    }
    func checkCells() {
        switch screenType {
        case .submenu_selection:
            showDuration = reservation.instructor != nil ? true : false
        default:
            showDuration =  false
        }
        dateTimeCell = showDate ? 1 : showTime ? 1 : 0
        chairCell = showChair ? 1 : 0
        taxCell = showTax ? 1 : 0
        promoCell = showPromo ? 1 : 0
        genderCell = showGender ? 1 : 0
        durationCell = showDuration ? 1 : 0

        firstCellIndex = dateTimeCell == 1 ? (genderCell == 1 ? 2 : 1) : (chairCell == 1 ? (genderCell == 1 ?2 : 1) : (genderCell == 1 ? 1 : 0))
    }
    @IBAction func CancelAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    @IBAction func continueAction(_ sender: UIButton) {
        if let disclaimer = selectedMenu?.disclaimer, disclaimer != "" {
            let controller = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.DisclaimerVC) as! DisclaimerVC
            controller.disclaimerText = disclaimer
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            makeReservation()
        }
    }
    
    func makeReservation(){
        if reservation.isModification {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            let bizObject = BusinessLayer()
            bizObject.modifyReservation(obj: reservation, isOrder: true, { (status, reservationModel,title,message) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                    self.delegate?.reservationCompletedWith(status: status, model: reservationModel, alertTitle: title, alertMessage: message)
                })
            })
        }
        else{
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            let bizObject = BusinessLayer()
            bizObject.reservation(obj: reservation, isOrder: true, { (status, reservationModel,title,message) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                })
                self.delegate?.reservationCompletedWith(status: status, model: reservationModel, alertTitle: title, alertMessage: message)
            })
        }
    }
    
    @objc func backAction(_ sender: UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateTaxAndPromocode() {
        self.reservation.taxPromoTotal = TaxPromoTotal().calculateTaxesForReservation(reservation : reservation)
        if let total = reservation.taxPromoTotal?.order_total {
            orderTotal = total
        }
        self.lbl_total.text = String.init(format: "$%.2f", orderTotal)
        
    }
    
}
extension PreviewVC: UITableViewDelegate, UITableViewDataSource, PromocodeDelegate, DisclaimerDelegate, BookingDetailDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let roomNumber = reservation.room_number, roomNumber.characters.count > 0 {
            return 3
        }
        else {
            return 2
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 1 // room number
        case 1:
            switch screenType {
            case .quantity_selection, .tabs_quantity_selection:
                // date + items + tax cell + promo
                return dateTimeCell + (reservation.items?.count)! + taxCell + promoCell
            case .service_selection:
                // date + items + tax cell + promo + gender
                return dateTimeCell + (reservation.items?.count)! + taxCell + promoCell + genderCell
            default:
                // date + items
                return dateTimeCell + (reservation.items?.count)! + durationCell
            }
        default:
            return 1 // cancel
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                if let chair = reservation.chair_number {
                    cell.lbl_subTitle.text = chair
                }
                else if let room_number = reservation.room_number {
                    cell.lbl_title.text = TITLE.RoomNumber
                    cell.lbl_subTitle.text = room_number
                    cell.img_cellImage.image = #imageLiteral(resourceName: "roomNumberIcon")
                }
                return cell
        case 1:
            switch indexPath.row {
            case 0 :
                if showDate == true && showTime == false{
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DATE, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    if let date = Helper.getOptionalDateFromString(string: reservation.appointment_date!, formatString: DATEFORMATTER.YYYY_MM_DD_HH_MM){
                        cell.lbl_subTitle.text = Helper.getStringFromDate(format: DATEFORMATTER.MMDDYYYY, date: date)
                    }else{
                        cell.lbl_subTitle.text = reservation.appointment_date?.components(separatedBy: " ").first
                    }
                    
                    return cell
                }
                else if showDate == true && showTime == true {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DATE_TIME, for: indexPath as IndexPath) as! BookingDetailCell
                    if let date = Helper.getOptionalDateFromString(string: reservation.appointment_date!, formatString: DATEFORMATTER.YYYY_MM_DD_HH_MM){
                        cell.lbl_subTitle.text = Helper.getStringFromDate(format: DATEFORMATTER.MMDDYYYY, date: date)
                        cell.timeLabel.text =  Helper.getStringFromDate(format: DATEFORMATTER.HH_MM_A, date: date)
                    }else{
                        cell.lbl_subTitle.text = reservation.appointment_date?.components(separatedBy: " ").first
                        cell.timeLabel.text =  reservation.appointment_date?.components(separatedBy: " ").last
                    }
                    
                    return cell
                }
                else if showChair{
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                    if let chair = reservation.chair_number {
                        cell.lbl_subTitle.text = chair
                    }
                    else if let room_number = reservation.room_number {
                        cell.lbl_title.text = "Room Number"
                        cell.lbl_subTitle.text = room_number
                        cell.img_cellImage.image = #imageLiteral(resourceName: "roomNumberIcon")
                    }
                    
                    return cell
                }
                else{
                    fallthrough
                }
            case genderCell:
                if showGender{
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_QUANTITY, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.reservationType.text = "Therapist"
                    cell.lbl_quantity_price.text = reservation.gender?.capitalized
                    return cell
                }
                else{
                    fallthrough
                }
            case genderCell + durationCell :
                if showDuration {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_INSTRUCTOR_CELL, for: indexPath as IndexPath) as! BookingDetailCell
                    if let duration = reservation.duration, duration != "" {
                        cell.lbl_duration.text = "\(TITLE.duration)\(duration)"
                    }
                    else {
                        cell.lbl_duration.text = ""
                    }
                    if let instructor = reservation.instructor {
                        cell.lbl_instructor.text = "\(TITLE.instructor)\(instructor == true ? BUTTON_TITLE.Yes : BUTTON_TITLE.No)"
                    }
                    else {
                        cell.lbl_instructor.text = ""
                    }
                    return cell
                }
                else {
                    fallthrough
                }
            case (firstCellIndex + durationCell)...((reservation.items?.count)! + genderCell + durationCell):
                // if we have date row also then we will have to add this 1
                switch screenType {
                case .quantity_selection:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_QUANTITY_DELETE, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    if let item = reservation.items?[indexPath.row - (firstCellIndex + durationCell)] {
                        cell.setupCellFor(item : item, delegate : self)
                    }
                    return cell
                case .service_selection, .submenu_selection:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_TOTAL, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    if let people = reservation.number_of_people {
                        if people > 0 {
                            cell.reservationTotal.text = "\(people)"
                        }
                        else{
                            cell.reservationTotal.isHidden = true
                        }
                    }
                    
                    if let item = reservation.items?[indexPath.row - (firstCellIndex + durationCell)] {
                        cell.reservationType.text = item.item_name
                        if let price = item.item_price {
                            if let actualPrice = Float(price) {
                                if actualPrice <= 0 {
                                    cell.reservationTotal.isHidden = true
                                }
                                else{
                                    cell.reservationTotal.isHidden = false
                                    cell.reservationTotal.text = "$\(price)"
                                }
                            }
                        }
                    }
                    
                    return cell
                case .tabs_quantity_selection:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_QUANTITY_DELETE, for: indexPath as IndexPath) as! BookingDetailCell
                    if let item = reservation.items?[indexPath.row - (firstCellIndex + durationCell)] {
                        cell.setupCellFor(item : item, delegate : self)
                    }
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_QUANTITY_DELETE, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    if let item = reservation.items?[indexPath.row - (firstCellIndex + durationCell)] {
                        cell.setupCellFor(item : item, delegate : self)
                    }
                    return cell
                }
            case ((reservation.items?.count)! + taxCell + genderCell + durationCell):
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.TAX_CELL, for: indexPath as IndexPath) as! TaxCell
                cell.reservationModel = self.reservation
                cell.setupTaxesLabels()
                cell.lbl_stateTaxText.text = TITLE.statetax
                return cell
            case ((reservation.items?.count)! + taxCell + promoCell + genderCell + durationCell):
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.PROMO_CELL, for: indexPath as IndexPath) as! TaxCell
                cell.reservationModel = self.reservation
                cell.btn_promocode.addTarget(self, action: #selector(showPromocodeDialog(_:)), for: .touchUpInside)
                cell.setupPromocodeLabel()
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                
                cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
            
            cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
            cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
            cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
            cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
            return cell
        }

    }
 
    
//    MARK: FooterView
    @objc func showPromocodeDialog(_ sender : UIButton) {
        Helper.showPromocodeDialog(delegate: self, navigationController: self.navigationController, controller: self)
        
    }
    
//    MARK: Disclaimer Delegate
    func disclaimerAgreed(){
         makeReservation()
    }
    
//    MARK: Promocode Delegate
    func enteredPromocode(code: String) {
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        }
        print(code)
        var dict :[String : Any] = [:]
        dict["code"] = code
        if let dept_id = self.reservation.department_id {
            dict["department_id"] = dept_id
        }
        
        
        let obj = BusinessLayer()
        obj.applyPromocode(obj: dict as NSDictionary) { (status, message, promocode) in
            DispatchQueue.main.async {
                self.deactivateView(self.view)
                
                if status {
                    
                }
                else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
                
                self.reservation.promocode = promocode
                self.updateTaxAndPromocode()
                self.tbl_items.reloadData()
            }
            
        }
        
    }
//    MARK: BOOKINGDETAILDELEGATE
    func removeItem(item: Menu) {
        if let items = self.reservation.items {
            if items.contains(item) {
                self.reservation.items?.remove(at: items.index(of: item)!)
            }
            if (self.reservation.items?.count)! > 0 {
                self.updateTaxAndPromocode()
                self.tbl_items.reloadData()
            }
            else {
                self.backAction(nil)
            }
            
        }
        
    }
    
}

//
//  PreviewReservationVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 30/10/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol PreviewReservationDelegate {
    func reservationCompletedWith(status : Bool, model: ReservationModel?, alertTitle : String, alertMessage: String)
}
class PreviewReservationVC: BaseViewController {
    
    var delegate : PreviewReservationDelegate?
    var titleBarText : String? = ""
    var reservation : ReservationModel = ReservationModel()
    var alreadyReserved = false
    var selectedMenu : Menu?
    var showDate = true
    var showTime = false
    var showPromo = false
    var showOccasion = false
    var showDuration = false
    var showRoom = false
    var showTennisCourt = false
    var promoCell = 0
    var occasionCell = 0
    var durationCell = 0
    var roomCell = 0
    var tennisCell = 0
    var orderTotal : Float = 0
    var screenType : SubMenuDataType = .reservation
    
//    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var tbl_items: UITableView!
//    @IBOutlet weak var lbl_subtitle: UILabel!
//    @IBOutlet weak var constraint_totalLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var btn_continue: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tbl_items.rowHeight = UITableViewAutomaticDimension
        tbl_items.estimatedRowHeight = 200
        Helper.logScreen(screenName : "Reservation Preview", className : "PreviewReservationVC")

        btn_continue.setTitle(BUTTON_TITLE.Continue, for: .normal)
        self.navigationItem.title = titleBarText
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        checkCell()
        updateTaxAndPromocode()
    }
    func checkCell() {
        if self.reservation.occasion != nil && self.reservation.occasion != "" {
            showOccasion = true
        }
        if self.reservation.specialRequest != nil && self.reservation.specialRequest != "" {
            showOccasion = true
        }
        if reservation.instructor != nil {
            showDuration = true
            showTennisCourt = true
        }
        if self.screenType == .reservation {
            self.showRoom = true
        }
        
        promoCell = showPromo ? 1 : 0
        occasionCell = showOccasion ? 1 : 0
        durationCell = showDuration ? 1 : 0
        roomCell = durationCell
        tennisCell = showTennisCourt ? 1 : 0
        if showRoom {
            roomCell = 1
        }
    }
    func updateTaxAndPromocode() {
        self.reservation.taxPromoTotal = TaxPromoTotal().calculateTaxesForReservation(reservation : reservation)
        if let total = reservation.taxPromoTotal?.order_total {
            orderTotal = total
        }
//        self.lbl_total.text = String.init(format: "$%.2f", orderTotal)
        
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
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func makeReservation() {
        
        if reservation.isModification {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            let bizObject = BusinessLayer()
            bizObject.modifyReservation(obj: reservation, isOrder: false, { (status, reservationModel,title,message) in
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
            bizObject.reservation(obj: reservation, isOrder: false, { (status, reservationModel,title,message) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                })
                self.delegate?.reservationCompletedWith(status: status, model: reservationModel, alertTitle: title, alertMessage: message)
            })
        }
    }
    
}

extension PreviewReservationVC: UITableViewDelegate, UITableViewDataSource, PromocodeDelegate, DisclaimerDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // room number + date time + number of people/duration
        return section == 0 ? roomCell + 1 + 1 + tennisCell: occasionCell + promoCell + 1//cancel
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if showDuration || showRoom {
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
                }
                else {
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

            case 1:
                if showDuration || showRoom {
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
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_NUMBER, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    cell.lbl_title.text = "Number of People"
                    if let people = reservation.number_of_people {
                        cell.lbl_count.text = "\(people)"
                    }
                    return cell
                }
                
            case 2:
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
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_NUMBER, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    cell.lbl_title.text = "Number of People"
                    if let people = reservation.number_of_people {
                        cell.lbl_count.text = "\(people)"
                    }
                    return cell
                }
            case 3:
                if showTennisCourt {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_TOTAL, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.reservationType.text = titleBarText
                    return cell
                }
                fallthrough
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
               
                cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            }
        }
        else {
            switch indexPath.row {
            case 0:
                if showOccasion {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_OCCASION, for: indexPath as IndexPath) as! BookingDetailCell
                    if let occasion = self.reservation.occasion {
                        cell.reservationType.text = occasion
                    }
                    else{
                        cell.constraint_occasion.constant = 0
                    }
                    
                    if let req =  self.reservation.specialRequest {
                        cell.lbl_quantity_price.text = req
                    }
                    else{
                        cell.constraint_specialRequest.constant = 0
                    }
                    return cell
                    
                }
                else if showPromo {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.TAX_CELL, for: indexPath as IndexPath) as! TaxCell
                    
                    cell.reservationModel = self.reservation
                    cell.btn_promocode.addTarget(self, action: #selector(showPromocodeDialog(_:)), for: .touchUpInside)
                    cell.setupPromocodeLabel()
                    return cell
                }
                else{
                    fallthrough
                }
            case promoCell :
                if showPromo && showOccasion {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.TAX_CELL, for: indexPath as IndexPath) as! TaxCell
                
                cell.reservationModel = self.reservation
                cell.btn_promocode.addTarget(self, action: #selector(showPromocodeDialog(_:)), for: .touchUpInside)
                cell.setupPromocodeLabel()
                return cell
                }
                fallthrough
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            }
        }
    }
//    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 && indexPath.row == occasionCell && showOccasion {
//            return 85
//        }
//        return 65
//    }
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//
//        return 65
//
//    }
    //    MARK: FooterView
    @objc func showPromocodeDialog(_ sender : UIButton) {
        Helper.showPromocodeDialog(delegate: self, navigationController: self.navigationController, controller: self)
    }
    //    MARK: Disclaimer Delegate
    func disclaimerAgreed(){
        makeReservation()
    }
    //    MARK:Promocode Delegate
    func enteredPromocode(code: String) {
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        }
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
                    self.reservation.promocode = promocode
                    self.updateTaxAndPromocode()
                    self.tbl_items.reloadData()
                }
                else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            }
            
        }
        
    }
}

//
//  ReservationSecondVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 15/06/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class ReservationSecondVC: BaseViewController {
    
    
    var titleBarText : String? = ""
       var reservation : ReservationModel = ReservationModel()
       var reservationModel : ReservationModel = ReservationModel()
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
    
     
    
    
    
    var titleValue : String? = "Reservation"
    
    @IBOutlet weak var btnGoBack: UIButton?
    @IBOutlet weak var btnConfirm: UIButton?
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblReserName: UILabel?
    @IBOutlet weak var lblKids: UILabel?
    @IBOutlet weak var lblNumberOfGuest: UILabel?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblEmail: UILabel?
    @IBOutlet weak var lblDuration: UILabel?
    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGoBack?.setTitle(BUTTON_TITLE.Go_Back, for: .normal)
        btnConfirm?.setTitle(BUTTON_TITLE.Confirm, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar(title : titleValue ?? "Reservation")

    }
    
    
    
    @IBAction func goBackAction(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender:UIButton) {
        
        if showDate == true{
            self.makeReservation()
        }else{
            
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "WalletPayVC") as! WalletPayVC
            self.definesPresentationContext = true
            objAlert.reservation = self.reservation
            objAlert.titleValue = self.titleValue!
            objAlert.modalPresentationStyle = .overCurrentContext
            self.navigationController?.pushViewController(objAlert, animated: true)
            
            
        }
        
        
        
        
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
                       if let reserVation = reservationModel{
                           self.showAlertView(reservationModel: reserVation)
                       }                   })
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
                    if let reserVation = reservationModel{
                        self.showAlertView(reservationModel: reserVation)
                    }
                       
                   })
                   
               })
           }
       }
    
    
    private func showAlertView(reservationModel : ReservationModel){
        
        self.reservationModel = reservationModel
        let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
        self.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.delegate = self
        
        objAlert.set(title: "Thank you for your request", message: "Your request has been received, We Will get back to you shortly to confirm your reservation", done_title: BUTTON_TITLE.Continue)
        self.navigationController?.present(objAlert, animated: true, completion: {
        })
        
    }
    
    
}



//MARK:  tableview delegate datasource methods
extension ReservationSecondVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.ReservationDetailCell, for: indexPath as IndexPath) as! ReservationDetailCell
        cell.isShowDateTime = showDate
        cell.reservation = self.reservation
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}






//MARK: AlertVuew Delegate
extension ReservationSecondVC: AlertVCDelegate{
    func alertDismissed() {
        self.dismiss(animated: true) {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "ReservationConfirmVC") as! ReservationConfirmVC
            self.definesPresentationContext = true
            objAlert.reservation = self.reservationModel
            objAlert.delegate = self
            objAlert.titleValue = self.titleValue!
            objAlert.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(objAlert, animated: true, completion: {
            })
            
            
        }
        
        
    }
    
    
}


//MARK:  Delegate after confirmation
extension ReservationSecondVC: ReservationConfirmDelegate{
    func alertDismissedToRootView() {
        self.dismiss(animated: false) {
            
            //self.navigationController?.popToRootViewController(animated: true)
            if let destinationViewController = self.navigationController?.viewControllers
                                                                    .filter(
                                                  {$0 is BaseTabBarVC})
                                                                    .first {
                self.navigationController?.popToViewController(destinationViewController, animated: true)
            }
            
            
        }
    }
}






//MARK: ReservationDetailCell class
class ReservationDetailCell : UITableViewCell{
    
    
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblTotal: UILabel?
    @IBOutlet weak var lblKids: UILabel?
    @IBOutlet weak var lblNumberOfGuest: UILabel?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblEmail: UILabel?
    @IBOutlet weak var lblSelectedPackagePrice: UILabel?
    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    @IBOutlet weak var lblTotalVale: UILabel?
    @IBOutlet weak var lblKidsValue: UILabel?
    @IBOutlet weak var lblNumberOfGuestValue: UILabel?
    @IBOutlet weak var lblNameValue: UILabel?
    @IBOutlet weak var lblEmailValue: UILabel?
    @IBOutlet weak var lblSelectedPackageValue: UILabel?
    @IBOutlet weak var lblDateValue: UILabel?
    @IBOutlet weak var lblTimeValue: UILabel?
    
    var isShowDateTime : Bool? = true
    
    var reservation : ReservationModel?{
        didSet{
            setDataValue()
        }
    }
    
    var orederHistory : OrderListing?{
        didSet{
            setOrderDataValue()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLocalizeStringToParameters()
        lblSelectedPackagePrice?.isHidden = true
        lblSelectedPackageValue?.isHidden = true
        lblTotalVale?.isHidden = false
        lblTotal?.isHidden = false
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setLocalizeStringToParameters(){
        
        lblTitle?.text = "Booking Detail"//TITLE.bowlingReservation
        lblTotal?.text = TITLE.Total+":"
        
        
        lblNumberOfGuest?.text = TITLE.numberofguests
        lblName?.text = TITLE.nameTitle
        lblEmail?.text = TITLE.emailTitle
        lblSelectedPackagePrice?.text = TITLE.durationTitle
        lblDate?.text = TITLE.dateTitle
        lblTime?.text = TITLE.timeTitle
    }
    
    func setDataValue(){
        if let total = reservation?.totalSelectedPrice{
            lblTotalVale?.text = "\(Int(total)) Dezer Bucks"
        }
        if let specialrequestValue = reservation?.specialRequest{
            lblKids?.text = "Special Requests:"//TITLE.kidsTitle
            lblKids?.isHidden = false
            lblKidsValue?.isHidden = false
        }else{
            lblKids?.isHidden = true
            lblKidsValue?.isHidden = true
        }
        
        lblKidsValue?.text = reservation?.specialRequest//"\(reservation?.number_of_people ?? 0)"
        lblNumberOfGuestValue?.text = "\(reservation?.number_of_people ?? 0)"
        
        if let name = AppInstance.applicationInstance.user?.name{
            lblNameValue?.text = name
        }
        if let email = AppInstance.applicationInstance.user?.email{
            lblEmailValue?.text = email
        }
        lblSelectedPackageValue?.text = reservation?.module_name
        lblDateValue?.text = reservation?.appointment_date
        lblTimeValue?.text = reservation?.appointment_time
        
        if isShowDateTime == false{
            lblDate?.isHidden = true
            lblTime?.isHidden = true
            lblDateValue?.isHidden = true
            lblTimeValue?.isHidden = true
        }
        
        
        
    }
    
    
    
    func setOrderDataValue(){
        if let total = orederHistory?.totalSelectedPrice{
            lblTotalVale?.text = "\(Int(total)) Dezer Bucks"
        }
        if let specialrequestValue = orederHistory?.specialRequest{
            lblKids?.text = "Special Requests:"//TITLE.kidsTitle
            lblKids?.isHidden = false
            lblKidsValue?.isHidden = false
        }else{
            lblKids?.isHidden = true
            lblKidsValue?.isHidden = true
        }
        
        lblKidsValue?.text = orederHistory?.specialRequest//"\(reservation?.number_of_people ?? 0)"
        lblNumberOfGuestValue?.text = "\(orederHistory?.number_of_people ?? 0)"
        
        if let name = AppInstance.applicationInstance.user?.name{
            lblNameValue?.text = name
        }
        if let email = AppInstance.applicationInstance.user?.email{
            lblEmailValue?.text = email
        }
        lblSelectedPackageValue?.text = orederHistory?.module_id
        
        lblDateValue?.text = Helper.getStringFromUTCDate(format: DATEFORMATTER.DD_MMMYYYY, date: Helper.getDateFromString(string: orederHistory?.bookingDate ?? "", formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ))
        lblTimeValue?.text = Helper.getStringFromUTCDate(format: DATEFORMATTER.hhmma, date: Helper.getDateFromString(string: orederHistory?.bookingDate ?? "", formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ))
        
        
        if isShowDateTime == false{
            lblDate?.isHidden = true
            lblTime?.isHidden = true
            lblDateValue?.isHidden = true
            lblTimeValue?.isHidden = true
        }
        
        
        
    }
    
    
    
}




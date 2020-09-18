//
//  BookingDetailVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/20/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class BookingDetailVC: BaseViewController {
    var titleBarText : String? = "Planet Kids"
    var reservation : ReservationModel?
    var screenType : SubMenuDataType = .reservation

    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var constraint_totalLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var bottom_view: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Planet kids order preview screen", className: "BookingDetailVC")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        switch screenType {
        case .reservation:
            bottom_view.isHidden = true
        default:
            bottom_view.isHidden = false
        }

       self.showConfirmationAlert()
    }
    
    func showConfirmationAlert() {
        guard let alertTitle = reservation?.alertTitle else {
            return
        }
        guard let alertMessage = reservation?.alertMessage else {
            return
        }
        if alertMessage == "" || alertTitle == "" {
            return
        }
        else{
            self.showConfirmationDialog(title: alertTitle, message: alertMessage)
        }
        
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        self.backAction(sender)
    }
    @objc func backAction(_ sender: UIButton) {
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
    
    @IBAction func CancelAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject = BusinessLayer()
        bizObject.cancelReservation(appointmentId: (reservation?._id)!, {(status , response) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if status {
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
            })
        })
    }
    
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.present(objAlert, animated: false) {
            }
        })
    }
}

extension BookingDetailVC: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            var row = 4
            switch screenType {
            case .reservation:
                row = 5
            default:
                row = 4
            }
            return row
        }
        else{
            return 2
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CONFIRMATION_NUMBER, for: indexPath as IndexPath) as! BookingDetailCell
                cell.lbl_subTitle.text = reservation?.confirmation_number?.uppercased()
                cell.booking_status.text = reservation?.appointment_status?.capitalized
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DATE_TIME, for: indexPath as IndexPath) as! BookingDetailCell
                cell.lbl_subTitle.text = reservation?.appointment_date
                cell.timeLabel.text = reservation?.appointment_time
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_TOTAL, for: indexPath as IndexPath) as! BookingDetailCell
                
                cell.reservationType.text = reservation?.items?.first?.item_name
                if let price = reservation?.items?.first?.item_price {
                    if price == "0" || price == "" {
                        cell.reservationTotal.isHidden = true
                        self.constraint_totalLabelWidth.constant = 0
                    }else{
                        cell.reservationTotal.text = "$\(price)"
                        self.lbl_total.text = "$\(price)"
                        self.constraint_totalLabelWidth.constant = 125
                    }
                    
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                switch screenType {
                case .reservation:
                    cell.cancelBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
                    cell.cancelBtn.setTitle(BUTTON_TITLE.Continue, for: .normal)
                    cell.cancelBtn.setBackgroundImage(UIImage(named:"btn_turqoise"), for: .normal)
                default:
                    cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
                    cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                    cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                
                cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                cell.cancelBtn.titleLabel?.textColor = .white
                cell.cancelBtn.setTitleColor(.white, for: .normal)
                
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CONFIRMATION_NUMBER, for: indexPath as IndexPath) as! BookingDetailCell
                
                return cell
            }
        }
        else{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                cell.cancelBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(TITLE.Modify, for: .normal)
                cell.cancelBtn.setBackgroundImage(UIImage(named:"btn_turqoise"), for: .normal)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                
                cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(TITLE.Cancel, for: .normal)
                cell.cancelBtn.titleLabel?.textColor = .white
                cell.cancelBtn.setTitleColor(.white, for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            }
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 65
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
    }
}

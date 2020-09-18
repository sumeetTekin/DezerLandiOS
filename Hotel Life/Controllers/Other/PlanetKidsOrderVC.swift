//
//  PlanetKidsOrderVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 18/10/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class PlanetKidsOrderVC: BaseViewController {

    
    var titleBarText : String? = "Planet Kids"
    var reservation : ReservationModel?
    
    @IBOutlet weak var btn_continue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Planet kids order screen", className: "PlanetKidsOrderVC")

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
    
    @objc func modifyAction(_ sender: UIButton) {
        if let id = reservation?.department_id {
            self.getDepartment(departmentId: id, {(status, message, dept) in
                if status {
                    let objCustomTable : BookingDayVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.BookingDayVC) as! BookingDayVC
                    objCustomTable.selectedMenu.module_id = self.reservation?.module_id
                    objCustomTable.selectedMenu.department_Id = self.reservation?.department_id
                    objCustomTable.selectedMenu.order_Id = self.reservation?._id
                    objCustomTable.tableCellType = .none
                    objCustomTable.titleBarText = self.titleBarText
                    objCustomTable.isModification = true
                    if let arr = dept {
                        for depObj in arr {
                            if let menus = depObj.items{
                                if menus.count > 0{
                                    for menu in menus{
                                        menu.module_id = id
                                    }
                                    depObj.items = menus
                                }
                            }
                        }
                        objCustomTable.department = arr
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.deactivateView(self.view)
                        self.navigationController?.pushViewController(objCustomTable, animated: true)
                    })
                }
                else{
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.deactivateView(self.view)
                    })
                }
            })
        }
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
    func getDepartment(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Department]?) -> Void) {
        
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status,message, deptItemArray) in
            
            if status {
                if deptItemArray.count > 0 {
                    completionHandlar(true,message,deptItemArray.first?.departments)
                }else{
                    completionHandlar(true,message, nil)
                }
            }else{
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
            }
        })
    }
}
extension PlanetKidsOrderVC: UITableViewDelegate, UITableViewDataSource {
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
    
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            if section == 0 {
                return 4
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
                    cell.booking_status.isHidden = true
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                    if let room_number = reservation?.room_number {
                        cell.lbl_title.text = TITLE.RoomNumber
                        cell.lbl_subTitle.text = room_number
                        cell.img_cellImage.image = #imageLiteral(resourceName: "roomNumberIcon")
                    }
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DAY, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_subTitle.text = reservation?.appointment_date
                    return cell
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_NUMBER, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_title.text = "Number of Kids"
                    if let count = reservation?.number_of_people {
                        cell.lbl_count.text = "\(count)"
                    }
                    
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
                    cell.cancelBtn.addTarget(self, action: #selector(modifyAction(_:)), for: .touchUpInside)
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


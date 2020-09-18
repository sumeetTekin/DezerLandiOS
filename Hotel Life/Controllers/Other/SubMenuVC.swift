//
//  SubMenuVC.swift
//  BeachResorts
//
//  Created by Apple on 16/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class SubMenuVC: BaseViewController {
    
    @IBOutlet weak var tbl_list: UITableView!
    
    var titleBarText: String = ""
    var selectedMenu: Menu = Menu()
    var menuArray : [Menu] = []
    var isDepartmentSubmenu : Bool = false
    var screenType : SubMenuDataType = .reservation
    var specialScreenType : SubMenuDataType?
    var alreadyReserved = false
    
//    MARK: -------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //Helper.logScreen(screenName: "Submenus/Departments screen", className: "SubMenuVC")

//        if isDepartmentSubmenu == false {
//            getSubMenus({ menus in
//                self.menuArray = menus
//                DispatchQueue.main.async(execute: {
//                    self.tbl_list.reloadData()
//                })
//                
//            })
//        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = titleBarText
        self.navigationItem.leftBarButtonItem?.isEnabled = true

        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "previousBlack"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getSubMenus(_ completionHandler : @escaping ([Menu]) -> Void ){
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject = BusinessLayer()
        bizObject.getSubModuleMenu(menuId: selectedMenu.department_Id!, {(status, message, subModules) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            completionHandler(subModules)
        })
    }
    
}

//extension SubMenuVC: UITableViewDelegate, UITableViewDataSource, CustomAlertViewDelegate, ExtraAmenitiesDelegate, QuantityPickerDelegate, AlertVCDelegate, SelectChairVCDelegate {
extension SubMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // get a reference to our storyboard cell
        
        if self.specialScreenType == .submenu_selection {
            if let link = self.selectedMenu.items_attributes?.link,link == true{
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.LOCAL_ATTRACTION, for: indexPath as IndexPath) as! SubMenuCell
                
                cell.configureLinkCell(indexPath: indexPath, menuObj:menuArray[indexPath.row])
                return cell
            }
            if let labelDescription = menuArray[indexPath.row].labelDescription, labelDescription != ""{
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.LOCAL_ATTRACTION, for: indexPath as IndexPath) as! SubMenuCell
                
                cell.configureLinkCell(indexPath: indexPath, menuObj:menuArray[indexPath.row])
                return cell
            }
            if selectedMenu.is_operating == true {
                for menu in menuArray {
                    menu.is_operating = selectedMenu.is_operating
                    menu.operatingHours = selectedMenu.operatingHours
                    menu.operatingHoursSlots = selectedMenu.operatingHoursSlots
                }
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.SUB_MENU, for: indexPath as IndexPath) as! SubMenuCell
        cell.configureCell(indexPath: indexPath, menuObj:menuArray[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if isDepartmentSubmenu {
            return CGFloat(Device.SCREEN_WIDTH/2 - Device.SCREEN_WIDTH/6) + 5
        }else{
            return CGFloat(Device.SCREEN_WIDTH/2 - Device.SCREEN_WIDTH/6)
        }
    }
    
   public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    let menuObj = menuArray[indexPath.row]
    if !(menuObj.isEnabled) {
        Helper.showCancelDialog(title: menuObj.label ?? "Go Hotel Life", message: menuObj.inactive_message ?? "Temporarily disabled", viewController: self)
        return
    }
//    if self.specialScreenType == .submenu_selection && menuArray[indexPath.row].itemType != .contact{
//        if let labelDescription = menuArray[indexPath.row].labelDescription, labelDescription != ""{
//            return
//        }
//    }
    ScreenController.shared.setupScreen(menu : menuArray[indexPath.row], viewController : self, reserved: self.alreadyReserved, specialScreenType: self.specialScreenType)
    }
}



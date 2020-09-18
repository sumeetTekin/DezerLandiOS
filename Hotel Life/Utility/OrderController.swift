//
//  ModificationController.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 05/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class OrderController: NSObject {
    
    
    var viewController : UIViewController!
    var menu_item : Menu?
    var reservation : ReservationModel?
    var screenType : SubMenuDataType!
    static let shared = OrderController()
//    class func shared() -> OrderController {
//        if self.sharedController != nil {
//            return sharedController!
//        }
//        else{
//            sharedController = OrderController()
//            return sharedController!
//        }
//    }
    
    func modifyOrder(menu_item : Menu?, reservation_model : ReservationModel?, screenType : SubMenuDataType, viewController : UIViewController) {
        self.viewController = viewController
        self.menu_item = menu_item
        self.reservation = reservation_model
        menu_item?.department_Id = menu_item?.department_Id == "" ? reservation_model?.department_id : menu_item?.department_Id
        menu_item?.module_id = menu_item?.module_id == "" ? reservation_model?.module_id : menu_item?.module_id
        self.screenType = screenType
        
        if let menuObj = menu_item{
            switch screenType {
            case .quantity_selection:
                self.getDepartment(departmentId: menuObj.department_Id!, {(status, message, tabsArray) in
                    if status {
                        if let tabs = tabsArray{
                            if tabs.count > 1 {
                                self.modifyTabsView(tabs: tabs, type: .quantity_selection)
                            }
                            else{
                                self.modifyQuantity(tabs: tabs)
                            }
                        }
                    }
                })
            case .tabs_quantity_selection:
                self.getDepartment(departmentId: menuObj.department_Id!, {(status, message, tabsArray) in
                    if status {
                        if let tabs = tabsArray{
                            self.modifyTabsView(tabs: tabs, type: .tabs_quantity_selection)
                        }
                    }
                })
            case .service_selection:
                self.getDepartment(departmentId: menuObj.department_Id!, {(status, message, tabs) in
                    if status {
                        self.modifySelection(tabs: tabs)
                    }
                })
            case .submenu_selection:
                self.getDepartment(departmentId: menuObj.department_Id!, {(status, message, tabs) in
                    if status {
                        self.modifySubmenu(tabs: tabs)
                    }
                })
                
            default:
                return
            }
        }
    }
   private func getDepartment(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Tab]?) -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            if let controller = (self.viewController as? BaseViewController) {
                controller.activateView(self.viewController.view, loaderText: LOADER_TEXT.loading)
            }
        })
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status,message, deptItemArray) in
            DispatchQueue.main.async {
                if let controller = (self.viewController as? BaseViewController) {
                    controller.deactivateView(self.viewController.view)
                }
            }
                if status {
                    completionHandlar(true, message, deptItemArray)
                }
                else{
                    Helper.showAlert(sender: self.viewController , title: "Error", message: message)
                }
        })
        
    }
    
    private func modifySelection(tabs : [Tab]?){
        let objCustomTable : CustomTableVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.CustomTable) as! CustomTableVC
        objCustomTable.selectedMenu = self.menu_item!
        objCustomTable.tableCellType = .checkboxCell
        objCustomTable.titleBarText = (self.menu_item?.label!)!
        objCustomTable.alreadyReserved = true
        objCustomTable.reservationModel = self.reservation
        objCustomTable.screenType = self.screenType
        if (self.reservation?.items?.count)! > 0{
            if let id = self.reservation?._id{
                objCustomTable.selectedMenu?.order_Id = id
            }
        }
        if let tabs = tabs {
            for tab in tabs {
                if let departments = tab.departments {
                    for dept in departments {
                        if let menus = dept.items{
                            if menus.count > 0{
                                for menu in menus{
                                    menu.module_id = self.menu_item?.department_Id!
                                    for reserveItem in (self.reservation?.items)!{
                                        if (menu.item_name == reserveItem.item_name) && (menu.item_price == reserveItem.item_price){
                                            menu.isChecked = reserveItem.quantity! > 0 ? true : false
                                            if let id = self.reservation?._id{
                                                menu.order_Id = id
                                            }
                                            print(menu.item_name ?? "")
                                            objCustomTable.selectedArray.append(menu)
                                        }
                                    }
                                }
                                dept.items = menus
                            }
                        }
                    }
                    objCustomTable.department = departments
                }
            }
        }
        DispatchQueue.main.async(execute: {
            self.viewController.navigationController?.pushViewController(objCustomTable, animated: true)
        })
    }
    private func modifyQuantity(tabs : [Tab]?){
        let objCustomTable : CustomTableVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.CustomTable) as! CustomTableVC
        objCustomTable.selectedMenu = self.menu_item!
        objCustomTable.tableCellType = .countCell
        objCustomTable.titleBarText = (self.menu_item?.label!)!
        objCustomTable.alreadyReserved = true
        objCustomTable.screenType = self.screenType
        objCustomTable.reservationModel = self.reservation
        if (self.reservation?.items?.count)! > 0{
            if let id = self.reservation?._id{
                objCustomTable.selectedMenu?.order_Id = id
            }
        }
        if let tabs = tabs {
            for tab in tabs {
                if let departments = tab.departments {
                    for dept in departments {
                        if let menus = dept.items{
                            if menus.count > 0{
                                for menu in menus{
                                    menu.module_id = self.menu_item?.department_Id!
                                    for reserveItem in (self.reservation?.items)!{
                                        if (menu.item_name == reserveItem.item_name) && (menu.item_price == reserveItem.item_price){
                                            menu.quantity = reserveItem.quantity
                                            if let id = self.reservation?._id{
                                                menu.order_Id = id
                                            }
                                            print(menu.item_name ?? "")
                                            objCustomTable.selectedArray.append(menu)
                                        }
                                    }
                                }
                                dept.items = menus
                            }
                        }
                    }
                    objCustomTable.department = departments
                }
            }
        }
        DispatchQueue.main.async(execute: {
            self.viewController.navigationController?.pushViewController(objCustomTable, animated: true)
        })
    }
    
    private func modifyTabsView(tabs : [Tab]?, type : SubMenuDataType){
        let objbeach : BeachPoolTabVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.BeachPoolTabVC) as! BeachPoolTabVC
        objbeach.titleBarText = (self.menu_item?.label!)!
        if let selected = self.menu_item{
            objbeach.titleBarText = selected.label!
            objbeach.selectedMenu = selected
        }
        objbeach.reservation = self.reservation
        objbeach.alreadyReserved = true
        objbeach.screenType = type
        
        if (self.reservation?.items?.count)! > 0{
            if let id = self.reservation?._id{
                objbeach.selectedMenu?.order_Id = id
            }
        }
        
        if let tabs = tabs {
            for tab in tabs {
                if let departments = tab.departments {
                    for dept in departments {
                        if let menus = dept.items{
                            if menus.count > 0{
                                for menu in menus{
                                    menu.module_id = self.menu_item?.department_Id!
                                    for reserveItem in (self.reservation?.items)!{
                                        if (menu.item_name == reserveItem.item_name) && (menu.item_price == reserveItem.item_price){
                                            if reserveItem.removeInNextOrder == false {
                                                menu.quantity = reserveItem.quantity
                                                if let id = self.reservation?._id{
                                                    menu.order_Id = id
                                                }
                                                print(menu.item_name ?? "")
                                                objbeach.selectedArray.append(menu)
                                                reserveItem.removeInNextOrder = true
                                            }
                                            
                                        }
                                    }
                                }
                                dept.items = menus
                            }
                        }
                    }
                    objbeach.department = departments
                }
            }
            objbeach.tab = tabs
        }
        for item in (reservation?.items)! {
            item.removeInNextOrder = false
        }
        DispatchQueue.main.async(execute: {
            self.viewController.navigationController?.pushViewController(objbeach, animated: true)
        })
    }
    private func modifySubmenu(tabs : [Tab]?) {
        let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.SUB_MENU) as! SubMenuVC
        
        objSubMenu.alreadyReserved = true
        if let selected = self.menu_item{
            objSubMenu.titleBarText = selected.label!
            objSubMenu.selectedMenu = selected
        }
        if let id = self.reservation?._id{
            objSubMenu.selectedMenu.order_Id = id
        }
        objSubMenu.isDepartmentSubmenu = true
        if let tabs = tabs {
            for tab in tabs {
                if let depts = tab.departments {
                    for dept in depts {
                        if let menus = dept.items {
                            for menu in menus {
                                // due to server requirement
                                menu.department_Id = objSubMenu.selectedMenu.department_Id
                                menu.module_id = objSubMenu.selectedMenu.module_id
                                menu.order_Id = objSubMenu.selectedMenu.order_Id
                            }
                            dept.items = menus
                            objSubMenu.menuArray = menus
                        }
                    }
                }
            }
        }
        objSubMenu.specialScreenType = .submenu_selection
        DispatchQueue.main.async(execute: {
            self.viewController.navigationController?.pushViewController(objSubMenu, animated: true)
        })
    }
}

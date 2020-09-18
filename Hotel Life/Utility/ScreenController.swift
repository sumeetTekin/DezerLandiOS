//
//  ScreenController.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 06/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class ScreenController: NSObject {
    static let shared = ScreenController()
    var selectedMenu : Menu!
    var viewController : UIViewController!
    var alreadyReserved = false
    var specialScreenType : SubMenuDataType?
    var roomNumber : String?
//    class func shared() -> ScreenController {
//        if sharedObject == nil {
//            sharedObject = ScreenController()
//        }
//        return sharedObject!
//    }
    
    func setupScreen(menu : Menu, viewController : UIViewController, reserved : Bool, specialScreenType : SubMenuDataType?) {
        self.selectedMenu = menu
        self.viewController = viewController
        self.alreadyReserved = reserved
        self.specialScreenType = specialScreenType // used for previous screen type
        if let controller = self.viewController as? BaseViewController {
            DispatchQueue.main.async(execute: { () -> Void in
                controller.activateView(controller.view, loaderText: LOADER_TEXT.loading)
            })
        }
        switch selectedMenu.subMenuDataType {
        //            MARK: Service Selection
        case .service_selection:
//            TODO: Earlier functionality is kept as it is
                if let text = self.selectedMenu?.labelDescription {
                    let controller : RestaurantMenuVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.RestaurantMenuVC) as! RestaurantMenuVC
                    controller.htmlText = text
                    if let title = self.selectedMenu.label {
                        controller.titleBarText = title
                    }
                    DispatchQueue.main.async {
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                        self.viewController.navigationController?.pushViewController(controller, animated: true)
                    }
                    return
                }
            self.checkForReservation(menu: selectedMenu, { (status, reservationModel) in
                
                if status {
                    
                    let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
                    if let model = reservationModel {
                        controller.reservation = model
                    }
                    controller.titleBarText = self.selectedMenu.label!
                    controller.screenType = .service_selection
                    controller.showDate = true
                    controller.showTime = true
                    controller.selectedMenu = self.selectedMenu
                    DispatchQueue.main.async(execute: {
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                        self.viewController.navigationController?.pushViewController(controller, animated: true)
                    })
                }
                else{
                    self.getDepartment(departmentId: self.selectedMenu.department_Id!, {(status, message, dept) in
                        if status {
                            
                            let objCustomTable : CustomTableVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.CustomTable) as! CustomTableVC
                            objCustomTable.tableCellType = .checkboxCell
                            objCustomTable.titleBarText = self.selectedMenu.label!
                            objCustomTable.screenType = .service_selection
                            objCustomTable.selectedMenu = self.selectedMenu
                            if let arr = dept {
                                for depObj in arr{
                                    if let menus = depObj.items{
                                        if menus.count > 0{
                                            for menu in menus{
                                                menu.department_Id = self.selectedMenu.department_Id!
                                                menu.module_id = self.selectedMenu.module_id!
                                            }
                                            depObj.items = menus
                                        }
                                    }
                                }
                                objCustomTable.department = arr
                            }
                            DispatchQueue.main.async(execute: {
                                if let controller = self.viewController as? BaseViewController {
                                    controller.deactivateView(controller.view)
                                }
                                self.viewController.navigationController?.pushViewController(objCustomTable, animated: true)
                            })
                        }
                    })
                }
            })
            break
        //            MARK: Quantity Selection
        case .quantity_selection:
            if selectedMenu.orderType == .direct{
                // In Room Dining
                self.checkForDirectReservation(menu: selectedMenu, { (status, alohaOrder) in
                    if status {
                        if let order = alohaOrder {
                            // Subtotal returned from Aloha was incorrect. So, we get subtotal from all the selected items and modifiers
//                            if let items = order.reservationModel?.items {
//                                order.subTotal = "\(String.init(format: "%.2f", // Subtotal returned from Aloha was incorrect. So, we get subtotal from all the selected items and modifiers(menuArray: items)))"
                                
//                            }
                            if let menus = order.alohaMenu {
                                order.subTotal = "\(String.init(format: "%.2f", Helper.getAlohaMenuQuantityTotal(menuArray: menus)))"
                            }
                            // calculate after discount again from new subtotal
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
                            self.showAlohaOrderWith(order: order, menu: self.selectedMenu)
                        }
                    }else{
                        if self.selectedMenu.items_attributes?.instant_order == true {
                            self.getTabsMenu(menuObj: self.selectedMenu, screenDataType: .quantity_selection,    screenCellType: .countCell)
                        }
                        else {
                            self.getDeptMenu(menuObj: self.selectedMenu, screenDataType: .quantity_selection, screenCellType: .countCell)
                        }
                    }
                })
                break
            }
            else {
                self.checkForReservation(menu: selectedMenu, { (status, reservationModel) in
                    if status {
                        let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
                        controller.titleBarText = self.selectedMenu.label!
                        controller.screenType = .quantity_selection
                        if let model = reservationModel {
                            controller.reservation = model
                        }
                        controller.selectedMenu = self.selectedMenu
                        controller.showDate = true
                        //                    controller.showModify = true
                        if self.selectedMenu.orderType == .direct {
                            controller.showDate = false
                            
                        }
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(controller, animated: true)
                        })
                    }else{
                        if self.selectedMenu.items_attributes?.instant_order == true {
                            self.getTabsMenu(menuObj: self.selectedMenu, screenDataType: .quantity_selection,    screenCellType: .countCell)
                        }
                        else {
                            self.getDeptMenu(menuObj: self.selectedMenu, screenDataType: .quantity_selection, screenCellType: .countCell)
                        }
                        
                    }
                })
                break
            }
            
        //            MARK: Restaurant
        case .restaurant:
            self.getDepartment(departmentId: self.selectedMenu.department_Id!, {(status, message, dept) in
                if status {
                    let controller : RestaurantInformationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.RestaurantInformation) as! RestaurantInformationVC
                    if let label = self.selectedMenu.label {
                        controller.titleBarText = label
                    }
//                    if let desc = self.selectedMenu.linkDescription {
//                        controller.restaurantDescription = desc
//                    }
                    if let dept = dept {
                        controller.department = dept.first
                        
                    }
                    DispatchQueue.main.async(execute: {
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                        self.viewController.navigationController?.pushViewController(controller, animated: true)
                    })
                    
                }
                else{
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                    })
                }
            })
            break
            //            MARK: Reservation
        case .reservation:
            self.checkForReservation(menu: selectedMenu, {(status, reservationModel) in
                if status {
//                    if self.selectedMenu.items_attributes?.is_restaurant == true {
                        let controller : ConfirmationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ConfirmationVC) as! ConfirmationVC
                        controller.navTitle = self.selectedMenu.label!
                        controller.showRoom = true
                        if let model = reservationModel{
                            controller.reservationModel = model
                        }
                        controller.selectedMenu = self.selectedMenu

                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(controller, animated: true)
                        })
                }else{
                    let controllerDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
                    controllerDateTime.titleBarText = self.selectedMenu.label!
                    controllerDateTime.selectedMenu = self.selectedMenu
                    controllerDateTime.showTimeView = true
                    
                    // show duration and instructor for tennis court and hide person view
                    if self.selectedMenu.items_attributes?.is_restaurant == false {
                        controllerDateTime.showDuration = true
                        controllerDateTime.showPersonView = false
                        controllerDateTime.showSpecialRequest = false
                    }
                    else {
                        controllerDateTime.showPersonView = true
                        controllerDateTime.showSpecialRequest = true
                        controllerDateTime.showDuration = false
                    }
                    
                    controllerDateTime.tableCellType = .checkboxCell
                    controllerDateTime.screenType = .reservation
                    
                    if controllerDateTime.selectedMenu.module_id == "" {
                        controllerDateTime.selectedMenu.module_id = self.selectedMenu.department_Id
                    }
                    DispatchQueue.main.async(execute: {
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                    self.viewController.navigationController?.pushViewController(controllerDateTime, animated: true)
                    })
                }
            })
            break
            //            MARK: Service request
        case .service_request:
            getAlertMenu(departmentId: selectedMenu.department_Id!, {(status, message, menu) in
                if status {
                    DispatchQueue.main.async(execute: {
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                        menu?.items_attributes = self.selectedMenu.items_attributes
                        menu?.module_id = self.selectedMenu.module_id!
                        menu?.department_Id = self.selectedMenu.department_Id!
                        if let menu = menu {
                            self.selectedMenu = menu
                            self.showCustomAlertWith(menu: menu)
                        }
                    })
                }else{
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                    })
                }
            })
            break
            //            MARK: Sharing
        case .sharing:
            if let storyboard = Helper.getCustomReusableViewsStoryboard() as? UIStoryboard {
                let controller = storyboard.instantiateViewController(withIdentifier: REUSABLEVIEWS.PostcardVC) as! PostcardVC
                controller.titleBarText = selectedMenu.label!
                DispatchQueue.main.async(execute: {
                    if let controller = self.viewController as? BaseViewController {
                        controller.deactivateView(controller.view)
                    }
                    self.viewController.navigationController?.pushViewController(controller, animated: true)
                })
            }
            
            break
            //            MARK: Link
        case .link:
            DispatchQueue.main.async(execute: {
                if let controller = self.viewController as? BaseViewController {
                    controller.deactivateView(controller.view)
                }
            })
            if selectedMenu.itemType == .contact {
//                TODO: Please check for bugs
                //self.selectedMenu = selectedMenu
                self.showCustomAlertWith(title: self.selectedMenu.label, message: self.selectedMenu.linkDescription, image: #imageLiteral(resourceName: "check_img_green"))
                return
            }
            else if selectedMenu.itemType == .website {
                showWebsite()
            }
            else if selectedMenu.itemType == .local_attraction
            {
                let model = ReservationModel()
                showRoomDialog(model: model)
//                if let msg = self.selectedMenu.label {
//                    let message = "Would you like our concierge to contact you about \(msg)?"
//                    self.showCustomAlertWith(title: self.selectedMenu.label, message: message, image: #imageLiteral(resourceName: "check_img_green"))
//                }
            }

            break
            //            MARK: Attraction
        case .attraction:
            
            if alreadyReserved == false {
                self.checkForReservation(menu: selectedMenu, {(status, reservationModel) in
                    if status {
                        let controller : ConfirmationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ConfirmationVC) as! ConfirmationVC
                        controller.navTitle = self.selectedMenu.label!
                        if let model = reservationModel{
                            controller.reservationModel = model
                        }
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(controller, animated: true)
                        })
                    }else{
                        let controllerDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
                        controllerDateTime.titleBarText = self.selectedMenu.label!
                        controllerDateTime.selectedMenu = self.selectedMenu
                        controllerDateTime.showTimeView = true
                        controllerDateTime.showPersonView = false
                        controllerDateTime.tableCellType = .checkboxCell
                        if self.specialScreenType == .submenu_selection {
                         controllerDateTime.showDuration = true
                        }
                        if self.specialScreenType != .reservation {
                            if let type = self.specialScreenType {
                                controllerDateTime.screenType = type
                                
                            }
                        }
                        else{
                            controllerDateTime.screenType = .reservation
                        }
                        
                        if let time = self.selectedMenu.items_attributes?.default_time {
                            let calendar = Calendar.current
                            var dateComponent = DateComponents()
                            dateComponent.hour = Int(time)
                            if let date = calendar.date(from: dateComponent) {
                                let dateString = Helper.getStringFromDate(format: DATEFORMATTER.HA, date: date)
                                controllerDateTime.defaultTime = dateString
                            }
                        }
                        
                        if controllerDateTime.selectedMenu.module_id == "" {
                            controllerDateTime.selectedMenu.module_id = self.selectedMenu.department_Id
                        }
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(controllerDateTime, animated: true)
                        })
                    }
                })
            }
            else{
                
                let controllerDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
                controllerDateTime.titleBarText = self.selectedMenu.label!
                controllerDateTime.selectedMenu = self.selectedMenu
                controllerDateTime.selectedMenu.order_Id = self.selectedMenu.order_Id
                controllerDateTime.showTimeView = true
                controllerDateTime.showPersonView = false
                controllerDateTime.tableCellType = .checkboxCell
                if self.specialScreenType == .submenu_selection {
                    controllerDateTime.showDuration = true
                }
                if let type = self.specialScreenType {
                    controllerDateTime.screenType = type
                }
                
                controllerDateTime.alreadyReserved = self.selectedMenu.order_Id != nil ? true : false
                if let time = self.selectedMenu.items_attributes?.default_time {
                    let calendar = Calendar.current
                    var dateComponent = DateComponents()
                    dateComponent.hour = Int(time)
                    if let date = calendar.date(from: dateComponent) {
                        let dateString = Helper.getStringFromDate(format: DATEFORMATTER.HA, date: date)
                        controllerDateTime.defaultTime = dateString
                    }
                }
                if controllerDateTime.selectedMenu.module_id == "" {
                    controllerDateTime.selectedMenu.module_id = self.selectedMenu.department_Id
                }
                DispatchQueue.main.async(execute: {
                    if let controller = self.viewController as? BaseViewController {
                        controller.deactivateView(controller.view)
                    }
                    self.viewController.navigationController?.pushViewController(controllerDateTime, animated: true)
                })
            }
            break
        //            MARK: Tabs Quantity Selection
        case .tabs_quantity_selection:
            // pool dining
            checkForDirectReservation(menu: selectedMenu, { (status, alohaOrder) in
                if status {
                    if let model = alohaOrder {
                            if let menus = model.alohaMenu {
                                model.subTotal = "\(String.init(format: "%.2f", Helper.getAlohaMenuQuantityTotal(menuArray: menus)))"
                            }
                            model.afterDiscount = model.calculateSubTotalAfterDiscount()
//                        }
                        if let charge = self.selectedMenu?.tax?.service_charge {
                            model.serviceCharge = model.calculateServiceCharge(charge: charge)
                        }
                        if let charge = self.selectedMenu?.tax?.state_tax {
                            model.stateTax = model.calculateStateTax(charge: charge)
//                            "\(String.init(format: "%.2f", charge))"
                        }
                        if let charge = self.selectedMenu?.tax?.county_tax {
                            model.countyTax = model.calculateCountyTax(charge: charge)
//                            "\(String.init(format: "%.2f", charge))"
                        }
                        model.total = model.calculateTotal()
                        self.showAlohaOrderWith(order: model, menu: self.selectedMenu)
                    }
                }else{
                    self.getTabsMenu(menuObj: self.selectedMenu, screenDataType: .tabs_quantity_selection, screenCellType: .countCell)
                }
            })
            break
        //            MARK: Submenu Selection
        case .submenu_selection:
            guard let isLink = selectedMenu.items_attributes?.link // if selected menu is a link type
                else{
                    if let controller = self.viewController as? BaseViewController {
                        controller.deactivateView(controller.view)
                    }
                    return
            }
            if isLink{
                self.getDepartment(departmentId: self.selectedMenu.department_Id!, {(status, message, dept) in
                    if status {
                        
                        let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.SUB_MENU) as! SubMenuVC
                        
                        objSubMenu.titleBarText = self.selectedMenu.label!
                        objSubMenu.selectedMenu = self.selectedMenu
                        objSubMenu.isDepartmentSubmenu = true
                        if let arr = dept {
                            for depObj in arr {
                                if let menus = depObj.items {
                                    for menu in menus {
                                        // due to server requirement
                                        menu.department_Id = objSubMenu.selectedMenu.department_Id
                                        menu.module_id = objSubMenu.selectedMenu.module_id
                                    }
                                    depObj.items = menus
                                    objSubMenu.menuArray = menus
                                }
                            }
                        }
                        objSubMenu.specialScreenType = .submenu_selection
                        
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(objSubMenu, animated: true)
                        })
                    }
                    else{
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                    }
                })
            }else{
                self.checkForReservation(menu: selectedMenu, { (status, reservationModel) in
                    if status {
                        
                        let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
                        controller.titleBarText = self.selectedMenu.label!
                        controller.screenType = .submenu_selection
                        if let model = reservationModel {
                            controller.reservation = model
                        }
                        controller.alreadyReserved = true
                        controller.selectedMenu = self.selectedMenu
                        controller.showDate = true
                        controller.showTime = true
                        
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(controller, animated: true)
                        })
                        
                    }else{
                        self.getDepartment(departmentId: self.selectedMenu.department_Id!, {(status, message, dept) in
                            if status {
                                let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.SUB_MENU) as! SubMenuVC
                                
                                //                                objSubMenu.subMenuSubTableCellType = .checkboxCell
                                objSubMenu.titleBarText = self.selectedMenu.label!
                                objSubMenu.selectedMenu = self.selectedMenu
                                objSubMenu.isDepartmentSubmenu = true
                                if let arr = dept {
                                    for depObj in arr {
                                        if let menus = depObj.items {
                                            for menu in menus {
                                                // due to server requirement
                                                menu.department_Id = objSubMenu.selectedMenu.department_Id
                                                menu.module_id = objSubMenu.selectedMenu.module_id
                                                menu.disclaimer = self.selectedMenu.disclaimer
                                            }
                                            depObj.items = menus
                                            objSubMenu.menuArray = menus
                                        }
                                    }
                                }
                                
                                objSubMenu.specialScreenType = .submenu_selection
                                objSubMenu.alreadyReserved = self.selectedMenu.order_Id != nil ? true : false
                                DispatchQueue.main.async(execute: {
                                    if let controller = self.viewController as? BaseViewController {
                                        controller.deactivateView(controller.view)
                                    }
                                 self.viewController.navigationController?.pushViewController(objSubMenu, animated: true)
                                })
                            }
                            else{
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if let controller = self.viewController as? BaseViewController {
                                        controller.deactivateView(controller.view)
                                    }
                                })
                            }
                        })
                    }
                })
            }
            break
            //            MARK: Maintenance Request
        case .maintenance_request:
            DispatchQueue.main.async(execute: {
                if let controller = self.viewController as? BaseViewController {
                    controller.deactivateView(controller.view)
                }
                let model = ReservationModel()
                self.showRoomDialog(model: model)
            })

            break
            //            MARK: Kid Zone
        case .kid_zone:
            self.checkForReservation(menu: selectedMenu, { (status, reservationModel) in
                if status {
                    let controller : PlanetKidsOrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.PlanetKidsOrderVC) as! PlanetKidsOrderVC
                    controller.titleBarText = self.selectedMenu.label!
                    controller.reservation = reservationModel
                    DispatchQueue.main.async(execute: {
                        if let controller = self.viewController as? BaseViewController {
                            controller.deactivateView(controller.view)
                        }
                        self.viewController.navigationController?.pushViewController(controller, animated: true)
                    })
                }else{
                    self.getDepartment(departmentId: self.selectedMenu.department_Id!, {(status, message, dept) in
                        if status {
                            let objCustomTable : BookingDayVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.BookingDayVC) as! BookingDayVC
                            objCustomTable.selectedMenu = self.selectedMenu
                            objCustomTable.tableCellType = .none
                            objCustomTable.titleBarText = self.selectedMenu.label!
                            if let arr = dept {
                                for depObj in arr {
                                    if let menus = depObj.items{
                                        if menus.count > 0{
                                            for menu in menus{
                                                menu.module_id = self.selectedMenu.department_Id!
                                            }
                                            depObj.items = menus
                                        }
                                    }
                                }
                                objCustomTable.department = arr
                            }
                            
                            DispatchQueue.main.async(execute: {
                                if let controller = self.viewController as? BaseViewController {
                                    controller.deactivateView(controller.view)
                                }
                                self.viewController.navigationController?.pushViewController(objCustomTable, animated: true)
                            })
                        }
                        else{
                            DispatchQueue.main.async(execute: { () -> Void in
                                if let controller = self.viewController as? BaseViewController {
                                    controller.deactivateView(controller.view)
                                }
                            })
                        }
                    })
                }
            })
            break
        default:
            break
        }
        
    }
    private func showWebsite() {
        if let urlStr = selectedMenu.link{
            if let url = URL.init(string: "https://dezerlandpark.com") {
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.openURL(url)
                }
            }else{
                Helper.showAlert(sender: self.viewController, title: "Error", message: "Invalid Url")
            }
        }
//        else{
//            let url = URL.init(string: trumpUrl)
//            if UIApplication.shared.canOpenURL(url!){
//                UIApplication.shared.openURL(url!)
//            }
//        }
    }
    private func showMaintenanceRequest(room_number : String?) {
        let maintainanceController = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.MaintainanceRequestVC) as! MaintainanceRequestVC
        maintainanceController.selectedMenu = selectedMenu
        maintainanceController.titleBarText = TITLE.MaintenanceRequest
        maintainanceController.room_number = room_number
        DispatchQueue.main.async(execute: {
            if let controller = self.viewController as? BaseViewController {
                controller.deactivateView(controller.view)
            }
            self.viewController.navigationController?.pushViewController(maintainanceController, animated: true)
        })
    }
    private func checkForReservation(menu : Menu ,_ completionHandler : @escaping (Bool,ReservationModel?) -> Void){
        // here module id will be parent id of selected menu
        // here dep id will be module id of selected menu
        
        let bizObject = BusinessLayer()
        
        if menu.orderType == .indirect{
            bizObject.getReservation(moduleId:menu.module_id! , departmentId:menu.department_Id!, { (status, reservationModel) in
                completionHandler(status,reservationModel)
            })
        }
        
    }
    
    // for in room dining and beach pool dining reservation check
    private func checkForDirectReservation(menu : Menu ,_ completionHandler : @escaping (Bool,AlohaOrder?) -> Void){
        // here module id will be parent id of selected menu
        // here dep id will be module id of selected menu
        
        let bizObject = BusinessLayer()
        
        if menu.orderType == .direct{
            bizObject.getDirectReservation(moduleId:menu.module_id! , departmentId:menu.department_Id!, { (status, alohaOrder) in
                completionHandler(status, alohaOrder)
            })
        }
        
    }
    private func getSubMenus(_ completionHandler : @escaping ([Menu]) -> Void ){
        DispatchQueue.main.async(execute: { () -> Void in
            if let controller = self.viewController as? BaseViewController {
               controller.activateView(controller.view, loaderText: LOADER_TEXT.loading)
            }
        })
        let bizObject = BusinessLayer()
        bizObject.getSubModuleMenu(menuId: selectedMenu.department_Id!, {(status, message, subModules) in
            DispatchQueue.main.async(execute: { () -> Void in
                if let controller = self.viewController as? BaseViewController {
                    controller.deactivateView(controller.view)
                }
            })
            completionHandler(subModules)
        })
    }
    
    private func getDepartment(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Department]?) -> Void) {
       
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status,message, deptItemArray) in
           
            if status {
                completionHandlar(true,message,deptItemArray.first?.departments)
            }else{
                Helper.showAlert(sender: self.viewController, title: ALERTSTRING.ERROR, message: message)
            }
        })
    }
    private func getKidZoneMenuItems(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Menu]?) -> Void) {
        
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status,message, deptItemArray) in
            
            if status {
                if let dept = deptItemArray.first?.departments?.first {
                    completionHandlar(true,message,dept.items)
                }
            }
            else{
                Helper.showAlert(sender: self.viewController, title: ALERTSTRING.ERROR, message: message)
            }
        })
        
    }
    
    private func getTabsDepartmentMenuItems(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Tab]?) -> Void) {
        
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status, message, tabsArray) in
           
            if status {
                if tabsArray.count >= 1 {
                    completionHandlar(true,message,tabsArray)
                }
            }
            else{
                Helper.showAlert(sender: self.viewController, title: ALERTSTRING.ERROR, message: message)
            }
            
        })
        
    }
    
    private func getAlertMenu(departmentId : String , _ completionHandlar : @escaping (Bool, String, Menu?) -> Void) {
        
        let bizObject = BusinessLayer()
        bizObject.getAlertMenu(departmentId: departmentId, { (status, message, returnedMenu) in
            
            if status {
                completionHandlar(true,message,returnedMenu)
            }
            else{
                completionHandlar(false,message,nil)
                Helper.showAlert(sender: self.viewController, title: ALERTSTRING.ERROR, message: message)
            }
            
        })
        
    }
    private func getTabsMenu(menuObj : Menu, screenDataType : SubMenuDataType, screenCellType:CellType){
            let obj = BusinessLayer()
            obj.getAlohaMenu(query : screenDataType == .quantity_selection ? QUERY.IRD: nil, { (status, response, array)  in
                let receivedTabsArray = array
                if  receivedTabsArray.count > 0{
                    if receivedTabsArray.count > 1{
                        let objbeach : BeachPoolTabVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.BeachPoolTabVC) as! BeachPoolTabVC
                        objbeach.titleBarText = self.selectedMenu.label!
                        objbeach.tab = receivedTabsArray
                        objbeach.screenType = screenDataType
                        objbeach.selectedMenu = menuObj
                        objbeach.department = receivedTabsArray.first?.departments
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(objbeach, animated: true)
                        })
                    }else{
                        let objCustomTable : CustomTableVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.CustomTable) as! CustomTableVC
                        objCustomTable.titleBarText = self.selectedMenu.label!
                        objCustomTable.tableCellType = .countCell
                        objCustomTable.screenType = screenDataType
                        if let arr = receivedTabsArray.first?.departments {
                            for depObj in arr{
                                if let menus = depObj.items{
                                    if menus.count > 0{
                                        depObj.items = menus
                                    }
                                }
                            }
                            objCustomTable.department = arr
                        }
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                        })
                    }
                }
            })
    }
    
    private func getDeptMenu(menuObj : Menu, screenDataType : SubMenuDataType, screenCellType:CellType){
        
        self.getTabsDepartmentMenuItems(departmentId: menuObj.department_Id!, {(status, message, tabsArray) in
            
            if status{
                if let receivedTabsArray = tabsArray{
                    if receivedTabsArray.count > 1{
                        let objbeach : BeachPoolTabVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.BeachPoolTabVC) as! BeachPoolTabVC
                        objbeach.titleBarText = menuObj.label!
                        objbeach.selectedMenu = menuObj
                        objbeach.tab = receivedTabsArray
                        objbeach.screenType = screenDataType
                        objbeach.department = receivedTabsArray.first?.departments
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(objbeach, animated: true)
                        })
                    }else{
                        let objCustomTable : CustomTableVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.CustomTable) as! CustomTableVC
                        objCustomTable.selectedMenu = menuObj
                        objCustomTable.tableCellType = screenCellType
                        objCustomTable.titleBarText = menuObj.label!
                        objCustomTable.screenType = screenDataType
                        objCustomTable.selectedMenu = menuObj
                        if let arr = receivedTabsArray[0].departments {
                            for depObj in arr{
                                if let menus = depObj.items{
                                    if menus.count > 0{
                                        for menu in menus{
                                            menu.module_id = menuObj.department_Id!
                                        }
                                        depObj.items = menus
                                    }
                                }
                            }
                            objCustomTable.department = arr
                        }
                        DispatchQueue.main.async(execute: {
                            if let controller = self.viewController as? BaseViewController {
                                controller.deactivateView(controller.view)
                            }
                            self.viewController.navigationController?.pushViewController(objCustomTable, animated: true)
                        })
                    }
                }
            }else{
                
            }
        })
    }
    private func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            objAlert.delegate = self
            self.viewController.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.viewController.present(objAlert, animated: false) {
            }
        })
    }
    
}
extension ScreenController: CustomAlertViewDelegate, ExtraAmenitiesDelegate, QuantityPickerDelegate, AlertVCDelegate, SelectChairVCDelegate {
    func fillRoom(alohaOrderModel: AlohaOrder, reservationModel: ReservationModel, controller: UIViewController) {
        
    }
    
    
    
    private func showCustomAlertWith(menu : Menu) {
        let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CustomAlertView) as! CustomAlertView
        objAlert.delegate = self
        self.viewController.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.set(imageURL :menu.imageURL, message: menu.label)
        self.viewController.present(objAlert, animated: false) {
        }
    }
    private func showCustomAlertWith(title : String?, message : String?, image : UIImage?) {
        let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CustomAlertView) as! CustomAlertView
        objAlert.delegate = self
        self.viewController.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.lbl_title.text = title
        objAlert.lbl_message.text = message
        objAlert.img_icon.image = image
        self.viewController.present(objAlert, animated: false) {
        }
    }
    
    
    private func showCustomAlertWith(imageUrl : URL?, message : String?) {
        let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CustomAlertView) as! CustomAlertView
        objAlert.delegate = self
        
        self.viewController.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.set(imageURL :imageUrl , message: message)
        self.viewController.present(objAlert, animated: false) {
        }
    }
    private func housekeepingSelectedQuantity(quantity: Int) {
        selectedMenu.quantity = quantity
        let model = ReservationModel()
        
        self.showRoomDialog(model: model)

        
//        submitRequest()
    }
    func showContactDialog() {
        if let msg = self.selectedMenu.label {
            let message = String(format:ALERTSTRING.contactus,msg)
            self.showCustomAlertWith(title: self.selectedMenu.label, message: message, image: #imageLiteral(resourceName: "check_img_green"))
        }
    }
    private func showRoomDialog(model : ReservationModel){
        if let room_number = Helper.getRoomNumber(), room_number != "" {
            selectedMenu.room_number = room_number
            self.roomNumber = room_number
//            self.submitRequest()
            if self.selectedMenu.itemType == .local_attraction {
                self.showContactDialog()
//                var reservation = model
//                reservation.room_number = room_number
//                self.localAttractionRequest(model: reservation)
            }
            else {
                self.submitRequest()
            }
        }
        else {
            let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SelectChairVC") as! SelectChairVC
            objUpgrade.delegate = self
            objUpgrade.showRoom = true
            objUpgrade.reservationModel =  model
            objUpgrade.alreadyReserved = alreadyReserved
            objUpgrade.alertText = ALERTSTRING.ROOM_NUMBER
            viewController.definesPresentationContext = true
            objUpgrade.modalPresentationStyle = .overCurrentContext
            objUpgrade.modalTransitionStyle = .crossDissolve
            objUpgrade.view.backgroundColor = .clear
            DispatchQueue.main.async(execute: {
                self.viewController.navigationController?.present(objUpgrade, animated: true, completion: nil)
            })
        }
        
    }
    func showAlohaOrderWith(order : AlohaOrder, menu : Menu) {
        let objPreviewVC : AlohaOrderPreview = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.AlohaOrderPreview) as! AlohaOrderPreview
        objPreviewVC.order = order
        objPreviewVC.screenType = selectedMenu.subMenuDataType
        objPreviewVC.orderCompleted = true
        objPreviewVC.titleBarText = menu.label!
        objPreviewVC.selectedMenu = menu
        DispatchQueue.main.async(execute: {
            if let controller = self.viewController as? BaseViewController {
                controller.deactivateView(controller.view)
            }
            self.viewController.navigationController?.pushViewController(objPreviewVC, animated: true)
        })
    }
    
    //MARK:CustomAlertDelegate
    internal func alertDismissed(){
    }
    
    internal func showExtraAmenities(items : [String]) {
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ExtraAmenitiesVC) as! ExtraAmenitiesVC
        objUpgrade.navController = self.viewController.navigationController

        if let items = selectedMenu.items_attributes?.extra_amenities {
            var amenities : [Amenities] = []
            for item in items {
                if let amenity = Amenities.init(nameStr: item) {
                    amenities.append(amenity)
                }
            }
            objUpgrade.items = amenities
        }
        objUpgrade.delegate = self
        self.viewController.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            self.viewController.navigationController?.present(objUpgrade, animated: true, completion: nil)
        })
    }
    
    private func showQuantitySelection() {
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.QuantityPickerVC) as! QuantityPickerVC
        objUpgrade.delegate = self
        self.viewController.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        objUpgrade.selectedQuantity = 1
        DispatchQueue.main.async(execute: {
            self.viewController.navigationController?.present(objUpgrade, animated: true, completion: nil)
        })
    }
    
    internal func yesAction(){
        if self.selectedMenu.itemType == .contact {
//            let model = ReservationModel()
//            self.showRoomDialog(model: model)
            bookStay()
        }
        else if self.selectedMenu.itemType == .local_attraction {
//            let model = ReservationModel()
//
//            self.showRoomDialog(model: model)
            let reservation = ReservationModel()
            reservation.items = [selectedMenu]
            reservation.room_number = self.roomNumber
            self.localAttractionRequest(model: reservation)
        }
        else if let extra_amenities = selectedMenu.items_attributes?.extra_amenities {
            showExtraAmenities(items: extra_amenities)
        }
        else if let quantity = selectedMenu.items_attributes?.quantity, quantity == true{
            showQuantitySelection()
        }
        else{
            let model = ReservationModel()
            showRoomDialog(model: model)
//            submitRequest()
        }
    }
    
    internal func noAction(){
        if self.selectedMenu.itemType == .local_attraction {
            showWebsite()
        }
    }
    private func bookStay() {
        DispatchQueue.main.async(execute: { () -> Void in
            if let controller = self.viewController as? BaseViewController {
                controller.activateView(controller.view, loaderText: LOADER_TEXT.loading)
            }
        })
        // book my stay contact us
        let obj = BusinessLayer()
        
        obj.contactus(menu: selectedMenu, { (status, title, message) in
            DispatchQueue.main.async(execute: { () -> Void in
                if let controller = self.viewController as? BaseViewController {
                    controller.deactivateView(controller.view)
                }
            })
            if status {
                self.showConfirmationDialog(title: title, message: message)
            }
            else{
                Helper.showAlert(sender: self.viewController, title: ALERTSTRING.ERROR, message: message)
            }
        })

    }
    private func localAttractionRequest(model : ReservationModel) {
        DispatchQueue.main.async(execute: { () -> Void in
            if let controller = self.viewController as? BaseViewController {
                controller.activateView(controller.view, loaderText: LOADER_TEXT.loading)
            }
        })
        let bizObj = BusinessLayer()
        bizObj.localAttractionRequest(reservation: model, { (status, title, message) in
            DispatchQueue.main.async(execute: { () -> Void in
                if let controller = self.viewController as? BaseViewController {
                    controller.deactivateView(controller.view)
                }
            })
            if status{
                self.showConfirmationDialog(title : title, message : message)
            }
            else{
                Helper.showAlert(sender: self.viewController, title: title, message: message)
            }
        })
    }
    //    MARK: SelectChairDelegates
    func selectedRoom(model : ReservationModel,controller : UIViewController) {
        controller.dismiss(animated: true, completion: {
            
            if let room_number = model.room_number {
                self.roomNumber = room_number
                self.selectedMenu.room_number = room_number
            }
            if self.selectedMenu.subMenuDataType == .maintenance_request {
                self.showMaintenanceRequest(room_number : model.room_number)
            }
            else if self.selectedMenu.itemType == .local_attraction {
                self.showContactDialog()
//                self.localAttractionRequest(model: model)
            }
            else if self.selectedMenu.itemType == .contact {
                self.bookStay()
            }
            else {
                self.submitRequest()
            }
            
        })
    }
    func selectedQuantity(quantity: Int) {
      //nothing
    }
    
    internal func submitRequest() {
        DispatchQueue.main.async(execute: { () -> Void in
            if let controller = self.viewController as? BaseViewController {
                controller.activateView(controller.view, loaderText: LOADER_TEXT.loading)
            }
            
        })
        let bizObject = BusinessLayer()
        bizObject.serviceRequest(menuObj: selectedMenu, { (status,title, response) in
            DispatchQueue.main.async(execute: { () -> Void in
                if let controller = self.viewController as? BaseViewController {
                    controller.deactivateView(controller.view)
                }
                if status {
                    if (title?.characters.count)! <= 0{
                        self.showConfirmationDialog(title: ALERTSTRING.THANKS, message: response!)
                    }else{
                        self.showConfirmationDialog(title: title!, message: response!)
                    }
                }else{
                    if (title?.characters.count)! <= 0{
                        Helper.showAlert(sender: self.viewController, title: ALERTSTRING.TITLE, message: response!)
                    }else{
                        Helper.showAlert(sender: self.viewController, title: title!, message: response!)
                    }
                }
            })
        })
    }
    internal func selectedChair(model: ReservationModel, controller: UIViewController) {
        // nothing here
    }
    
    //    MARK: ExtraAmenitiesDelegate
    func selectedAmenitiesItems(items: [Amenities]) {
        selectedMenu.serviceSelectedItemsArray = items
        let model = ReservationModel()
        self.showRoomDialog(model: model)
    }
    //    MARK:Quantity Picker Delegate
    internal func selectedPickerQuantity(quantity : Int) {
        self.housekeepingSelectedQuantity(quantity: quantity)
    }
    internal func selectedAmenityQuantity(amenity: Amenities) {
    //
    }
}

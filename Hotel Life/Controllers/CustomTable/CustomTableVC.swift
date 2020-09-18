//
//  CustomTable.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 18/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
@objc protocol CustomTableVCDelegate {
    @objc optional func orderUpdated()
    @objc optional func showDescriptionDialog(menu : Menu)
}
class CustomTableVC: BaseViewController {
    
    weak var delegate : CustomTableVCDelegate?
    @IBOutlet weak var reserveBtn: UIButton!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_totalDescription: UILabel!
    @IBOutlet weak var tbl_list: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    var tableCellType : CellType = .countCell
    var titleBarText: String = ""
    var menuArray : [Menu] = []
    var department : [Department]?
    var selectedArray : [Menu] = []
    var orderTotal : Float = 0
    var selectedMenu : Menu?
    var alreadyReserved = false
    var screenType : SubMenuDataType = .reservation
    var suffix = ""
    var reservationModel : ReservationModel?
    var descriptionText : String = ""
    var hideBottomView = false
    var coupleName : String?
    var navController : UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Items listing screen", className: "CustomTableVC")
        

        tbl_list.separatorColor = .clear
        if hideBottomView {
            hideViews()
            
        }
        // Do any additional setup after loading the view.
        lbl_totalDescription.text = TITLE.Total

        switch screenType {
        case .quantity_selection, .tabs_quantity_selection:

//            if selectedMenu?.items_attributes?.price_suffix == ""{
//                lbl_totalDescription.text = TITLE.Total
//            }else{
//                lbl_totalDescription.text = selectedMenu?.items_attributes?.price_suffix
//            }
            if alreadyReserved{
                reserveBtn.setTitle(TITLE.Modify, for: .normal)
            }else{
                reserveBtn.setTitle(TITLE.Order, for: .normal)
            }
        case .service_selection:
//            lbl_totalDescription.text = TITLE.Total

            if alreadyReserved{
                reserveBtn.setTitle(TITLE.Modify, for: .normal)
            }else{
                reserveBtn.setTitle(TITLE.Proceed, for: .normal)
            }
        default:
//            lbl_totalDescription.text = TITLE.Total
            if alreadyReserved{
                reserveBtn.setTitle(TITLE.Modify, for: .normal)
            }else{
                reserveBtn.setTitle(TITLE.Proceed, for: .normal)
            }
        }
        
        getTotalAmount()
    }
    func hideViews() {
        self.bottomView.isHidden = true
//        lbl_total.isHidden = true
//        lbl_totalDescription.isHidden = true
//        reserveBtn.isHidden = true
        
    }
    func unhideViews() {
        self.bottomView.isHidden = false
//        lbl_total.isHidden = false
//        lbl_totalDescription.isHidden = false
//        reserveBtn.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText.replacingOccurrences(of: "\n", with: " ")
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
        if screenType == .service_selection {
            if let text = self.selectedMenu?.labelDescription {
                self.descriptionText = text
                let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                infoView.backgroundColor = .clear
                let infoIcon = UIImageView(frame: CGRect(x: 7, y: 7, width: 21, height: 21))
                infoIcon.image = #imageLiteral(resourceName: "img_info")
                infoIcon.contentMode = .scaleToFill
                infoView.addSubview(infoIcon)
                let btn_info = UIButton(frame: infoView.frame)
                btn_info.backgroundColor = .clear
                btn_info.addTarget(self, action: #selector(infoAction(_:)), for: .touchUpInside)
                infoView.addSubview(btn_info)
                let bar_btn = UIBarButtonItem(customView: infoView)
                self.navigationItem.rightBarButtonItem = bar_btn
            }
        }
        
        if delegate != nil {
            hideViews()
        }
        else{
            unhideViews()
            
        }
//        if let couple_name = reservationModel?.couple_name {
//            self.selectedMenu?.couple_name = couple_name
//        }
    }
    
    func getTotalAmount() {
        if tableCellType == .checkboxCell {
            orderTotal = Helper.getCheckedTotal(menuArray: selectedArray)
            lbl_total.text = "$\(String.init(format: "%.2f", Float(orderTotal)))"
        }
        else{
            orderTotal = Helper.getQuantityTotal(menuArray: selectedArray)
            lbl_total.text = "$\(String.init(format: "%.2f", Float(orderTotal)))"
        }
        
        delegate?.orderUpdated!()
    }
    func getAlohaTotalAmount() {
        if tableCellType == .checkboxCell {
            orderTotal = Helper.getAlohaQuantityTotal(menuArray: selectedArray)
            lbl_total.text = "$\(String.init(format: "%.2f", Float(orderTotal)))"
        }
        else{
            orderTotal = Helper.getAlohaQuantityTotal(menuArray: selectedArray)
            lbl_total.text = "$\(String.init(format: "%.2f", Float(orderTotal)))"
        }
        
        delegate?.orderUpdated!()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func infoAction(_ sender : UIButton) {
        let controller : RestaurantMenuVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.RestaurantMenuVC) as! RestaurantMenuVC
//        let menu = self.items[indexPath.row]
            controller.htmlText = self.descriptionText
//        if let name = menu.label {
            controller.titleBarText = self.titleBarText
//        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @objc func backAction(_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    func checkForCouple() {
        if screenType == .service_selection {
            for item in selectedArray {
                if item.is_couple {
                    self.showCoupleDialog()
                    return
                }
            }
        }
    }
    
    @objc func showDateTimeView() {
        let objDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
        objDateTime.titleBarText = titleBarText
        objDateTime.alreadyReserved = self.alreadyReserved
        objDateTime.promocode = self.reservationModel?.promocode
        objDateTime.screenType = self.screenType
        if tableCellType == .countCell{
            objDateTime.tableCellType = .countCell
            if let menu = selectedMenu {
                objDateTime.selectedMenu = menu
            }
            objDateTime.selectedArray = selectedArray
        }else{
            objDateTime.tableCellType = .checkboxCell
            for menu in selectedArray {
                menu.quantity = 1
            }
            if let menu = selectedMenu {
                objDateTime.selectedMenu = menu
            }
            objDateTime.selectedArray = selectedArray
            
            if let time = selectedMenu?.items_attributes?.default_time {
                let calendar = Calendar.current
                var dateComponent = DateComponents()
                dateComponent.hour = Int(time)
                if let date = calendar.date(from: dateComponent) {
                    let dateString = Helper.getStringFromDate(format: DATEFORMATTER.HA, date: date)
                    objDateTime.defaultTime = dateString
                }
            }
            objDateTime.showTimeView = true
        }
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objDateTime, animated: true)
        })
        
    }
    
    @IBAction func reserveAction(_ sender: UIButton) {
        checkForCouple()
        if orderTotal > 0{
            showDateTimeView()
        }else{
            Helper.showAlert(sender: self, title: TITLE.Required, message: ALERTSTRING.SELECT_AN_ITEM)
        }
    }

    func showCoupleDialog() {
        let coupleDialog = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CoupleDialog) as! CoupleDialog
        coupleDialog.delegate = self
        self.definesPresentationContext = true
        coupleDialog.modalPresentationStyle = .overCurrentContext
        coupleDialog.modalTransitionStyle = .crossDissolve
        coupleDialog.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            self.present(coupleDialog, animated: true, completion: {
            })
        })
    }
}
extension CustomTableVC : UITableViewDelegate, UITableViewDataSource, CustomTableCellDelegate, AlertVCDelegate, CoupleDelegate {
    
    
    //    MARK: Tableview delegates and datasource
    public func numberOfSections(in tableView: UITableView) -> Int{
        if let dept = department{
            return dept.count
        }else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if let dept = department{
            if let name = dept[section].name{
                if name.characters.count > 0 {
                    if let menus = dept[section].items?.count, menus > 1 {
                        return 40
                    }
                }
                return 0
            }
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dept = department{
            return dept[section].items!.count
        }else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.HEADER_CELL) as! CustomTableCell
        if let name = department![section].name{
            cell.lbl_headerTitle.text = name
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CustomTableCell()
        let menu = department![indexPath.section].items![indexPath.row]
        if tableCellType == .countCell {
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CUSTOM_TABLE_CELL) as! CustomTableCell
            cell.configureCell(menuObj: menu,type : tableCellType)
            if let id = menu.posItemId{
                if let item_id = menu.item_id {
                    cell.lbl_count.text = "\(self.getMenuQuantity(posItemId: id, item_id: item_id))"
                }
                else {
                   cell.lbl_count.text = "0"
                }
            }
            else {
                if let quantity = menu.quantity {
                    cell.lbl_count.text = "\(quantity)"
                }
                else {
                    cell.lbl_count.text = "0"
                }
            }
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CUSTOM_TABLE_CHECK_CELL) as! CustomTableCell
//            cell.selectionType = .single
            cell.selectionType = .multiple
            cell.configureCell(menuObj: menu,type : tableCellType)

        }
//        if let suffix = selectedMenu?.items_attributes?.price_suffix {
//            cell.configureCell(menuObj: department![indexPath.section].items![indexPath.row] ,type : tableCellType, suffix : suffix )
//        }else{
//            cell.configureCell(menuObj: department![indexPath.section].items![indexPath.row]  ,type : tableCellType, suffix : suffix )
//        }
        
        
        
        //cell.infoIcon.image = nil
        cell.infoIcon.isHidden = true
        cell.infoIcon.backgroundColor = .clear
        if let labelDescription = department![indexPath.section].items![indexPath.row].labelDescription{
            if labelDescription.characters.count > 0{
                cell.infoIcon.image = #imageLiteral(resourceName: "img_info")
                cell.infoIcon.backgroundColor = COLORS.LIGHTGREY_COLOR_WITH_ALPHA
                cell.descriptionBtn.isUserInteractionEnabled = true
                cell.infoIcon.isHidden = false
            }
            else {
                cell.descriptionBtn.isUserInteractionEnabled = false
                cell.infoIcon.isHidden = true
            }
           
        }
        else{
            cell.infoIcon.isHidden = true
            cell.descriptionBtn.isUserInteractionEnabled = false
        }
        cell.delegate = self
        return cell
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableCellType == .checkboxCell {
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableCell
            cell.checkBtnAction(cell.btn_check)
        }
        else if tableCellType == .countCell {

        }
    }
    
    func alertDismissed(){
        
    }
    
    //    MARK: CustomTableCellDelegate
    func updateSelectedMenuItem(menu : Menu, modifierArray : [Modifier]?) {
        
        if let item = selectedMenu?.items_attributes{
            if item.quantity{
                var section = 0
                for deptObj in department!{
                    if (deptObj.items?.contains(menu))! {
                        if let index = deptObj.items?.index(of: menu) {
                            if let quantity = deptObj.items?[index].quantity{
                                // check max quantity if needed
                                if quantity < menu.available_quantity!{
                                    deptObj.items?[index].quantity = quantity + 1
//                                    if let modiArray = modifierArray {
//                                        deptObj.items?[index].selectedModifierArray.append(modiArray)
//                                    }

                                    updateSelectedArray(oldMenu: menu, newMenu: (deptObj.items?[index])!)
                                    let indexPath = IndexPath.init(row: index, section: section)
                                    self.tbl_list.reloadRows(at: [indexPath], with: .none)
                                }else{
                                    Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: ALERTSTRING.REACHED_MAXIMUM_LIMIT)
                                }
                            }
                        }
                    }
                    section = section + 1
                }
            }else{
                var section = 0
                for deptObj in department!{
                    if (deptObj.items?.contains(menu))! {
                        if let index = deptObj.items?.index(of: menu) {
                            if let quantity = deptObj.items?[index].quantity{
                                deptObj.items?[index].quantity = quantity + 1
//                                if let modiArray = modifierArray {
//                                    deptObj.items?[index].selectedModifierArray.append(modiArray)
//                                }
                                updateSelectedArray(oldMenu: menu, newMenu: (deptObj.items?[index])!)
                                let indexPath = IndexPath.init(row: index, section: section)
                                self.tbl_list.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                    section = section + 1
                }
            }
        }else{
            var section = 0
            for deptObj in department!{
                if (deptObj.items?.contains(menu))! {
                    if let index = deptObj.items?.index(of: menu) {
//                        if let quantity = deptObj.items?[index].quantity{
//                            deptObj.items?[index].quantity = quantity + 1
//                            if let modiArray = modifierArray {
//                                deptObj.items?[index].selectedModifierArray.append(modiArray)
//                            }
                           if let item = deptObj.items?[index].copy() as? Menu {
                                if let modiArray = modifierArray {
                                    item.selectedModifierArray = modiArray
                                }
                                addMenu(menu: item)
//                                    if menu.selectedModifierArray == modiArray {
//                                        if let quantity = item.quantity {
//                                            updateMenu(menu: item, quantity: quantity + 1)
//                                        }
//                                    }
//                                    else {
//                                        item.selectedModifierArray = modiArray
//                                        addMenu(menu: item)
//                                    }
                            }
                            let indexPath = IndexPath.init(row: index, section: section)
                            self.tbl_list.reloadRows(at: [indexPath], with: .none)
//                        }
                    }
                }
                section = section + 1
            }
        }
        
    }
    func increaseCountFor(menu: Menu) {
        if let modifierGroup = menu.modifierGroup, modifierGroup.count > 0 {
            if self.navController != nil {
                let controller = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ItemDescriptionVC) as! ItemDescriptionVC
                controller.item = menu
                controller.titleBarText = menu.label!
                controller.delegate = self
                self.navController?.pushViewController(controller, animated: true)
            }
        }
        else {
            self.updateSelectedMenuItem(menu: menu, modifierArray: nil)
        }
    }
    
    func decreaseCountFor(menu: Menu) {
        var section = 0
        for deptObj in department!{
            if (deptObj.items?.contains(menu))! {
                if let index = deptObj.items?.index(of: menu) {
                    if let item = deptObj.items?[index] {
                        if let posId = item.posItemId{
                            removeMenu(posItemId: posId)
                        }
                        else {
                            if let quantity = item.quantity, quantity > 0{
                                    deptObj.items?[index].quantity = quantity - 1
                            }
                            updateSelectedArray(oldMenu: menu, newMenu: (deptObj.items?[index])!)
                        }
                        let indexPath = IndexPath.init(row: index, section: section)
                        self.tbl_list.reloadRows(at: [indexPath], with: .none)
                        
                    }
                    
                }
            }
            section = section + 1
        }
        
    }
    
    func checkCell(menu: Menu) {
        
        for deptObj in department!{
            if (deptObj.items?.contains(menu))! {
                if let index = deptObj.items?.index(of: menu) {
                    if deptObj.items?[index].isChecked == false{
                        deptObj.items?[index].isChecked = true
                        if !selectedArray.contains(menu) {
                            self.selectedArray.append(menu)
                        }
                        
                    }
                }
            }
        }
        getTotalAmount()

    }
    func unCheckCell(menu: Menu) {
        for deptObj in department!{
        if (deptObj.items?.contains(menu))! {
            if let index = deptObj.items?.index(of: menu) {
                if deptObj.items?[index].isChecked == true{
                    deptObj.items?[index].isChecked = false
                    if selectedArray.contains(menu) {
                        selectedArray.remove(at: selectedArray.index(of: menu)!)
                    }
                }
            }
         }
        }
        getTotalAmount()
        
    }
    func selectedCell(menu: Menu) {
        if selectedArray.contains(menu) {
            // nothing to do if menu is already in selected cell
        }
        else{
            var section = 0
            for deptObj in department!{
            for item in selectedArray{
                if (deptObj.items?.contains(item))! {
                    if let index = deptObj.items?.index(of: item) {
                        if deptObj.items?[index].isChecked == true{
                            deptObj.items?[index].isChecked = false
                            let indexPath = IndexPath(row: index, section: section)
                            tbl_list.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
                section = section + 1
            }
            menu.isChecked = true
            selectedArray.removeAll()
            selectedArray.append(menu)
        }
        getTotalAmount()
        
    }
    
    func descriptionTapped(menu: Menu) {
        if let labelDescription = menu.labelDescription{
            if labelDescription.characters.count > 0{
                if self.delegate != nil {
                   self.delegate?.showDescriptionDialog!(menu : menu)
                }
                else{
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
            }
        }
    }
    
    func updateSelectedArray(oldMenu : Menu, newMenu : Menu) {
        if let quantity = newMenu.quantity {
            if quantity > 0 {
                if selectedArray.contains(oldMenu) {
                    if let index = selectedArray.index(of: oldMenu) {
                        selectedArray.remove(at: index)
                    }
                }
                selectedArray.append(newMenu)
            }
            else{
                if selectedArray.contains(oldMenu) {
                    if let index = selectedArray.index(of: oldMenu) {
                        selectedArray.remove(at: index)
                    }
                }
            }
        }
        else{
            print("No Quantity")
        }
        getTotalAmount()
    }
    func removeMenu(posItemId : String) {
        var removeMenus : [Menu] = []
        for item in selectedArray.reversed() {
            if item.posItemId == posItemId {
                if let count = item.modifierGroup?.count, count <= 0 {
                    if let index = selectedArray.index(of: item) {
                        selectedArray.remove(at: index)
                        getAlohaTotalAmount()
                        return
                    }
                }
                removeMenus.append(item)
            }
        }
        if removeMenus.count <= 1 {
            selectedArray.removeAll()
        }
            
        else {
            
            self.showRemoveDialog(arr: removeMenus, posId: posItemId)
        }
        getAlohaTotalAmount()
    }
    func removeItemsWith(posId : String, add : [Menu]) {
        for item in selectedArray.reversed() {
            if item.posItemId == posId {
                if let index = selectedArray.index(of: item) {
                    selectedArray.remove(at: index)
                }
            }
        }
        for item in add {
            selectedArray.append(item)
        }
        getAlohaTotalAmount()
        self.tbl_list.reloadData()
    }
    func addMenu(menu : Menu) {
        let item = menu
        selectedArray.append(item)
        getAlohaTotalAmount()
    }
    
    func getMenuQuantity(posItemId : String, item_id : String) -> Int{
        var count = 0
        for item in selectedArray {
            if item.posItemId == posItemId && item.item_id == item_id {
                count = count + 1
            }
        }
        return count
    }
    func showRemoveDialog(arr : [Menu], posId : String) {
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.RemoveMenuVC) as! RemoveMenuVC
        objUpgrade.selectedItems = arr
        objUpgrade.posId = posId
        objUpgrade.delegate = self
        self.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
         self.navController?.present(objUpgrade, animated: true, completion: nil)
        })
    }
//    func updateMenu(menu : Menu, quantity : Int) {
//        if selectedArray.contains(menu) {
//            if let index = selectedArray.index(of: menu) {
//                if let quantity = selectedArray[index].quantity {
//                selectedArray[index].quantity = quantity + 1
//                }
//            }
//        }
//    }
    
    //    MARK: PreviewDelegate
    func reservationCompletedWith(status : Bool, model: ReservationModel?, alertTitle : String, alertMessage: String) {
        
        if status {
            self.reservationModel = model
            if !(self.reservationModel?.subMenuDataType == .def){
                screenType = (model?.subMenuDataType)!
            }
            self.reservationModel?.alertTitle = alertTitle
            self.reservationModel?.alertMessage = alertMessage
            self.showConfirmation()
        }
        else{
            Helper.showAlert(sender: self, title: alertTitle, message: alertMessage)
        }
    }
    func showConfirmation(){
        let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
        if let name = self.reservationModel?.module_name{
            titleBarText = name
        }
        controller.titleBarText = titleBarText
        controller.reservation = reservationModel
        controller.screenType = self.screenType
        controller.showDate = false
//        controller.showModify = true
        controller.selectedMenu = self.selectedMenu
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
//    MARK: CoupleDelegate
    func enteredCoupleName(name: String) {
        self.selectedMenu?.couple_name = name
        self.perform(#selector(showDateTimeView), with: nil, afterDelay: 1.0)
//        showDateTimeView()
    }
}

extension CustomTableVC : ItemDescriptionDelegate {
    func cancelModification() {
        
    }
    func proceedWith(menu: Menu, items: [Modifier]) {
        updateSelectedMenuItem(menu: menu, modifierArray: items)
    }
}
extension CustomTableVC : RemoveVCDelegate {
    func afterRemoving(items: [Menu], posId: String, controller: RemoveMenuVC) {
        self.removeItemsWith(posId: posId, add: items)
        controller.dismiss(animated: true, completion: nil)
    }
    
}

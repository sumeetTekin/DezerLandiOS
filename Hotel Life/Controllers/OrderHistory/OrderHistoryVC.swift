//
//  OrderHistoryVC.swift
//  Resort Life
//
//  Created by Adil Mir on 1/29/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit
enum ScreenType:Int{
    case orderHistory = 0,upcommingOrders
}

class OrderHistoryVC: BaseViewController,SelectedScreen , UIPickerViewDelegate{
   
    
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    
    var sortedOrders = [[OrderListing]]()
    var dateArray = [String]()
    var newDates = [String]()
    
    var sortedOrdersFilter = [[OrderListing]]()
    var newDatesFilter = [String]()
    var isFilter : Bool = false
    
    var navController : UINavigationController?
    var orders:[OrderListing]?
    var imagePath:String!
    var screenType = 0
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        if let userId = Helper.ReadUserObject()?.userId{
            getOrderHistory(userID: userId)
        }
        getOrderHistory(userID: "")
    }
    
    override func viewWillAppear(_ animated: Bool){ self.navigationController?.navigationBar.isHidden = false
    self.navigationItem.title = "Order History"
        tableView.separatorColor = UIColor.clear
    let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
    self.navigationItem.leftBarButtonItem = btn_back
        
        let btn_filter = UIBarButtonItem.init(image: UIImage.init(named: "ic_filters"), style: .plain, target: self, action: #selector(filterAction(_:)))
        self.navigationItem.rightBarButtonItem = btn_filter
    
    //        selectedArray.removeAll()
}

@objc func backAction (_ sender : UIButton) {
    DispatchQueue.main.async(execute: {
        _ = self.navigationController?.popViewController(animated: true)
    })
}
    
    @objc func filterAction (_ sender : UIButton) {
        
        
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped)), UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(onCancelButtonTapped))]
        self.view.addSubview(toolBar)
        
        
        
        DispatchQueue.main.async(execute: {
           
        })
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        isFilter = true
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        isFilter = false
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.newDates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return newDates[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        isFilter = true
        
        print(self.newDates[row])
        let dateStr = self.newDates[row]
        self.newDatesFilter.removeAll()
        self.newDatesFilter.append(dateStr)
        self.sortedOrdersFilter = self.getAllOders(sortedDates: self.newDatesFilter)
        
        
    }
    
    func getOrderHistory(userID:String){
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        let bizz = BusinessLayer()
        bizz.getOrderHistory(userId: userID, params: [:]) { (success, response, message) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                
                
                if success{
                    if let allOrders = response?.data?.result{
                        
                        
                        self.orders = allOrders
                        let sortedDates = self.setDate()
                        self.newDates = self.sortDate(dates: sortedDates)
                        self.sortedOrders = self.getAllOders(sortedDates: self.newDates)
                        if let imagePth = response?.imagesPath{
                            self.imagePath = imagePth
                        }
                        self.tableView.reloadData()
                        
                    }
                } else {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            })
            
        }
        
    }
    
  
}



extension OrderHistoryVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFilter == false{
            return sortedOrders.count
        }else{
            return sortedOrdersFilter.count
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter == false{
            return sortedOrders[section].count
        }else{
            return sortedOrdersFilter[section].count
        }
        
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.HEADER_CELL) as! CustomTableCell
        
        if isFilter == false{
            
            
            if screenType == ScreenType.orderHistory.rawValue{
                
                cell.lbl_title.text = sortedOrders[indexPath.section][indexPath.row].department_id?.name?.en
                if let date = sortedOrders[indexPath.section][indexPath.row].created_date{
                    cell.lbl_subTitle.text = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Helper.getDateFromString(string: date, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ))
                }
                if let confirmationNumber = sortedOrders[indexPath.section][indexPath.row].booking_number{
                    cell.lbl_headerTitle.text = "#" + confirmationNumber
                }
                
                if let imageUrl = sortedOrders[indexPath.section][indexPath.row].department_id?.image{
                    let url = URL(string: imageUrl)
                    cell.img_cellImage.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
                }
                //cell.lbl_action.text = sortedOrders[indexPath.section][indexPath.row].action_performed?.last?.action
                cell.lbl_action.text = sortedOrders[indexPath.section][indexPath.row].status
                if cell.lbl_action.text == nil{
                    cell.heightActionLabel.constant = 0
                }else{
                    cell.heightActionLabel.constant = 15
                }
                
                if let ratingValue = sortedOrders[indexPath.section][indexPath.row].rating?.value{
                    cell.floatingRatingView.rating = Double(ratingValue) ?? 0
                    cell.floatingRatingView.isHidden = false
                    cell.btnRate.isHidden = true
                }else{
                    cell.floatingRatingView.isHidden = true
                    cell.btnRate.isHidden = true
                }
                
                
                cell.buttonAction = { sender in
                    
                    let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
                    objUpgrade.delegate = self
                    objUpgrade.orderId =  self.sortedOrders[indexPath.section][indexPath.row]._id
                    objUpgrade.modalPresentationStyle = .overCurrentContext
                    objUpgrade.modalTransitionStyle = .crossDissolve
                    objUpgrade.view.backgroundColor = .clear
                    DispatchQueue.main.async(execute: {
                        self.navigationController?.present(objUpgrade, animated: true, completion: nil)
                    })
                    
                }
                
            }
            
            
            
        }else{
            
            
            if screenType == ScreenType.orderHistory.rawValue{
                
                cell.lbl_title.text = sortedOrdersFilter[indexPath.section][indexPath.row].department_id?.name?.en
                if let date = sortedOrdersFilter[indexPath.section][indexPath.row].created_date{
                    cell.lbl_subTitle.text = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Helper.getDateFromString(string: date, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ))
                }
                if let confirmationNumber = sortedOrdersFilter[indexPath.section][indexPath.row].booking_number{
                    cell.lbl_headerTitle.text = "#" + confirmationNumber
                }
                
                if let imageUrl = sortedOrdersFilter[indexPath.section][indexPath.row].department_id?.image{
                    if imagePath != nil{
                        let url = URL(string: imageUrl)
                        cell.img_cellImage.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
                    }
                    
                }
                //cell.lbl_action.text = sortedOrdersFilter[indexPath.section][indexPath.row].action_performed?.last?.action
                cell.lbl_action.text = sortedOrders[indexPath.section][indexPath.row].status
                if cell.lbl_action.text == nil{
                    cell.heightActionLabel.constant = 0
                }else{
                    cell.heightActionLabel.constant = 15
                }
                if let ratingValue = sortedOrdersFilter[indexPath.section][indexPath.row].rating?.value{
                    cell.floatingRatingView.rating = Double(ratingValue) ?? 0
                    cell.floatingRatingView.isHidden = false
                    cell.btnRate.isHidden = true
                }else{
                    cell.floatingRatingView.isHidden = true
                    cell.btnRate.isHidden = true
                }
                
                cell.buttonAction = { sender in
                    
                    let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
                    objUpgrade.delegate = self
                    objUpgrade.orderId =  self.sortedOrdersFilter[indexPath.section][indexPath.row]._id
                    objUpgrade.modalPresentationStyle = .overCurrentContext
                    objUpgrade.modalTransitionStyle = .crossDissolve
                    objUpgrade.view.backgroundColor = .clear
                    DispatchQueue.main.async(execute: {
                        self.navigationController?.present(objUpgrade, animated: true, completion: nil)
                    })
                    
                }
                
                
                //cell.btnRate.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                //cell.btnRate.tag = indexPath.row
            }
            
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let controller = Helper.getOrderHidtoryStoryboard().instantiateViewController(withIdentifier: "OrderHistoryDetailVC") as! OrderHistoryDetailVC
        if isFilter == false{
            controller.orderId = sortedOrders[indexPath.section][indexPath.row]._id
            controller.titleBarText = sortedOrders[indexPath.section][indexPath.row].department_id?.name?.en
            if sortedOrders[indexPath.section][indexPath.row].department_id?.department_type == DEPARTMENTTYPE.QUANTITY_SELECTION{
                controller.orderMode = 3
            }else if sortedOrders[indexPath.section][indexPath.row].department_id?.department_type == DEPARTMENTTYPE.TAB{
                controller.orderMode = 9
            }
        }else{
            controller.orderId = sortedOrdersFilter[indexPath.section][indexPath.row]._id
            controller.titleBarText = sortedOrdersFilter[indexPath.section][indexPath.row].department_id?.name?.en
            if sortedOrdersFilter[indexPath.section][indexPath.row].department_id?.department_type == DEPARTMENTTYPE.QUANTITY_SELECTION{
                controller.orderMode = 3
            }else if sortedOrdersFilter[indexPath.section][indexPath.row].department_id?.department_type == DEPARTMENTTYPE.TAB{
                controller.orderMode = 9
            }
        }*/
        
        let controller = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "ReservationConfirmVC") as! ReservationConfirmVC
        controller.titleValue = sortedOrders[indexPath.section][indexPath.row].department_id?.name?.en
        controller.reservtionType = ReservationType.orderHistory
        controller.orderHistory = sortedOrders[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 200, height: 30))
         if isFilter == false{
            label.text = newDates[section]
         }else{
            label.text = newDatesFilter[section]
        }
        
        label.backgroundColor = .clear
        label.textColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.1607843137, alpha: 1)
        view.addSubview(label)
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        
    }
    
    
    func selectedScreenType(type: Int) {
        screenType = type
        self.tableView.reloadData()
        
    }
    
    func setDate() -> [String]{
        for order in orders!{
            if let date = order.created_date{
                let dateD = Helper.getStringFromDate(format: DATEFORMATTER.DD_MMM_YYYY, date: Helper.getDateFromString(string: date, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ))
                self.dateArray.append(dateD)
                
            }
            
        }
        return dateArray
        
    }
    
    func sortDate(dates: [String]) -> [String]{
        var sortedDates = [String]()
        for d in dates{
            if !sortedDates.contains(d){
                sortedDates.append(d)
            }
        }
        return sortedDates
    }
    
    func getAllOders(sortedDates:[String]) -> [[OrderListing]]{
        var sortedOrders = [[OrderListing]]()
        for sortedDate in sortedDates{
            var newOrders = [OrderListing]()
            for order in self.orders!{
                if let date = order.created_date{
                    if sortedDate == Helper.getStringFromDate(format: DATEFORMATTER.DD_MMM_YYYY, date: Helper.getDateFromString(string: date, formatString: DATEFORMATTER.YYYY_MM_DD_T_HH_MM_SS_SSSZ)){
                        newOrders.append(order)
                    }
                }
                }
            sortedOrders.append(newOrders)
               
        }
        return sortedOrders
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.001
//    }
}

extension OrderHistoryVC : RatingVCDelegate{
    func ratingVCResponse(controller: UIViewController) {
        controller.dismiss(animated: true, completion: {
            DispatchQueue.main.async(execute: {
                self.sortedOrders.removeAll()
                self.tableView.reloadData()
                if let userId = Helper.ReadUserObject()?.userId{
                    self.getOrderHistory(userID: userId)
                }
            })
        })
        
        
    }
    func cancelRatingVC(controller: UIViewController) {
        controller.dismiss(animated: true, completion: {
        })
    }
}

//
//  ItemDescriptionVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 11/01/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol ItemDescriptionDelegate {
    func cancelModification()
    func proceedWith(menu : Menu, items : [Modifier])
}
class ItemDescriptionVC: BaseViewController {
    
    @IBOutlet weak var view_bottom: UIView!
    @IBOutlet weak var btn_proceed: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var tbl_menus: UITableView!

    var titleBarText : String = ""
    var item : Menu?
    var modifierGroups : [ModifierGroup] = []
    var selectedQuantity : Int = 1
    var delegate : ItemDescriptionDelegate?
    var selectedArray : [Modifier] = []
    var defaultModifiers : [DefaultOption] = []
    override func viewDidLoad() {
        super.viewDidLoad()
         Helper.logScreen(screenName : "Menu Item Modifiers", className : "ItemDescriptionVC")
        

        
        tbl_menus.rowHeight = UITableViewAutomaticDimension
        tbl_menus.estimatedRowHeight = 100
        if let group = item?.modifierGroup {
            self.modifierGroups = group
        }
        if let defaultModi = item?.defaultModifiers, defaultModi.count > 0 {
           self.defaultModifiers = defaultModi
        }
        for group in modifierGroups {
            if let modifiers = group.modifiers {
                for modi in modifiers {
                    let arr = defaultModifiers.filter{ $0.modifierGroupId == modi.parentGroupId && $0.modifierId == modi.modifierId}
                    if arr.count > 0 {
//                        if let id = modi.modifierId {
//                            if defaultModifiers.contains(id) {
                                selectedArray.append(modi)
//                            }
//                        }
                    }
                    
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    func updateQuantity() {
        //lbl_quantity.text = "\(selectedQuantity)"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = titleBarText
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
//        selectedArray.removeAll()
    }
    
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func action_proceed(_ sender: Any) {
        for group in modifierGroups {
            if group.maxCount > 0 {
                let filterArray = self.selectedArray.filter {
                    $0.parentGroupId == group.modifierGroupId
                }
                
                if filterArray.count < group.minCount || filterArray.count < group.maxCount{
                    if filterArray.count > group.minCount {
                        print("Pass")
                    }
                    else {
                        if let name = group.name {
                            Helper.showCancelDialog(title: "", message: "Please select \(name)", viewController: self)
                        }
                        else {
                            Helper.showCancelDialog(title: "", message: "Please select required options.", viewController: self)
                        }
                        return
                    }
                    
                }
            }
        }
        if let menu = self.item {
            delegate?.proceedWith(menu: menu, items: selectedArray)
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_cancel(_ sender: Any) {
        delegate?.cancelModification()
        self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func action_addOrder(_ sender: Any) {
//    }
//    @IBAction func action_increment(_ sender: Any) {
//        selectedQuantity = selectedQuantity + 1
//        updateQuantity()
//    }
//    @IBAction func action_decrement(_ sender: Any) {
//        if selectedQuantity > 1 {
//            selectedQuantity = selectedQuantity - 1
//            updateQuantity()
//        }
//    }
}

extension ItemDescriptionVC : UITableViewDelegate, UITableViewDataSource{
    //    MARK: Tableview delegates and datasource
    public func numberOfSections(in tableView: UITableView) -> Int{
        return modifierGroups.count
//        if let modifiers = modifierGroups {
//            return modifiers.count
//        }
//        else {
//            return 0
//        }
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 60
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.HEADER_CELL) as! CustomTableCell
        
        let modifier = modifierGroups[section]
        
        var text = ""
        if let name = modifier.name {
                text = text.appending(name)
                text = text.appending("\n")
        }
        if modifier.minCount == 0 && modifier.maxCount == 0 {
            text = text.appending("( Optional )")
        }
        else {
            text = text.appending("( Required - Choose up to \(modifier.maxCount) )")
        }

        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = 5
            attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: text.characters.count))
            cell.lbl_headerTitle.attributedText = attrString
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = modifierGroups[section]
        if let modi = group.modifiers {
                return modi.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell : ModifierCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.MODIFIER_CELL) as! ModifierCell
            cell.delegate = self
            let modifier = modifierGroups[indexPath.section]
            if let modi = modifier.modifiers?[indexPath.row] {
                    cell.lbl_title.text = modi.name
                    if let price = modi.price {
                        if price == "0.00" || price == "" {
                            cell.lbl_price.text = ""
                        }
                        else {
                            cell.lbl_price.text = "$\(price)"
                        }
                    }
                    cell.lbl_description.text = modi.desc
                    cell.modifier = modi
                
                
                    if selectedArray.contains(modi){
                        cell.btn_check.isSelected = true
                    }
                    else {
                        cell.btn_check.isSelected = false
                    }
                }
            
            return cell
   }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let group = modifierGroups[indexPath.section]
            let filterArray = self.selectedArray.filter {
                $0.parentGroupId == group.modifierGroupId
            }
            if let modiArray = group.modifiers {
                let modi = modiArray[indexPath.row]
                if filterArray.contains(modi) {
                    let cell = tableView.cellForRow(at: indexPath) as! ModifierCell
                    cell.actionCheck(cell.btn_check)
                }
                else {
                    
                    if filterArray.count >= group.maxCount && group.maxCount != 0{
                        if let name = group.name {
                            Helper.showCancelDialog(title: ALERTSTRING.ERROR, message: "Reached maximum limit for \(name)", viewController: self)
                        }
                        else {
                            Helper.showCancelDialog(title: ALERTSTRING.ERROR, message: "Reached maximum limit", viewController: self)
                        }
                    }
                    else {
                        let cell = tableView.cellForRow(at: indexPath) as! ModifierCell
                        cell.actionCheck(cell.btn_check)
                    }
                }
            }
    }
}

extension ItemDescriptionVC : ModifierDelegate {
    func checkCell(modifier : Modifier) {
        if self.selectedArray.contains(modifier) {
            self.selectedArray.remove(at: self.selectedArray.index(of: modifier)!)
        }
        else {
            self.selectedArray.append(modifier)
        }
    }
}

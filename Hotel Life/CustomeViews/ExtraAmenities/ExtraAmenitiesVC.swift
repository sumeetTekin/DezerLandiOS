//
//  ExtraAmenitiesVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 17/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol ExtraAmenitiesDelegate {
    func selectedAmenitiesItems(items : [Amenities])
}
class ExtraAmenitiesVC: UIViewController {
    @IBOutlet weak var img_bg: UIImageView!
    @IBOutlet weak var tbl_items: UITableView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    
    var delegate : ExtraAmenitiesDelegate?
    var navController : UINavigationController?
    var items : [Amenities] = []
    var selectedItems : [Amenities] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        tbl_items.reloadData()
    }
    
    private func showQuantitySelection(amenity : Amenities) {
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.QuantityPickerVC) as! QuantityPickerVC
        objUpgrade.delegate = self
        self.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        objUpgrade.selectedQuantity = 1
        objUpgrade.amenity = amenity
        DispatchQueue.main.async(execute: {
            self.present(objUpgrade, animated: true, completion: nil)
//            self.navController?.present(objUpgrade, animated: true, completion: nil)
        })
    }
    @IBAction func cancel_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirm_action(_ sender: Any) {
        if selectedItems.count > 0 {
            delegate?.selectedAmenitiesItems(items: selectedItems)
        }
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension ExtraAmenitiesVC : UITableViewDelegate, UITableViewDataSource, AmenitiesCellDelegate {
    //    MARK: Tableview delegates and datasource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = AmenitiesCell()
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.AmenitiesCell) as! AmenitiesCell
            cell.selectionType = .multiple
            cell.configureCell(item: items[indexPath.row])
            cell.delegate = self
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath) as! AmenitiesCell
            cell.checkBtnAction(cell.btn_check)
    }
    
    
    //    MARK: CustomTableCellDelegate
    internal func checkCell(item: Amenities) {
        self.showQuantitySelection(amenity : item)
//        if !selectedItems.contains(item) {
//
//            selectedItems.append(item)
//        }
    }
    
    internal func unCheckCell(item: Amenities) {
        let amenity = selectedItems.filter { $0.name == item.name }
        if let item = amenity.first {
            if let index = selectedItems.index(of: item) {
                    selectedItems.remove(at: index)
            }
        }
    }
    
    internal func selectedCell(item: Amenities) {
    }

}
extension ExtraAmenitiesVC : QuantityPickerDelegate {
    func selectedPickerQuantity(quantity : Int) {
        //
    }
    func selectedAmenityQuantity(amenity : Amenities) {
        selectedItems.append(amenity)
    }
}

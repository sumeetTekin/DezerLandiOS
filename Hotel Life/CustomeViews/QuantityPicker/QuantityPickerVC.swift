//
//  QuantityPickerVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 20/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol QuantityPickerDelegate {
    func selectedPickerQuantity(quantity : Int)
    func selectedAmenityQuantity(amenity : Amenities)
}
class QuantityPickerVC: UIViewController {
    @IBOutlet weak var img_bg: UIImageView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var lbl_title: UILabel!
    
    var delegate : QuantityPickerDelegate?
    var selectedQuantity = 0
    var amenity : Amenities?
    var navController : UINavigationController?
    var quantityList : [Int] = []
    var titleHeader = TITLE.howMany
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...8 {
            quantityList.append(i)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         lbl_title.text = titleHeader
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirm_action(_ sender: Any) {
        if selectedQuantity > 0 {
            if let amenity = self.amenity {
                amenity.quantity = selectedQuantity
                delegate?.selectedAmenityQuantity(amenity: amenity)
            }
            else {
                delegate?.selectedPickerQuantity(quantity: selectedQuantity)
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }

}
extension QuantityPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Picker View Delegates & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantityList.count
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if quantityList.count>0{
//            return "\(quantityList[row])"
//        }
//        return ""
//    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < quantityList.count {
            selectedQuantity = quantityList[row] 
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var str = ""
        if quantityList.count>0{
            str =  "\(quantityList[row])"
        }
        let attrStr : NSAttributedString = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        return attrStr;
    }
}

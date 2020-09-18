//
//  AddCardVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 29/07/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

protocol AddPlayCardDelegate {
    func addCardAction(cardNumber: String?)
}

class AddPlayCardVC: BaseViewController {
    var delegate : AddPlayCardDelegate?
    
    @IBOutlet var txtCardNumber : UITextField?
    let maxLength = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClicked(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
        if txtCardNumber?.text != ""{
            delegate?.addCardAction(cardNumber: txtCardNumber?.text!)
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
   

}

extension AddPlayCardVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

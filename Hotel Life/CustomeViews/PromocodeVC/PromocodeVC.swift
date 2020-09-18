//
//  PromocodeVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 21/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol PromocodeDelegate {
    func enteredPromocode(code : String)
}
class PromocodeVC: UIViewController {
    var delegate : PromocodeDelegate?
    
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var txt_promocode: UITextField!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var img_bg: UIImageView!
    
    var headerValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_header.text = headerValue
//        img_bg.layer.borderColor = UIColor.white.cgColor
//        img_bg.layer.borderWidth = 0.5
        // Do any additional setup after loading the view.
    }

    @IBAction func fiftyAction(_ sender: Any) {
        self.txt_promocode.text = "50"
    }
    @IBAction func hundradeAction(_ sender: Any) {
        self.txt_promocode.text = "100"
    }
    @IBAction func onefiftyAction(_ sender: Any) {
        self.txt_promocode.text = "150"
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func action_Confirm(_ sender: Any) {
        if let code = txt_promocode.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if code.characters.count > 0 {
                delegate?.enteredPromocode(code: code)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

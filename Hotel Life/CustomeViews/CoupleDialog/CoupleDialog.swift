//
//  CoupleDialog.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 04/01/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol CoupleDelegate {
    func enteredCoupleName(name : String)
}
class CoupleDialog: UIViewController {
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var btn_confirm: UIButton!
    var delegate : CoupleDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        if let name = txt_name.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if name.characters.count > 0 {
                delegate?.enteredCoupleName(name: name)
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

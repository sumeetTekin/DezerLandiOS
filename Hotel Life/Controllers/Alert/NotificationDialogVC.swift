//
//  NotificationDialogVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 22/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
@objc protocol NotificationDialogVCDelegate {
    func yesAction(_obj:NotificationModel?)
    func noAction()
}
class NotificationDialogVC: UIViewController {
    var notificationObj : NotificationModel?
    weak var delegate : NotificationDialogVCDelegate?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var btn_yes: UIButton!
    @IBOutlet weak var btn_no: UIButton!
    @IBOutlet weak var constraint_dialogHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action_no(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.noAction()
        }
    }
    @IBAction func action_yes(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.yesAction(_obj: self.notificationObj)
        }
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

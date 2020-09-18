//
//  DisclaimerVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 25/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
protocol DisclaimerDelegate {
    func disclaimerAgreed()
}
class DisclaimerVC: UIViewController {

    @IBOutlet weak var txtv_disclaimer: UITextView!
    @IBOutlet weak var btn_agree: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var btn_check: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var agree = false
    var disclaimerText : String = ""
    var delegate : DisclaimerDelegate?
    var showConfirm = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TITLE.Disclaimer
        Helper.logScreen(screenName : "DisclaimerVC", className : "DisclaimerVC")

        btn_confirm.setTitle(TITLE.Confirm, for: .normal)
        btn_cancel.setTitle(TITLE.Cancel, for: .normal)
        btn_agree.setTitle(BUTTON_TITLE.I_AGREE, for: .normal)
        btn_agree.setTitle(BUTTON_TITLE.I_AGREE, for: .selected)

        if disclaimerText != "" {
            self.txtv_disclaimer.text = disclaimerText
        }
        btn_agree.contentHorizontalAlignment = .fill
        btn_agree.contentVerticalAlignment = .fill
        btn_agree.imageView?.contentMode = .scaleAspectFit
        
        if !showConfirm {
            self.navigationItem.title = "How does Trump Bucks work?"
            bottomConstraint.constant = 10
            btn_agree.isHidden = !showConfirm
            bgView.isHidden = !showConfirm
            btn_check.isHidden = !showConfirm
            if let attrStr = Helper.getCustomHTMLAttributedString(text: disclaimerText) {
                txtv_disclaimer.attributedText = attrStr
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    override func viewWillLayoutSubviews() {
        self.txtv_disclaimer.setContentOffset(.zero, animated: false)
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionAgree(_ sender: UIButton) {
        if sender.isSelected == true {
            agree = false
            sender.isSelected = false
            btn_check.isSelected = false
        }
        else{
            agree = true
            sender.isSelected = true
            btn_check.isSelected = true
        }
    }
    @IBAction func actionCancel(_ sender: Any) {
        self.backAction(sender as! UIButton)
    }
    @IBAction func actionConfirm(_ sender: Any) {
        if agree == false {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.AgreeTerms)
            return
        }
        self.navigationController?.popViewController(animated: true)
        delegate?.disclaimerAgreed()
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

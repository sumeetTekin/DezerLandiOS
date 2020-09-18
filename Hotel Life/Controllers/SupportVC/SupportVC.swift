//
//  SupportVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 02/01/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

class SupportVC: BaseViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var txtv_description: MyTextView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_version: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.addBorder(color: UIColor.white)
        setPlaceholder()
        Helper.logScreen(screenName : "Feedback / Suppot", className : "SupportVC")
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lbl_version.text = "version \(version)"
        }
        // Do any additional setup after loading the view.
    }
    func setPlaceholder() {
        txtv_description.set(text : "", placeholder: PLACEHOLDER.question, placeholderColor: UIColor.white, text_color: UIColor.white)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = BUTTON_TITLE.Customer_support
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func submitAction(_ sender: Any) {
        self.txtv_description.resignFirstResponder()
        if let question = txtv_description.text, question != "",question != PLACEHOLDER.question {
            let bizObj = BusinessLayer()
            self.activateView(self.view, loaderText: "")
            let dict = ["question" : question]
            bizObj.customerSupport(question: dict as NSDictionary, { (status, message) in
                if status {
                    DispatchQueue.main.async {
                        self.deactivateView(self.view)
                        self.setPlaceholder()
                        self.showConfirmationDialog(title: "", message: message)

                    }
                }
            })
        }
        else{
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Please enter a question.")
        }
        
    }
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.present(objAlert, animated: false) {
            }
        })
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

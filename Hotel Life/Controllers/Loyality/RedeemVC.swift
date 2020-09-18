//
//  RedeemVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 20/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class RedeemVC: BaseViewController {
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_code: UILabel!
    let titleBarText = "Redeem Points"
    var desc = ""
    var code = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Redeem points screen", className: "RedeemVC")
        self.lbl_description.text = desc
        self.lbl_code.text = code
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
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

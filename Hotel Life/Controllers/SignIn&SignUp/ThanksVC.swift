//
//  ThanksVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/19/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
class ThanksVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "ThanksVC", className: "ThanksVC")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(objDashboard, animated: true)
            })


    }

}

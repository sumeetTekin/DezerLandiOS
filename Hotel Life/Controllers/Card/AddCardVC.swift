//
//  AddCardVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/21/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class AddCardVC: BaseViewController {
    var titleBarText: String = "Add Credit Card"
    
    @IBOutlet weak var viewBG: UIView!
    
    override func viewDidLoad() {
        Helper.logScreen(screenName: "Add Card", className: "AddCardVC")

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewBG.addBorder(color: .white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Add Credit Card"
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
    }
    
    @objc func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }

}

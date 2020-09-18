//
//  OrderHistoryTabViewController.swift
//  Resort Life
//
//  Created by Adil Mir on 1/30/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class OrderHistoryTabVC: TabImageTitleVC {
    
    
    var pages : [PageModel] = []
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabMargin = 15
        setupViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for controller in self.pages {
            controller.viewController?.viewWillAppear(animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for controller in self.pages {
            controller.viewController?.viewDidAppear(animated)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    func setupViewControllers() {
        
            let pageModel = PageModel()
            let objCustom  = Helper.getOrderHidtoryStoryboard().instantiateViewController(withIdentifier:"OrderHistoryVC") as! OrderHistoryVC
        objCustom.navController = self.navigationController
        
            //            objCustom.itemInfo.title = tabObj.name
            pageModel.title = "Past Orders"// add localisation
            pageModel.viewController = objCustom
            pageModel.isSelected = true
            self.delegate = objCustom
             self.pages.append(pageModel)
        let upcomingOrderModel = PageModel()
        let upcomingOrders  = Helper.getOrderHidtoryStoryboard().instantiateViewController(withIdentifier:"OrderHistoryVC") as! OrderHistoryVC
        //            objCustom.itemInfo.title = tabObj.name
         upcomingOrders.navController = self.navigationController
        upcomingOrderModel.title = "Upcoming Orders"
        upcomingOrderModel.viewController = upcomingOrders
        upcomingOrderModel.isSelected = false
        self.pages.append(upcomingOrderModel)
        self.delegate = upcomingOrders
        self.setPageModelArray(self.pages)
        
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

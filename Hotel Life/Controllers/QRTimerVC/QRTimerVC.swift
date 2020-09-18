//
//  QRTimerVC.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 18/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class QRTimerVC: BaseViewController {
    
    @IBOutlet weak var lbl_timer: UILabel!
    @IBOutlet weak var img_QR: UIImageView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var view_timerBg: UIView!
    @IBOutlet weak var view_qrBg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Reserved"
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
        view_qrBg.layer.borderWidth = 0.5
        view_qrBg.layer.borderColor = UIColor.white.cgColor
        
        view_timerBg.layer.borderColor = UIColor.white.cgColor
        view_timerBg.layer.borderWidth = 0.5
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelAction(_ sender: Any) {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController is SubMenuVC{
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popToViewController(viewController, animated: true)
                })
                return
            }
        }
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objDashboard, animated: true)
        })
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

extension QRTimerVC {
    @objc public func backAction(_ sender : UIButton) {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController is SubMenuVC{
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popToViewController(viewController, animated: true)
                })
                return
            }
        }
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objDashboard, animated: true)
        })
    }
}

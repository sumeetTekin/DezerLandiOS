//
//  NotificationMarketingVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 21/11/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

class NotificationMarketingVC: UIViewController {
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var notificationObj : NotificationModel?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnContinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lbl_message.text = notificationObj?.message?.message
        if let image = notificationObj?.message?.image {
            if let url = URL(string: image) {
                imageView.sd_setImage(with: url) { (image, error, type, url) in
                    self.loader.isHidden = true
                }
            }
        } else {
            imageHeight.constant = 20
            imageView.isHidden = true
            loader.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action_continue(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func action_yes(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    

}

//
//  PublishPostcardVC.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 21/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class PublishPostcardVC: BaseViewController {
    
    @IBOutlet weak var view_preview: UIView!
    //@IBOutlet weak var txt_hashtag: HashtagTextView!
    @IBOutlet weak var img_selected: UIImageView!
    var selectedImage : UIImage?
    //var hashtagText : String? = ""
    var titleBarText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Publish Postcard screen", className: "PublishPostcardVC")

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = titleBarText
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
        view_preview.layer.borderColor = UIColor.white.cgColor
        view_preview.layer.borderWidth = 0.5
        
        if selectedImage != nil {
            self.img_selected.image = selectedImage
        }
//        if hashtagText != "" && hashtagText != PLACEHOLDER.addComment {
//            txt_hashtag.setText(text: hashtagText!, hashtagColor: COLORS.THEME_YELLOW_COLOR, normalFont: UIFont.init(name: FONT_NAME.FONT_REGULAR, size: 15)!, hashtagFont: UIFont.init(name: FONT_NAME.FONT_BOLD, size: 15)!, callback: {string, wordType in
//
//            })
//        }
    }
    @objc public func backAction(_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    @IBAction func crossAction(_ sender: UIButton) {
        self.backAction(sender)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionNext(_ sender: Any) {
        
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
    
    @IBAction func facebookAction(_ sender: UIButton) {
        SocialShare.shared.shareWith(image: selectedImage, type: .facebook, fromController: self, delegate: self)
    }
    @IBAction func twitterAction(_ sender: Any) {
        SocialShare.shared.shareWith(image: selectedImage, type: .twitter, fromController: self, delegate: self)
    }
    @IBAction func instagramAction(_ sender: Any) {
        SocialShare.shared.shareWith(image: selectedImage, type: .instagram, fromController: self, delegate: self)
    }
}
extension PublishPostcardVC : SocialShareDelegate {
    func uploadStarted() {
        DispatchQueue.main.async {
            Helper.showLoader(title: LOADER_TEXT.loading)
        }
    }
    func uploadEnded() {
//            Helper.showAlert(sender: self, title: ALERTSTRING.POSTED, message: "")
        DispatchQueue.main.async {
            Helper.hideLoader()
        }
    }
}


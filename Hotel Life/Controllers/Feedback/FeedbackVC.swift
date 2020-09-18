//
//  FeedbackVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
//import XLPagerTabStrip

class FeedbackVC: BaseViewController, AlertVCDelegate {
//    var itemInfo = IndicatorInfo(title: "View")
    var navController : UINavigationController?
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var feedbackTabbar: UITabBar!
    @IBOutlet weak var worstItem: UITabBarItem!
    @IBOutlet weak var badItem: UITabBarItem!
    @IBOutlet weak var normalItem: UITabBarItem!
    @IBOutlet weak var goodItem: UITabBarItem!
    @IBOutlet weak var bestItem: UITabBarItem!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
//    @IBOutlet weak var childViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var submitBottomConstraint: NSLayoutConstraint!
    
    var rateObj: RateModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.itemInfo = "Feedback"
        Helper.logScreen(screenName: "Feedback screen", className: "FeedbackVC")


        // Do any additional setup after loading the view.
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        feedbackTabbar.selectedItem = goodItem
        childView.backgroundColor = .clear
        childView.layer.borderColor = UIColor.white.cgColor
        childView.layer.borderWidth = 1.0
        rateObj = RateModel()
        self.initialSetup()
        updateName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateName()
    }
    
    func updateName() {
        if let user = AppInstance.applicationInstance.user  {
            if let name = user.name {
                let nameArr = name.components(separatedBy: " ")
                self.usernameLbl.text = "Hi" + " " + (nameArr.first?.appending("!"))!
            }
        }
        else{
            self.usernameLbl.text = ""
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup(){
        worstItem.title = RATING_EXPERINECE.WORST
        badItem.title = RATING_EXPERINECE.BAD
        normalItem.title = RATING_EXPERINECE.NORMAL
        goodItem.title = RATING_EXPERINECE.GOOD
        bestItem.title = RATING_EXPERINECE.BEST
        //By default rating experience
        rateObj?.experience = RATING_EXPERINECE.GOOD
        commentTextView.text = RATING_EXPERINECE.PLACEHOLDER_TEXT
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if commentTextView.text == RATING_EXPERINECE.PLACEHOLDER_TEXT{
            rateObj?.comment = ""
        }else if commentTextView.text.characters.count > 0{
            rateObj?.comment = commentTextView.text
            rateObj?.comment = rateObj?.comment?.replacingOccurrences(of: RATING_EXPERINECE.PLACEHOLDER_TEXT, with: "")
        }
        self.giveRating()
    }
    
    // MARK: - Web-Service Calling
    func giveRating() {
        DispatchQueue.main.async{
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        }
        
        let bizObject:BusinessLayer=BusinessLayer()
        bizObject.giveRating(rateObj: rateObj, { (success, response) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if(success) {
                    self.showConfirmationDialog(title: ALERTSTRING.THANKS_FOR_FEEDBACK, message: response!)
                }
                else {
                    Helper.printLog(response! as AnyObject?)
                    Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: response!, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                    })
                }
            })
        })
    }
    
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            objAlert.delegate = self
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.navController?.present(objAlert, animated: false) {
            }
        })
    }
    
    func alertDismissed(){
        self.rateObj = RateModel()
        self.initialSetup()

    }

    // MARK: - IndicatorInfoProvider
    
//    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return itemInfo
//    }
    
}

extension FeedbackVC: UITabBarDelegate{
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        switch tabBar.selectedItem! {
        case worstItem:
            rateObj?.experience = RATING_EXPERINECE.WORST
        case badItem:
            rateObj?.experience = RATING_EXPERINECE.BAD
        case normalItem:
            rateObj?.experience = RATING_EXPERINECE.NORMAL
        case goodItem:
            rateObj?.experience = RATING_EXPERINECE.GOOD
        case bestItem:
            rateObj?.experience = RATING_EXPERINECE.BEST
        default:
            break
        }
    }
}

extension FeedbackVC: UITextViewDelegate{
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        return true
    }
    public func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == RATING_EXPERINECE.PLACEHOLDER_TEXT{
            textView.text = ""
            textView.textColor = .black
        }
//        childViewTopConstraint.constant = -90
//        submitBottomConstraint.constant = 140
    }
    public func textViewDidEndEditing(_ textView: UITextView){
        if textView.text == "" || textView.text == " "{
            textView.text = RATING_EXPERINECE.PLACEHOLDER_TEXT
            textView.textColor = .gray
        }else{
            textView.textColor = .black
        }
//        childViewTopConstraint.constant = 15
//        submitBottomConstraint.constant = 45
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
}

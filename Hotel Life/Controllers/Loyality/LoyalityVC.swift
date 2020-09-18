//
//  LoyalityVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
//import XLPagerTabStrip

class LoyalityVC: BaseViewController {
    //    var itemInfo = IndicatorInfo(title: "View")
    var navController : UINavigationController?
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var btn_trumpBucksDescription: UIButton!
    //    @IBOutlet var headerView: UIView!
    var loyaltyArray : [Loyalty] = []
    let refreshControl : UIRefreshControl = UIRefreshControl()
    var loyaltyPoints : Float = 100
    var loyaltyProgress : Float = 0
    var tempText : String? = ""
    var trumpText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        
        getLoyalty(showLoader : false)
        Helper.logScreen(screenName: "Loyalty screen", className: "LoyalityVC")

    }
    override func viewWillAppear(_ animated: Bool) {
        //updateLoyalty()
        getWalletBalance()
    }
    func addRefreshControl(){
        refreshControl.tintColor = COLORS.GREEN_COLOR
        refreshControl.addTarget(self, action: #selector(updateLoyalty), for: .valueChanged)
        self.myCollectionView.addSubview(refreshControl)
        self.myCollectionView.alwaysBounceVertical = true
    }
    
    
    func getWalletBalance(){
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
//        })
        
        let bizObject = BusinessLayer()
        bizObject.getDezerBucks { (status, message, response) in
            DispatchQueue.main.async(execute: { () -> Void in
                
                if status == true{
                    self.loyaltyPoints = Float(response?.data?.totalPoints ?? 0)
                    self.myCollectionView.reloadData()
                    
                }else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: message)
                }
            })
            
            
        }
        
        
    }
    
    func getLoyalty(showLoader : Bool) {
        if showLoader {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
        }
        
        let bizObject = BusinessLayer()
        bizObject.getLoyaltyMenu({(status, loyaltyArray, points, progress, showScreen, trumpText) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.trumpText = trumpText
                self.blockView.isHidden = true//showScreen
                self.refreshControl.endRefreshing()
                if showLoader {
                    self.deactivateView(self.view)
                }
                if status {
                    self.loyaltyArray = loyaltyArray!
                    self.loyaltyPoints = points
                    self.loyaltyProgress = progress
                    self.myCollectionView.reloadData()
                }
            })
        })
    }
    @objc func updateLoyalty() {
        getLoyalty(showLoader : true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionDescription(_ sender: UIButton) {
        let controller = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.DisclaimerVC) as! DisclaimerVC
        controller.disclaimerText = trumpText
        controller.showConfirm = false
        self.navController?.pushViewController(controller, animated: true)
    }
    // MARK: - IndicatorInfoProvider
    //    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    //        return itemInfo
    //    }
    
    
    @IBAction func amounButtonAction(_ sender: UIButton){
        let controller = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentCardSelectVC") as! PaymentCardSelectVC
        if let text = sender.titleLabel?.text{
            if text == "$50"{
                controller.amountValue = "50"
            }else if text == "$100"{
                controller.amountValue = "100"
            }else if text == "$150"{
                controller.amountValue = "150"
            }
           
        }
        
        self.navController?.pushViewController(controller, animated: true)
    }
    
    
}

extension LoyalityVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, LoyaltyDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = Device.SCREEN_WIDTH/2 - 5//Display Two elements in a row.
        collectionViewSize.height = Device.SCREEN_WIDTH/2 - Device.SCREEN_WIDTH/3.5
        return collectionViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CELL_IDENTIFIER.LOYALITY_HEADER, for: indexPath as IndexPath) as! LoyalityHeaderReusableView
        headerView.configureHeader()
        headerView.pointsLabel.text = String.init(format: "%.0f", self.loyaltyPoints)
        headerView.lbl_balance.text = String.init(format: "You have $%.2f to redeem", self.loyaltyPoints/1000)
        self.tempText = headerView.lbl_balance.text
        headerView.progressBar.setProgress( CGFloat(self.loyaltyProgress), animated: true)
        headerView.delegate = self
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UICollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return loyaltyArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.LOYALITY, for: indexPath as IndexPath) as! LoyalityCell
        cell.backgroundColor = .clear
        cell.configureCell(indexPath: indexPath, loyalityObj:loyaltyArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let loyalty = loyaltyArray[indexPath.row]
        if loyalty.slug == "book_your_next_stay" && loyalty.is_enabled == false{
            bookNextStay(loyalty : loyalty)
        }
        //            let loyalty = loyaltyArray[indexPath.row]
        //            if loyalty.heading == "" || loyalty.heading == nil || loyalty.description == "" || loyalty.description == nil || loyalty.title == "" || loyalty.title == nil {
        //                return
        //            }
        //            let controller = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "LoyalityShareVC") as! LoyalityShareVC
        //            controller.selectedLoyalty = loyaltyArray[indexPath.row]
        //            DispatchQueue.main.async(execute: {
        //                self.navController?.pushViewController(controller, animated: true)
        //            })
    }
    private func bookNextStay(loyalty : Loyalty) {
        self.showCustomAlertWith(title: loyalty.title, message: ALERTSTRING.wouldYouLike, image:  #imageLiteral(resourceName: "check_img_green"))
    }
    private func showCustomAlertWith(title : String?, message : String?, image : UIImage?) {
        let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CustomAlertView) as! CustomAlertView
        objAlert.delegate = self
        self.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.lbl_title.text = title
        objAlert.lbl_message.text = message
        objAlert.img_icon.image = image
        self.navController?.present(objAlert, animated: false) {
        }
    }
    private func showConfirmationDialog(title : String, message : String) {
        let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
        self.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
        self.navController?.present(objAlert, animated: false, completion: {
        })
    }
    //    MARK:Loyalty Delegate
    func redeemAction() {
        DispatchQueue.main.async(execute: {
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let obj = BusinessLayer()
        obj.getRedeemCode { (status, message) in
            if status {
                let controller : RedeemVC = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.RedeemVC) as! RedeemVC
                controller.desc = self.tempText!
                controller.code = message
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    self.navController?.pushViewController(controller, animated: true)
                })
            }
            else{
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
            }
            
        }
    }
}
extension LoyalityVC : CustomAlertViewDelegate{
    func alertDismissed() {
    }
    
    internal func yesAction(){
//        let model = ReservationModel()
//        self.showRoomDialog(model: model)
        self.bookStay(room_number: nil)
    }
    func bookStay(room_number : String?) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        // book my stay contact us
        let obj = BusinessLayer()
        obj.bookStay(room_number : room_number, { (status, title, message) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if status {
                    self.showConfirmationDialog(title: title, message: message)
                    //                    Helper.showAlert(sender: self, title: "", message: message)
                }
                else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            })
        })
    }
    private func showRoomDialog(model : ReservationModel){
        if let room_number = Helper.getRoomNumber(), room_number != "" {
            self.bookStay(room_number: room_number)
        
        }
        else {
            let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SelectChairVC") as! SelectChairVC
            objUpgrade.delegate = self
            objUpgrade.showRoom = true
            objUpgrade.reservationModel =  model
            objUpgrade.alertText = ALERTSTRING.ROOM_NUMBER
            self.definesPresentationContext = true
            objUpgrade.modalPresentationStyle = .overCurrentContext
            objUpgrade.modalTransitionStyle = .crossDissolve
            objUpgrade.view.backgroundColor = .clear
            DispatchQueue.main.async(execute: {
                self.navController?.present(objUpgrade, animated: true, completion: nil)
            })
        }
        
    }
    internal func noAction(){
        
    }
}
extension LoyalityVC : SelectChairVCDelegate {
    func fillRoom(alohaOrderModel: AlohaOrder, reservationModel: ReservationModel, controller: UIViewController) {
        
    }
    
    func selectedChair(model: ReservationModel, controller: UIViewController) {
     
    }
    
    func selectedQuantity(quantity: Int) {
     
    }
    
    func selectedRoom(model : ReservationModel,controller : UIViewController) {
        controller.dismiss(animated: true, completion: {
            
            if let room_number = model.room_number {
                self.bookStay(room_number: room_number)
            }
        })
    }
}



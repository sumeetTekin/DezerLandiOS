//
//  PaymentCardsViewController.swift
//  Kangaroo Propane
//
//  Created by Lokesh Negi on 05/02/2020.
//  Copyright © 2020 Adil Mir. All rights reserved.
//

import UIKit

enum OrderSection: Int, CaseIterable {
    case Cards
    case Paypal
}

class PaymentCardsViewController: BaseViewController {
    
    
    // MARK: Outlets
    
    @IBOutlet weak var cardsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    
    // MARK: Variables
    
    var cardsData : [PaymentProfiles]?
    var check = 0
    //weak var delegate:OrderListViewController?
    
    
    

    
      
    // MARK: VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchCardDetailsAPI), name: Notification.Name("getCards"), object: nil)
        continueButton.isHidden = true
        fetchCardDetailsAPI()
        self.setNavigationBar(title: "Payment Cards")
    }
    
    
    
     // MARK: FUNCTIONS
    
    
    func openPopUp() {
     
//        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
//            let navigationController = UINavigationController(rootViewController: vc)
//            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            navigationController.navigationBar.isHidden = true
//            self.present(navigationController, animated: true, completion: nil)
//        }
        
        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
            vc.delegate = self
            vc.type = PaymentType.addCard
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func getUserDetails() {
//        BussinessLayer().getDataFromServer(target: self, path: ApiPaths.getUserInfo, parameters: [:]) { (succes, response:LoginResponse?, message) in
//            if succes{
//                if let user = response?.customer{
//                    Helper.saveUser(user: user)
//                }
//            }
//        }
    }
    
    
    // MARK: ACTIONS
    
    @IBAction func backPresses(_sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("fetchCardAPI"), object: nil)
    }
    
    @IBAction func addCardButton(_sender : UIButton) {
        openPopUp()
    }
    
    @IBAction func continueButtonPressed(_sender : UIButton) {
        
        if check == 0{
            self.navigationController?.popViewController(animated: true)
            
//            let controller = Storyboards.Main.instantiateViewController(withIdentifier: StoryboardIdentifiers.CustomTabBarViewController) as! CustomTabBarViewController
//            self.pushViewContrioller(controller: controller)
//            AppInstance.shared.selectedIndex = ValidationString.acceptOrder
        
        }else if check == 3{
//            let controller = Storyboards.Main.instantiateViewController(withIdentifier: StoryboardIdentifiers.CustomTabBarViewController) as! CustomTabBarViewController
//            self.pushViewContrioller(controller: controller)
//            AppInstance.shared.selectedIndex = ValidationString.profile
//            NotificationCenter.default.post(name: Notification.Name("fetchCardAPI"), object: nil)
        
        }else if check == 1{
            if let controllers = navigationController?.viewControllers {
                for item in controllers {
//                    if item.isKind(of: ConfirmOrderViewController.self) {
//                        self.navigationController?.popToViewController(item, animated: true)
//                        NotificationCenter.default.post(name: Notification.Name("fetchCardAPI"), object: nil)
//                        return
//                    }
                }
            }
           
        }
    }
    
    
    
    //MARK: API
    
    @objc func fetchCardDetailsAPI(){
        
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        BusinessLayer().getPaymentCardsList() { (status, message, response) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if response != nil {
                    self.cardsData = response?.data?.paymentProfiles
                    self.cardsTableView.reloadData()
                }
            })
            
            
            
            
            
        }
        
        
        
    }

}


extension PaymentCardsViewController: UITableViewDataSource,UITableViewDelegate {
    
    func previewActions(forCellAt indexPath: IndexPath) {
        guard let cell = cardsTableView.cellForRow(at: indexPath) else {
            return
        }

        let label: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.text = "  Swipe Me  "
            label.backgroundColor = UIColor.hexStringToUIColor(hex:"FFA200")
            label.textColor = .white
            return label
        }()

        // Figure out the best width and update label.frame
        let bestSize = label.sizeThatFits(label.frame.size)
        label.frame = CGRect(x: cell.bounds.width - bestSize.width, y: 5, width: bestSize.width, height: cell.bounds.height - 10)
        cell.insertSubview(label, aboveSubview: cell.contentView)
        //cell.layer.cornerRadius = 5
      

        UIView.animate(withDuration: 1.0, animations: {
            cell.transform = CGAffineTransform.identity.translatedBy(x: -label.bounds.width, y: 0)
            label.transform = CGAffineTransform.identity.translatedBy(x: label.bounds.width, y: 0)
        }) { (finished) in
            UIView.animateKeyframes(withDuration: 1.0, delay: 0.25, options: [], animations: {
                cell.transform = CGAffineTransform.identity
                label.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                label.removeFromSuperview()
            })
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardsData?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = cardsTableView.dequeueReusableCell(withIdentifier: CardsTableViewcell.cellId) as? CardsTableViewcell else { return UITableViewCell() }

        if cardsData?[indexPath.row].defaultPaymentProfile == true{
            cell.cardView.borderColor = UIColor.hexStringToUIColor(hex: "15C578")
            cell.cardView.borderWidth = 3
            cell.cardView.clipsToBounds = true
        }else{
            cell.cardView.borderColor = UIColor.gray
            cell.cardView.borderWidth = 1
            cell.cardView.clipsToBounds = true
        }
        cell.cardNameLabel.text = cardsData?[indexPath.row].payment?.creditCard?.cardType
        cell.cardNameLabel.isHidden = false
        cell.cardLastFourDigitLabel.text = cardsData?[indexPath.row].payment?.creditCard?.cardNumber
        cell.cardExpireLabel.text = cardsData?[indexPath.row].payment?.creditCard?.expirationDate
//        if let url = cardsData[indexPath.row].imageUrl{
//            cell.cardImageView.setImage(url: URL(string: url), with: nil)
//        }
        return cell
        
        
        
        
        
   
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if cardsData?[indexPath.row].defaultPaymentProfile != true{
            
            //DEFAULT ACTION
            
            let editAction = UITableViewRowAction(style: .default, title: "Default", handler: { (action, indexPath) in
                if let cardToken = self.cardsData?[indexPath.row].customerPaymentProfileId{
                    let alert = UIAlertController(title: ALERTSTRING.TITLE, message: ALERTSTRING.defaultCard, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: BUTTON_TITLE.Yes, style: .default, handler: { (action) in
                        if let cardToken = self.cardsData?[indexPath.row].customerPaymentProfileId{
                            self.defaultCard(token: cardToken, cardExpirationDate: (self.cardsData?[indexPath.row].payment?.creditCard?.expirationDate ?? ""), cardNumber: (self.cardsData?[indexPath.row].payment?.creditCard?.cardNumber ?? ""))
                        }
                    }))
                    alert.addAction(UIAlertAction(title: BUTTON_TITLE.Cancel, style: .cancel, handler: nil))
                    self.present(alert,animated: true)
                    
                }
            })
            editAction.backgroundColor = UIColor.hexStringToUIColor(hex: "15C578")
            
            //DELETE ACTION
            
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
                let alert = UIAlertController(title: ALERTSTRING.TITLE, message: ALERTSTRING.removeCard, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: BUTTON_TITLE.Delete, style: .destructive, handler: { (action) in
                    if let cardToken = self.cardsData?[indexPath.row].customerPaymentProfileId{
                        self.deleteCard(token: cardToken)
                    }
                }))
                alert.addAction(UIAlertAction(title: BUTTON_TITLE.Cancel, style: .cancel, handler: nil))
                self.present(alert,animated: true)
            })
            deleteAction.backgroundColor = UIColor.hexStringToUIColor(hex: "D61A1A")
            
            return [editAction, deleteAction]
        }
        return []
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let order_section = OrderSection(rawValue: indexPath.section) else { return 0 }
        switch order_section {
        case .Cards:
            return 150
        case .Paypal:
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = OrderSection(rawValue: section) else { return 0 }
        switch section {
        case .Cards:
            return 40
        case .Paypal:
            return 0
        default:
            return 40
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let viewFrame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
          let headerView = ListingHeaderView(with: viewFrame)
          guard let order_section = OrderSection(rawValue: section) else { return nil }
          switch order_section {
          case .Cards:
              headerView.titleLabel.text = "Cards"
              headerView.show_optionsView = false
          case .Paypal:
              headerView.titleLabel.text = "Paypal"
              headerView.show_optionsView = false
          }
          headerView.section = section
        
          return headerView
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if cardsData[indexPath.row].defaultValue != true{
//            previewActions(forCellAt: indexPath)
//        }
        return
    }
}

extension PaymentCardsViewController{
    
    func defaultCard(token:String, cardExpirationDate: String, cardNumber: String) {

        
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        var param = KeyValue()
        param["customerPaymentProfileId"] = token
        param["cardExpirationDate"] = cardExpirationDate
        param["cardNumber"] = cardNumber
        BusinessLayer().defaultPaymentCard(dict: param) { (status, message, response) in
            if status == true{
                self.fetchCardDetailsAPI()
            }else{
                Helper.showAlert(sender: self, title: "Error", message: message)
            }
        }
        
        
        
    }
    
    
    func deleteCard(token:String){
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        var param = KeyValue()
        //param["customerPaymentProfileId"] = token
        BusinessLayer().deletePaymentCard(id: token) { (status, message, response) in
            if status == true{
                self.fetchCardDetailsAPI()
            }else{
                Helper.showAlert(sender: self, title: "Error", message: message)
            }
        }
        
    }
    
    func buildQueryString(apiStr: String, params : [String:Any]) -> String {
        var api = apiStr
        api = api.appending("?")
        for item in params.keys {
            api = api.appending("\(item)=\(String(describing: params[item]!))")
        }
        return api
    }
    
}


extension PaymentCardsViewController: AuthrizeNetDelegate{
    func addCardFunction(_ token: String?) {
        print(token)
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        var param = KeyValue()
        param["token"] = token
        BusinessLayer().addPaymentCard(dict: param) { (status, message, response) in
            if status == true{
                self.fetchCardDetailsAPI()
            }else{
                Helper.showAlert(sender: self, title: "Error", message: message)
            }
        }
        
    }
}

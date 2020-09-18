//
//  PaymentCardSelectVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 21/08/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class PaymentCardSelectVC: BaseViewController {
    
    var cardsData : [PaymentProfiles]?
    @IBOutlet weak var cardsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var amountValue : String?
    var cardNumber : String?
    var customerPaymentProfileId : String?
    
    var buttonClosure : (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCardDetailsAPI()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPresses(_sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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
                    if response?.data?.paymentProfiles != nil {
                        self.cardsData = response?.data?.paymentProfiles
                        self.cardsTableView.reloadData()
                    }else{
                        Helper.showAlertWithAction(sender: self, title: ALERTSTRING.TITLE, message: "No Card available, kindly add card first") { (action) in
                            
                            if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
                                vc.delegate = self
                                vc.type = PaymentType.addCard
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                    }
                    
                }
            })
            
        }
        
        
        
    }
    
    @IBAction func addCardAction(_sender : Any) {
        
        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
            vc.delegate = self
            vc.type = PaymentType.addCard
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @IBAction func continueAction(_sender : Any) {
        
        if (self.cardsData?.count ?? 0) > 0{
            
            if cardNumber != nil{
                
                guard let customerpaymentProfileId = customerPaymentProfileId else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: "Please select atleat one card for payment")
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.activateView(self.view, loaderText:LOADER_TEXT.loading)
                })
                var param = [String : Any]()
                param["cardNumber"] = cardNumber!
                param["credits"] = amountValue!
                param["customerPaymentProfileId"] = customerpaymentProfileId
                BusinessLayer().rechargePaymentCard(dict: param) { (status, message, response) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.deactivateView(self.view)
                        if response != nil {
                            if status == true{
                                //self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popViewController(animated: true)
                                self.buttonClosure!()
                               
                            }else{
                                Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: message)
                            }
                        }else{
                            Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: message)
                        }
                    })
                }
                
            }
            
            else{
                
                guard let customerpaymentProfileId = customerPaymentProfileId else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: "Please select atleat one card for payment")
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.activateView(self.view, loaderText:LOADER_TEXT.loading)
                })
                var param = [String : Any]()
               // param["cardNumber"] = cardNumber!
                param["points"] = amountValue!
                param["customerPaymentProfileId"] = customerpaymentProfileId
                BusinessLayer().addAmountOnWallet(dict: param) { (status, message, response) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.deactivateView(self.view)
                       // if response != nil {
                            if status == true{
                                //self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popViewController(animated: true)
                                //self.buttonClosure!()
                               
                            }else{
                                Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: message)
                            }
                        //}
                    })
                }
                
            }
            
            
            
        }else{
            
            Helper.showAlertWithAction(sender: self, title: ALERTSTRING.TITLE, message: "No Card available, kindly add card first") { (action) in
                
                if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
                    vc.delegate = self
                    vc.type = PaymentType.addCard
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }
        
        
        
        
        
    }
    

}


extension PaymentCardSelectVC: UITableViewDataSource,UITableViewDelegate {
    
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
        
        cell.cardView.borderColor = UIColor.gray
        cell.cardView.borderWidth = 1
        cell.cardView.clipsToBounds = true

        if cardsData?[indexPath.row].defaultPaymentProfile == true{
            self.customerPaymentProfileId = cardsData?[indexPath.row].customerPaymentProfileId
            cell.radioButtun?.isSelected = true
        }else{
            cell.radioButtun?.isSelected = false
        }
        cell.radioButtun?.tag = indexPath.row
        cell.buttonClosure = {sender in
            for (index, _) in self.cardsData!.enumerated(){
                self.cardsData?[index].defaultPaymentProfile = false
                if sender.tag == indexPath.row{
                    self.cardsData?[indexPath.row].defaultPaymentProfile = true
                    self.customerPaymentProfileId = self.cardsData?[indexPath.row].customerPaymentProfileId
                }
               
            }
            self.cardsTableView.reloadData()
        }
        
        cell.cardNameLabel.text = cardsData?[indexPath.row].payment?.creditCard?.cardType
        cell.cardNameLabel.isHidden = false
        cell.cardLastFourDigitLabel.text = cardsData?[indexPath.row].payment?.creditCard?.cardNumber
        cell.cardExpireLabel.text = cardsData?[indexPath.row].payment?.creditCard?.expirationDate

        return cell
        
        
        
        
        
   
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let viewFrame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
          let headerView = ListingHeaderView(with: viewFrame)
          
          headerView.titleLabel.text = "Cards"
          headerView.show_optionsView = false
          
        
          return headerView
      }
    
    
}

extension PaymentCardSelectVC: AuthrizeNetDelegate{
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

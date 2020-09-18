//
//  SacoaCardVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 28/07/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class SacoaCardVC: BaseViewController, PromocodeDelegate, AddPlayCardDelegate {
    func enteredPromocode(code: String) {
        
        DispatchQueue.main.async(execute: { () -> Void in
            let controller = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentCardSelectVC") as! PaymentCardSelectVC
            controller.cardNumber = self.cardNumberForRecharge
            controller.amountValue = code
            controller.buttonClosure = {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.getSacoaCardList()
                })
                
            }
            //self.navigationController?.present(controller, animated: true, completion: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        })
        
        
    }
    
    func addCardAction(cardNumber: String?){
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        let paramDic: [String:Any] = ["cardNumber":cardNumber ?? ""]
        BusinessLayer().addSacoaCard(dict: paramDic) { (status, message, response) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            
            if status == true{
                self.getSacoaCardList()
            }else{
                Helper.showAlert(sender: self, title: "Error", message: message)
            }
            
        }
        
    }
    
    //MARK: OUTLET and properties
    
    @IBOutlet var tblView: UITableView?
    @IBOutlet var addCard: UIButton?
    @IBOutlet var recharge: UIButton?
    
    var cardNumberForRecharge: String?
    
    var cardList : [Cards]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "My Play Cards")
        
        
        
        setLocalizeStringToParameters()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSacoaCardList()
        self.tblView?.reloadData()
    }
    
    
    private func setLocalizeStringToParameters(){
        addCard?.setTitle(BUTTON_TITLE.addCard, for: .normal)
        recharge?.setTitle(BUTTON_TITLE.recharge, for: .normal)
        //txtChooseDuration?.placeholder = PLACEHOLDER.choose_duration
    }
    
    private func getSacoaCardList(){
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        BusinessLayer().getSacoaCardList { (status, response, message) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if status == true{
                    self.cardList = response?.data?.body?.cards
                    self.tblView?.reloadData()
                }else{
                    Helper.showAlert(sender: self, title: ALERTSTRING.TITLE, message: message)
                }
            })
            
            
        }
    }
    
    
    @IBAction func addNewCardAction(_ sender:UIButton) {
       // self.navigationController?.popViewController(animated: true)
         Helper.showddCardDialog(delegate: self, navigationController: self.navigationController, controller: self)
    }
    
    @IBAction func rechargeAction(_ sender:UIButton) {
        
        Helper.showPromocodeDialog(delegate: self, navigationController: self.navigationController, controller: self)
        
        
//        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
//            let navigationController = UINavigationController(rootViewController: vc)
//            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            navigationController.navigationBar.isHidden = false
//            self.present(navigationController, animated: true, completion: nil)
//        }
    }
    


}


//MARK:  tableview delegate datasource methods
extension SacoaCardVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SacoaCardCell
        cell.selectionStyle = .none
        cell.setCellValue(cardDetail: self.cardList?[indexPath.row])
        cell.buttonClosure = { sender in
            self.cardNumberForRecharge = self.cardList?[indexPath.row].cardNumber
            Helper.showPromocodeDialog(delegate: self, navigationController: self.navigationController, controller: self)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240//UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PlayCardTransactionVC") as? PlayCardTransactionVC{
            vc.cardNumber = self.cardList?[indexPath.row].cardNumber
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


class SacoaCardCell: UITableViewCell{
    
    // MARK: Outlets
    
    
    @IBOutlet weak var cardName: UILabel?
    @IBOutlet weak var cardNumber: UILabel?
    @IBOutlet weak var balance: UILabel?
    @IBOutlet weak var ticket: UILabel?
    @IBOutlet weak var bonus: UILabel?
    
    
    
    @IBOutlet weak var cardNameLabel: UILabel?
    @IBOutlet weak var cardNumberLabel: UILabel?
    @IBOutlet weak var balanceLabel: UILabel?
    @IBOutlet weak var ticketLabel: UILabel?
    @IBOutlet weak var bonusLabel: UILabel?
    
    var buttonClosure : ((UIButton) -> Void)?
    @IBOutlet weak var rechargeButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLocalizeStringToParameters()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setLocalizeStringToParameters(){
      cardName?.text = TITLE.status
      cardNumber?.text = TITLE.cardNumber
      balance?.text = TITLE.balance
      ticket?.text = TITLE.tickets
      bonus?.text = TITLE.bonus
        //cardNumber?.text = TITLE.ChooseTime
    }
    
    func setCellValue(cardDetail: Cards?){
        cardNameLabel?.text = cardDetail?.status
        cardNumberLabel?.text = cardDetail?.cardNumber
        balanceLabel?.text = cardDetail?.credits
        ticketLabel?.text = cardDetail?.tickets
        bonusLabel?.text = cardDetail?.bonus
    }
    
    @IBAction func rechargeAction(_ sender : UIButton){
        self.buttonClosure!(sender)
    }
    
}

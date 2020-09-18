//
//  PlayCardTransactionVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 29/07/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class PlayCardTransactionVC: BaseViewController {

    @IBOutlet var tblView: UITableView?
    var cardList : [Result]?
    var cardNumber: String?
    var paymentType:String? = "sacoaCard"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSacoaCardTransaction()
        self.setNavigationBar(title: "Transection History")

        // Do any additional setup after loading the view.
    }
    
    
    private func getSacoaCardTransaction(){
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        
        BusinessLayer().getSacoaCardTransaction(cardType: (paymentType ?? "sacoaCard"), cardNumber: cardNumber ?? "") { (status, response, message) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if status == true{
                    self.cardList = response?.data?.result
                    self.tblView?.reloadData()
                }else{
                    Helper.showAlert(sender: self, title: "Error", message: message)
                }
            })
            
        
        }}
       

}

//MARK:  tableview delegate datasource methods
extension PlayCardTransactionVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? SacoaCardTransactionCell
        cell?.selectionStyle = .none
        cell?.setCellValue(cardDetail: self.cardList?[indexPath.row])

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}



class SacoaCardTransactionCell: UITableViewCell{
    
    // MARK: Outlets
    
    
    @IBOutlet weak var cardNumber: UILabel?
    @IBOutlet weak var amount: UILabel?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var bonus: UILabel?
    
    
    
    @IBOutlet weak var cardNumberLabel: UILabel?
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
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
      cardNumber?.text = TITLE.cardNumber
      amount?.text = TITLE.amount
      date?.text = TITLE.date
      bonus?.text = TITLE.bonus
        //cardNumber?.text = TITLE.ChooseTime
    }
    
    func setCellValue(cardDetail: Result?){
        if let cardNumber = cardDetail?.paymentDetails?.accountNumber{
           cardNumberLabel?.text = cardNumber
        }else if let cardNumber = cardDetail?.sacoaCardNumber{
            cardNumberLabel?.text = "\(cardNumber)"
        }
        
        if let amount = cardDetail?.amount{
            amountLabel?.text = "$\(amount)"
        }
        
        dateLabel?.text = cardDetail?.createdAt
    }
    
    @IBAction func rechargeAction(_ sender : UIButton){
        self.buttonClosure!(sender)
    }
    
}


//
//  InvoiceVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 20/02/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
class InvoiceVC: UIViewController {
    @IBOutlet weak var tbl_invoice: UITableView!
    
    
    @IBOutlet weak var view_bottom: UIView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_totalTitle: UILabel!
    var invoiceArray : [Invoice] = []
//    var detailInvoice : Invoice?
    var message : String?
    var total : Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_invoice.rowHeight = UITableViewAutomaticDimension
        self.tbl_invoice.estimatedRowHeight = 250
        Helper.logScreen(screenName : "Invoice Screen", className : "InvoiceVC")
//        lbl_totalTitle.text = TITLE.Total
        getTotal()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Folio"
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    override func viewDidAppear(_ animated: Bool) {
        if let msg = self.message {
            self.showConfirmationDialog(title: "Folio", message: msg)
//            Helper.showAlertWithAction(sender: self, title: ALERTSTRING.ERROR, message: msg, { (action) in
//                DispatchQueue.main.async {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            })
        }
    }
    private func showConfirmationDialog(title : String, message : String) {
        let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
        self.definesPresentationContext = true
        objAlert.modalPresentationStyle = .overCurrentContext
        objAlert.view.backgroundColor = .clear
        objAlert.delegate = self
        objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
        self.navigationController?.present(objAlert, animated: false, completion: {
        })
    }
    func getTotal()  {
        for item in invoiceArray {
            var debit : Float = 0
            var credit : Float = 0
            if let val = item.tdebit {
                debit = Helper.getFloatVal(str: val)
            }
            if let val = item.tcredit {
                credit = Helper.getFloatVal(str: val)
            }
            total = total + (debit - credit)
        }
        self.lbl_price.text = String(format : "$%.2f",total)
    }
    @objc public func backAction(_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension InvoiceVC: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
//        return detailInvoice == nil ? 1 : 2
        return 1
    }
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 110
//        }
//        else {
//            return 230
//        }
//    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return invoiceArray.count
//        if section == 0 {
//            return invoiceArray.count
//        }
//        else {
//            return detailInvoice == nil ? 0 : 1
//        }
        
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let invoice = invoiceArray[indexPath.row]
//        if indexPath.section == 0 {
        if let paymentDetail = invoice.paymentDetail {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.PAYMENT_DETAIL_CELL, for: indexPath as IndexPath) as! PaymentDetailCell
                cell.detail = paymentDetail
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.INVOICE_CELL, for: indexPath as IndexPath) as! InvoiceCell
            cell.invoice = invoice
            return cell
        }
        
    }
}
extension InvoiceVC : AlertVCDelegate {
    func alertDismissed(){
//        self.backAction(UIButton())
        DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
    }
}

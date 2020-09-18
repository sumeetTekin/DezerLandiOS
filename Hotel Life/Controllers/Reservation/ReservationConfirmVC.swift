//
//  ReservationConfirmVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 03/07/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

protocol ReservationConfirmDelegate {
    func alertDismissedToRootView()
}

enum ReservationType{
    case resevation
    case orderHistory
}


class ReservationConfirmVC: BaseViewController {
    
    var showDate = true
    var delegate : ReservationConfirmDelegate?
    var titleValue : String? = "Reservation"
    var reservation : ReservationModel = ReservationModel()
    var orderHistory : OrderListing = OrderListing()
    
    var reservtionType = ReservationType.resevation
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var btnGoBack: UIButton?
       @IBOutlet weak var btnConfirm: UIButton?
      

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel?.text = titleValue
        btnGoBack?.setTitle(BUTTON_TITLE.Go_Back, for: .normal)
        btnConfirm?.setTitle(BUTTON_TITLE.Continue, for: .normal)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar(title : titleValue ?? "Reservation Confirm")
    }
    
    
    
    @IBAction func goBackAction(_ sender:UIButton) {
        //self.navigationController?.popToRootViewController(animated: true)
        switch reservtionType {
        case .orderHistory:
            self.navigationController?.popViewController(animated: true)
        default:
            delegate?.alertDismissedToRootView()
        }
        
    }
    
    @IBAction func continueAction(_ sender:UIButton) {
        
        switch reservtionType {
        case .orderHistory:
            if let destinationViewController = self.navigationController?.viewControllers
                                                                    .filter(
                                                  {$0 is BaseTabBarVC})
                                                                    .first {
                self.navigationController?.popToViewController(destinationViewController, animated: true)
            }
        default:
            delegate?.alertDismissedToRootView()
        }
    }
    

   

}

extension ReservationConfirmVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.ReservationDetailCell, for: indexPath as IndexPath) as! ReservationDetailCell
        cell.isShowDateTime = showDate
        
        switch reservtionType {
        case .resevation:
            cell.reservation = self.reservation
        case .orderHistory:
            cell.orederHistory = self.orderHistory
        default:
            cell.reservation = self.reservation
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

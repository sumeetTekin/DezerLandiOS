//
//  DezerBucksTransactionHistoryVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 24/08/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class DezerBucksTransactionHistoryVC: BaseViewController {

    @IBOutlet var tblView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "Transaction History")

        // Do any additional setup after loading the view.
    }
    


}

//MARK:  tableview delegate datasource methods
extension DezerBucksTransactionHistoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.selectionStyle = .none
        if let label = cell.viewWithTag(100) as? UILabel{
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}

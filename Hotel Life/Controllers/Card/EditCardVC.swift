//
//  EditCardVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/19/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class EditCardVC: BaseViewController {
//    var cardArray:[String] = ["xxxx - xxxx - xxxx - 5454", "xxxx - xxxx - xxxx - 5698", "xxxx - xxxx - xxxx - 4851"]
    var cardArray:[String] = []

    var titleBarText: String = "Edit Credit Card"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Edit Card", className: "EditCardVC")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText.replacingOccurrences(of: "\n", with: " ")
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objDirection, animated: true)
        })
    }

}

extension EditCardVC : UITableViewDelegate, UITableViewDataSource {
    
    //    MARK: Tableview delegates and datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count + 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : CardCell?
        switch indexPath.row {
        case cardArray.count + 0:
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CARD_ADD) as? CardCell
            cell?.addCard.addTarget(self, action: #selector(addCardAction(_:)), for: .touchUpInside)
        case cardArray.count + 1:
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CARD_SAVE) as? CardCell
            cell?.saveCard.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CARD_CELL) as? CardCell
            cell?.configureCardCell(indexPath: indexPath)
            cell?.cardNumber.text = cardArray[indexPath.row]
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case cardArray.count + 0:
            return 50
        case cardArray.count + 1:
            return 65
        default:
            return 65
        }
        
    }
  
}


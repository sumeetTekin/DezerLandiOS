//
//  RemoveMenuVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 29/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol RemoveVCDelegate {
    func afterRemoving(items : [Menu],posId : String, controller : RemoveMenuVC)
}
class RemoveMenuVC: UIViewController {

    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_proceed: UIButton!
    @IBOutlet weak var tbl_menus: UITableView!
    var selectedItems : [Menu] = []
    var delegate : RemoveVCDelegate?
    var posId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl_menus.rowHeight = UITableViewAutomaticDimension
        tbl_menus.estimatedRowHeight = 200
        Helper.logScreen(screenName : "Remove Selected Items", className : "RemoveMenuVC")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func proceedAction(_ sender: Any) {
        delegate?.afterRemoving(items: selectedItems, posId: posId, controller: self)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
extension RemoveMenuVC : UITableViewDelegate, UITableViewDataSource {
    //    MARK: Tableview delegates and datasource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.REMOVE_MENU_CELL) as! RemoveCell
        cell.setupCellFor(menu : selectedItems[indexPath.row])
        cell.delegate = self

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
}
extension RemoveMenuVC : RemoveDelegate {
    func remove(item: Menu) {
        if selectedItems.contains(item) {
            selectedItems.remove(at: selectedItems.index(of: item)!)
        }
        if selectedItems.count <= 0 {
            delegate?.afterRemoving(items: selectedItems, posId: posId, controller: self)
        }
        tbl_menus.reloadData()
    }
}

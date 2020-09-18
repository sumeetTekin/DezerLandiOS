//
//  RestaurantInformationVC.swift
//
//
//  Created by Vikas Mehay on 08/11/17.
//

import UIKit

class RestaurantInformationVC: BaseViewController {
    var titleBarText = ""
    @IBOutlet weak var scroll_bgView: UIScrollView!
    
    @IBOutlet weak var constraint_descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var txtv_info: UILabel!
    @IBOutlet weak var img_restaurant: UIImageView!
    var department : Department?
    var restaurantDescription : String = ""
    
    var items : [Menu] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName : "Restaurant detail", className : "RestaurantInformationVC")

        if titleBarText.characters.first == "N" || titleBarText.characters.first == "n" {
            img_restaurant.image = #imageLiteral(resourceName: "neomi_demo")
        }
        else if titleBarText.characters.first == "F" || titleBarText.characters.first == "f" {
            img_restaurant.image = #imageLiteral(resourceName: "fusion_demo")
        }
        else {
            img_restaurant.image = #imageLiteral(resourceName: "gili_demo")
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = titleBarText
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
        if let dept = department {
            if let items = dept.items {
                self.items = items
                if let imageURL = items.first?.imageURL {
                    img_restaurant.sd_setImage(with: imageURL, completed: nil)
                }
                if let descriptionText = items.first?.linkDescription {
                    restaurantDescription = descriptionText
                }
            }
        }
        
        if restaurantDescription.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            //            if let attrStr = Helper.getHTMLAttributedString(text: restaurantDescription) {
            //                txtv_info.attributedText = attrStr
            //            }
            txtv_info.text = restaurantDescription
            
        }
        else{
            txtv_info.text = ""
            constraint_descriptionHeight.constant = 0
        }
    }
    
    @objc func backAction (_ sender : UIButton) {
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
extension RestaurantInformationVC : UITableViewDelegate, UITableViewDataSource{
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.HEADER_CELL)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.items.count
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.SUB_MENU, for: indexPath as IndexPath) as! SubMenuCell
        cell.configureRestaurantCell(indexPath: indexPath, menuObj: self.items[indexPath.row])
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let controller : RestaurantMenuVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.RestaurantMenuVC) as! RestaurantMenuVC
        let menu = self.items[indexPath.row]
        if let link = menu.link {
            controller.url = URL.init(string: link)
        }
        if let name = menu.label {
            controller.titleBarText = name
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

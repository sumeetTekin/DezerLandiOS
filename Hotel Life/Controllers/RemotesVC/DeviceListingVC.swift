//
//  DeviceListingVC.swift
//  Hotel Life
//
//  Created by Adil Mir on 2/1/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class DeviceListingVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var devices:[Devices]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
        getDeviceLists(roomNo: "101")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Devices"//Do localization
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getDeviceLists(roomNo:String){
        let buzzObj = BusinessLayer()
        DispatchQueue.main.async(execute: { () -> Void in
                        self.activateView(self.view, loaderText: LOADER_TEXT.loading)
                    })
        buzzObj.getDeviceList(roomNo: roomNo) { (success, msg, data) in
            DispatchQueue.main.async(execute: { () -> Void in
                                self.deactivateView(self.view)
                            })
            if success{
                if let deviceData = data{
                    DispatchQueue.main.async(execute: {
                        self.devices = deviceData.devices
                        self.tableView.reloadData()
                    })
                   
                }
            }else{
                
                    Helper.showAlert(sender: self, title: "Error", message: msg)
                
            }
        }
    }
}
extension DeviceListingVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") as! CustomTableCell
        cell.lbl_headerTitle.text = devices?[indexPath.row].label
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let deviceAddress = devices?[indexPath.row].address{
            let remoteVc = Helper.getRemoteStoryboard().instantiateViewController(withIdentifier:STORYBOARD.ThermostatVC) as! ThermostatVC
            remoteVc.deviceAddress = deviceAddress
            self.navigationController?.pushViewController(remoteVc, animated: true)
        }
    }
    
    
}

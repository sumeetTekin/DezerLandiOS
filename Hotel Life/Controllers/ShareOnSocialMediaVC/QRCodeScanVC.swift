//
//  QRCodeScanVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 11/06/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit

class QRCodeScanVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title : "Scan QR code")
        self.scanQRCode(self)
        

        // Do any additional setup after loading the view.
    }
    

    func scanQRCode(_ sender: Any) {
           
           //QRCode scanner without Camera switch and Torch
           let scanner = QRCodeScannerController()
           
           //QRCode with Camera switch and Torch
           //let scanner = QRCodeScannerController(cameraImage: UIImage(named: "camera"), cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "flash-on"), flashOffImage: UIImage(named: "flash-off"))
           scanner.delegate = self
        self.navigationController?.pushViewController(scanner, animated: true)
           //self.present(scanner, animated: true, completion: nil)
       }
    
    @IBAction func gobackAction(_ sender : Any){
        self.scanQRCode(self)
    }

}

extension QRCodeScanVC: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        self.navigationController?.popViewController(animated: true)
        print("SwiftQRScanner did cancel")
    }
}

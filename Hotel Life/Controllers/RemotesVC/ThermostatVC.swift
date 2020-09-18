//
//  ThermostatVC.swift
//  Hotel Life
//
//  Created by Adil Mir on 1/24/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit
import SocketIO

class ThermostatVC: BaseViewController {
    var deviceInfo:DeviceInfo!
    var navController : UINavigationController?
    var deviceAddress:String!
    @IBOutlet weak var lblTempChange: UILabel!
    @IBOutlet weak var tempSlider: UISlider!
    @IBOutlet weak var modeTF: UITextField!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var controlSwitch: UISwitch!
    @IBOutlet weak var increaseButton:UIButton!
    @IBOutlet weak var decreaseButton:UIButton!
    @IBOutlet weak var lblFanSpeed: UILabel!
    @IBOutlet weak var lblACMode: UILabel!
    @IBOutlet weak var tempLabel:UILabel!
    @IBOutlet weak var poweButton:UIButton!
    @IBOutlet weak var modeButton: UIButton!
    
    @IBOutlet var fanSpeedBtnCollection: [UIButton]!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var imageMode: UIImageView!
    @IBOutlet weak var imageFanSpeed: UIImageView!
    
    
    
    var temp:Int = 0
//    var previousValue:Float = 0
//    let manager = SocketManager(socketURL: URL(string: "http://54.210.73.85:8080")!, config: [.log(true), .compress])
//    var socket: SocketIOClient!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       poweButton.isSelected = true
        
        Helper.logScreen(screenName: "Thermostat", className: "ThermostatVC")
        getDeviceInfo(deviceAddress:deviceAddress)
        //self.getRoomTemprature(roomNo:101)
      
       // connectSocket()
        //socket.emit("updateTemprature", with: [1234,1234])
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Thermostat"//Do localization
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
        
        
    }
    @objc func backAction (_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
//    func connectSocket(){
//        socket = manager.defaultSocket
//        socket.on(Helper.ReadUserObject()?.userId! ?? "12345") { (data, ack) in
//            DispatchQueue.main.async(execute: {
//                print("socket connected")
//                if let temp = data[0] as? NSDictionary{
//                    let te = ThermostatAPIResponse.init(dictionary: temp)
//                    if let thermostatTemp =  te?.payload?.changes?.tkorouter?.thermostat?.coolSetpoint{
//                        self.temp = Float(thermostatTemp)
//                        DispatchQueue.main.async(execute: {
//                            self.tempLabel.text = String(self.temp)
//
//                        })
//                    }
//                }
//            })
//        }
//        self.socket.connect()
//    }
    //MARK: -----Actions----
    
    @IBAction func didTapIncreaseButton(_ sender: UIButton) {
        
        if let maxTemp = deviceInfo.cool_setpoint_max{
            if temp < Int(maxTemp) {
              temp += 1
                self.lblTempChange.text = String(Double(temp))
                setDeviceInfo(coolSetPoint: Double(temp), mode: deviceInfo.mode_state, fanspeed: FanSpeed.high.rawValue, heatSetPoint: deviceInfo.heat_setpoint)
        }
        }
        
        
    }
    @IBAction func didTapDecreaseButton(_ sender: UIButton) {
       
        
        if let minTemp = deviceInfo.cool_setpoint_min{
            if temp > Int(minTemp + 1){
                temp -= 1
                self.lblTempChange.text = String(Double(temp))
                setDeviceInfo(coolSetPoint: Double(temp), mode: deviceInfo.mode_state, fanspeed: FanSpeed.high.rawValue, heatSetPoint: deviceInfo.heat_setpoint)
            }
        }
       
    }
    @IBAction func didTapPowerButton(_ sender: UIButton) {
        if sender.isSelected{
          sender.isSelected = false
        } else{
        sender.isSelected = true
        }
    }
    
    @IBAction func didTapModeButton(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
             self.setModeToOn()
            self.setDeviceInfo(coolSetPoint: self.deviceInfo.cool_setpoint, mode: Mode.auto.rawValue, fanspeed: self.deviceInfo.fanspeed, heatSetPoint: self.deviceInfo.heat_setpoint)
        } else{
            sender.isSelected = true
            self.setModeToOff()
            self.setDeviceInfo(coolSetPoint: self.deviceInfo.cool_setpoint, mode: Mode.off.rawValue, fanspeed: self.deviceInfo.fanspeed, heatSetPoint: self.deviceInfo.heat_setpoint)
        }
        
        
        
        
        /*let arrMode = ["Auto","High","Low","Medium"]
        
        let alertController = UIAlertController(title: "Mode", message: "Please select any one", preferredStyle: .actionSheet)
        
        for (index, item) in arrMode.enumerated(){
            let button = UIAlertAction(title: item , style: .default, handler: { (action) in
                print(item)
                switch (index){
                    
                case 0:
                    print("Auto")
                    self.setDeviceInfo(coolSetPoint: self.deviceInfo.cool_setpoint, mode: Mode.auto.rawValue, fanspeed: self.deviceInfo.fanspeed, heatSetPoint: self.deviceInfo.heat_setpoint)
                case 1:
                    print("High")
                    self.setDeviceInfo(coolSetPoint: self.deviceInfo.cool_setpoint, mode: Mode.high.rawValue, fanspeed: self.deviceInfo.fanspeed, heatSetPoint: self.deviceInfo.heat_setpoint)
                case 2:
                    print("Low")
                    self.setDeviceInfo(coolSetPoint: self.deviceInfo.cool_setpoint, mode: Mode.low.rawValue, fanspeed: self.deviceInfo.fanspeed, heatSetPoint: self.deviceInfo.heat_setpoint)
                default:
                    print("Medium")
                    self.setDeviceInfo(coolSetPoint: self.deviceInfo.cool_setpoint, mode: Mode.medium.rawValue, fanspeed: self.deviceInfo.fanspeed, heatSetPoint: self.deviceInfo.heat_setpoint)
                }
                
            })
            alertController.addAction(button)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
      */
    }
    
    func setModeToOff(){
        DispatchQueue.main.async(execute: {
            self.poweButton.isSelected = false
            self.unSetData()
        })
    }
    
    func setModeToOn(){
        DispatchQueue.main.async(execute: {
            self.poweButton.isSelected = true
            self.setData()
        })
    }
    
    
    @IBAction func didTapAuto(_ sender: UIButton) {
        lblFanSpeed.text = FanSpeed.auto.rawValue.capitalizingFirstLetter()
        setSelectedButton(tag: sender.tag)
        setDeviceInfo(coolSetPoint: deviceInfo.cool_setpoint, mode: deviceInfo.mode_state, fanspeed: FanSpeed.auto.rawValue, heatSetPoint: deviceInfo.heat_setpoint)
        
    }
    @IBAction func didTapHigh(_ sender: UIButton) {
        lblFanSpeed.text = FanSpeed.high.rawValue.capitalizingFirstLetter()
        setSelectedButton(tag: sender.tag)
         setDeviceInfo(coolSetPoint: deviceInfo.cool_setpoint, mode: deviceInfo.mode_state, fanspeed: FanSpeed.high.rawValue, heatSetPoint: deviceInfo.heat_setpoint)
    }
    
    @IBAction func didTapLow(_ sender: UIButton) {
        lblFanSpeed.text = FanSpeed.low.rawValue.capitalizingFirstLetter()
         setSelectedButton(tag: sender.tag)
        setDeviceInfo(coolSetPoint: deviceInfo.cool_setpoint, mode: deviceInfo.mode_state, fanspeed: FanSpeed.low.rawValue, heatSetPoint: deviceInfo.heat_setpoint)
    }
    
    @IBAction func didTapMedium(_ sender: UIButton) {
        lblFanSpeed.text = FanSpeed.medium.rawValue.capitalizingFirstLetter()
         setSelectedButton(tag: sender.tag)
        setDeviceInfo(coolSetPoint: deviceInfo.cool_setpoint, mode: deviceInfo.mode_state, fanspeed: FanSpeed.medium.rawValue, heatSetPoint: deviceInfo.heat_setpoint)
    }
    @IBAction func didChangeValueWithEvent(_ sender: UISlider, forEvent event: UIEvent) {
       
        guard let touch = event.allTouches?.first, touch.phase != .ended else {
            print("ended")
          //  changeRoomTemprature(roomNo: 101, temp: sender.value.truncate(places: 2))
           
            return
        }
       // self.lblSliderValue.text = String(sender.value.truncate(places: 2))
        
    }
    
    func setSelectedButton(tag:Int){
        for button in fanSpeedBtnCollection{
            button.isEnabled = true
            button.alpha = 1.0

            if button.tag == tag{
                button.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.8549019608, blue: 0.8352941176, alpha: 1)
                button.isSelected = true
               
            } else {
                button.isSelected = false
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    func getDeviceInfo(deviceAddress:String){
        let bzzObj = BusinessLayer()
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        bzzObj.getDeviceInfo(deviceAddress: deviceAddress) { (success, msg, deviceInfo) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            if success{
                if let deviceInfo = deviceInfo{
                    self.deviceInfo = deviceInfo
                    DispatchQueue.main.async(execute: {
                        if let mode = Mode(rawValue: deviceInfo.mode ?? "off"){
                            switch(mode){
                            case .auto, .cool:
                                self.setData()
                            case.off:
                                self.unSetData()
                            }
                        }
                    })
                }
               
            } else{
                 Helper.showAlert(sender: self, title: "Error", message: msg)
            }
            
        }
    }
    
    func unSetData(){
        self.modeButton.isSelected = true

        self.tempLabel.textColor = .gray
        self.lblTempChange.textColor = .gray
        self.lblFanSpeed.textColor = .gray
        self.lblACMode.textColor = .gray
        self.plusButton.isUserInteractionEnabled = false
        self.minusButton.isUserInteractionEnabled = false
        self.imageMode.alpha = 0.5
        self.imageFanSpeed.alpha = 0.5
        
        for button in fanSpeedBtnCollection{
              button.isEnabled = false
              button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
              button.alpha = 0.5
            
        }
    }
    
    
    func setData(){
        self.modeButton.isSelected = false
        
        self.tempLabel.textColor = .black
        self.lblTempChange.textColor = .black
        self.lblFanSpeed.textColor = .black
        self.lblACMode.textColor = .black
        self.plusButton.isUserInteractionEnabled = true
        self.minusButton.isUserInteractionEnabled = true
        self.imageMode.alpha = 1.0
        self.imageFanSpeed.alpha = 1.0
        
        
        if let temp = deviceInfo.temperature{
            self.tempLabel.text = String(temp)
        }
      
        if let coolSetPoint = deviceInfo.cool_setpoint{
             self.lblTempChange.text = String(coolSetPoint)
            deviceInfo.cool_setpoint = coolSetPoint
            temp = Int(coolSetPoint)
        }
        if let fanSpeed = deviceInfo.fanspeed{
            self.lblFanSpeed.text = fanSpeed.capitalizingFirstLetter()
            enableFanSpeedButton(mode:fanSpeed)
        }
        
        if let mode = deviceInfo.mode_state{
            self.lblACMode.text = mode.capitalizingFirstLetter()
        }
        
        
    }
    
    func enableFanSpeedButton(mode:String){
        switch mode {
        case FanSpeed.auto.rawValue:
            self.setSelectedButton(tag: 101)
        case FanSpeed.high.rawValue:
            self.setSelectedButton(tag: 102)
        case FanSpeed.low.rawValue:
            self.setSelectedButton(tag: 103)
        case FanSpeed.medium.rawValue:
            self.setSelectedButton(tag: 104)
        default:
            break
        }
        
    }
  
    func setDeviceInfo(coolSetPoint:Double?,mode:String?,fanspeed:String?,heatSetPoint:Double?){
        var parms = [String:Any]()
        if let fan = fanspeed{
             parms["fanspeed"] = fan
        }
        if let cool_setPoint = coolSetPoint{
             parms["cool-setpoint"] = cool_setPoint
        }
        if let heat_setPoint = heatSetPoint{
           parms["heat-setpoint"] = heat_setPoint
        }
        if let mode = mode{
              parms["mode"] = mode
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bzzObj = BusinessLayer()
        bzzObj.setDeviceInfo(prams: parms, deviceAddress: deviceAddress) { (success, msg, medd) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            if success{
                print(msg)
                self.deviceInfo.fanspeed = fanspeed ?? ""
            }else{
                 print(msg)
            }
        }
    }
    //Set selected fan speed button
    
    
//    func getRoomTemprature(roomNo:Int){
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.activateView(self.view, loaderText: "")
//        })
//        let parms = ["room_number":101]
//        let bzObject = BusinessLayer()
//        bzObject.getRoomTemprature(params: parms) { (success, response, msg) in
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.deactivateView(self.view)
//            })
//            if success{
//                if let thermostatTemp = response?.payload?.changes?.tkorouter?.thermostat?.coolSetpoint{
//                    self.temp = Float(thermostatTemp - 17)
//                    DispatchQueue.main.async(execute: {
//                        self.tempSlider.setValue(Float(thermostatTemp), animated: true)
//                        self.perform(#selector(self.animateProgress), with: nil, afterDelay: 0.3)
//                    })
//                }
//            } else{
//                print(msg)
//            }
//        }
//    }
    
//    func changeRoomTemprature(roomNo:Int,temp:Float){
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.activateView(self.view, loaderText: "")
//        })
//        var parms = [String:Any]()
//        parms["cool-setpoint"] = temp
//        parms["room_number"] = roomNo
//
//        let bzObject = BusinessLayer()
//        bzObject.updateRoomTemprature(params: parms) { (success, response, msg) in
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.deactivateView(self.view)
//            })
//            if success{
//                if let thermostatTemp = response?.payload?.changes?.tkorouter?.thermostat?.coolSetpoint{
//                    self.temp = Float(thermostatTemp - 17)
//                    DispatchQueue.main.async(execute: {
//                        self.perform(#selector(self.animateProgress), with: nil, afterDelay: 0.3)
//                    })
//                }
//            } else{
//                print(msg)
//            }
//        }
//    }
    
}

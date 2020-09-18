//
//  DirectionsMenuVC.swift
//  BeachResorts
//
//  Created by Apple on 16/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI
class DirectionsMenuVC: BaseViewController {
    
    var menuArray : [Menu] = []
    var labelArray : [String] = ["Uber","Lyft","Super Shuttle","Taxi","Waze","Maps"]
    var imageArray : [UIImage] = [#imageLiteral(resourceName: "img_uber"),#imageLiteral(resourceName: "img_lyft"),#imageLiteral(resourceName: "img_shuttle"),#imageLiteral(resourceName: "img_taxi"),#imageLiteral(resourceName: "img_waze"),#imageLiteral(resourceName: "img_map")]
    var titleBarText: String = ""
    var selectedMenu : Menu = Menu()
    var isRequestForCar:Bool = false
    var finalDestination : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var finalAddress = "5250%20International%20Dr,%20Orlando,%20FL%2032819,%20USA" //"14401%20NE%2019th%20Ave,%20North%20Miami,%20FL%2033181,%20United%20States"//"18001%20Collins%20Avenue%20Sunny%20Isles%20Beach%2C%20FL%2033160"
    

    var hotelLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var hotelAddress = "5250%20International%20Dr,%20Orlando,%20FL%2032819,%20USA" //"14401%20NE%2019th%20Ave,%20North%20Miami,%20FL%2033181,%20United%20States"//"18001%20Collins%20Avenue%20Sunny%20Isles%20Beach%2C%20FL%2033160"
    var airportLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var airportAddress = "2100%20NW%2042nd%20Ave%2C%20Miami%2C%20FL%2033126%2C%20USA"
    var airportLocation2 : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var airportAddress2 = "100%20Terminal%20Dr%2C%20Fort%20Lauderdale%2C%20FL%2033315%2C%20USA"

    var destination : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var destinationAddress = ""
    
    var uberDeeplink = ""
    var lyftDeepLink = ""
    var wazeDeepLink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         Helper.logScreen(screenName: "Directions Hotel / Airport screen", className: "DateTimeVC")
        // Do any additional setup after loading the view.
        for i in 0..<6 {
            let menu = Menu()
            menu.label = labelArray[i]
            menu.cellImage = imageArray[i]
            menuArray.append(menu)
        }

        //Dezerland park miami
        hotelLocation.latitude = 28.468698//25.943015
        hotelLocation.longitude = -81.448272//-80.121140
        //Miami International Airport
        airportLocation.latitude = 25.795071
        airportLocation.longitude = -80.277735
        
        //Miami International Airport2
        airportLocation2.latitude = 26.0742344
        airportLocation2.longitude = -80.1506022
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = titleBarText.replacingOccurrences(of: "\n", with: " ")
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back

        if selectedMenu.isAirport == true{
            finalDestination = airportLocation
            finalAddress = airportAddress
            getAirport()
        }
        else{
            finalDestination = hotelLocation
            finalAddress = hotelAddress
        }
        
        setFinalDestination()
        
    }
    func getAirport() {
        let controller = UIAlertController.init(title: "Which airport are you traveling to?", message: nil, preferredStyle: .actionSheet)
        let airport1 = UIAlertAction.init(title: "Miami International Airport (MIA)", style: .default) { (action) in
            self.finalDestination = self.airportLocation
            self.finalAddress = self.airportAddress
            self.setFinalDestination()
        }
        controller.addAction(airport1)
        let airport2 = UIAlertAction.init(title: "Fort Lauderdale International Airport (FLL)", style: .default) { (action) in
            self.finalDestination = self.airportLocation2
            self.finalAddress = self.airportAddress2
            self.setFinalDestination()
        }
        controller.addAction(airport2)
        
        self.present(controller, animated: true, completion: nil)
    }
    func setFinalDestination() {
        self.destination = finalDestination
        self.destinationAddress = finalAddress
        setLinks()
    }
    func setLinks() {
        //Setup Uber link
        uberDeeplink = String(format:"uber://?client_id=%@&action=setPickup&pickup=my_location&dropoff[formatted_address]=%@&dropoff[latitude]=%f&dropoff[longitude]=%f", UBER.CLIENT_ID, destinationAddress, destination.latitude, destination.longitude)
        
        //Setup lyft link
        lyftDeepLink = String(format: "lyft://ridetype?id=lyft&destination[latitude]=%f&destination[longitude]=%f&partner=%@",destination.latitude, destination.longitude, LYFT.CLIENT_ID)
        
        //Setup waze link
        wazeDeepLink = String(format: "https://waze.com/ul?ll=%f,%f&navigate=yes", destination.latitude, destination.longitude)
        
        if isRequestForCar{
            //Setup Uber link
            uberDeeplink = String(format:"uber://?client_id=%@&action=setPickup&pickup[formatted_address]=%@&pickup[latitude]=%f&pickup[longitude]=%f", UBER.CLIENT_ID, hotelAddress, hotelLocation.latitude, hotelLocation.longitude)
            
            //Setup lyft link
            lyftDeepLink = String(format: "lyft://ridetype?id=lyft&pickup[latitude]=%f&pickup[longitude]=%f&partner=%@",hotelLocation.latitude, hotelLocation.longitude, LYFT.CLIENT_ID)
            
            //Setup waze link
            wazeDeepLink = String(format: "https://waze.com/ul?ll=%f,%f&navigate=yes", destination.latitude, destination.longitude)
        }
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

    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            objAlert.delegate = nil
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.present(objAlert, animated: false) {
            }
        })
    }
    
}

extension DirectionsMenuVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, RequestCarDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = Device.SCREEN_WIDTH/2 //Display Two elements in a row.
        collectionViewSize.height = Device.SCREEN_WIDTH/2 - Device.SCREEN_WIDTH/6
        return collectionViewSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        var size : CGSize = CGSize(width: 0, height: 0)
        if isRequestForCar{
            size = CGSize(width: Device.SCREEN_WIDTH, height: 170)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CELL_IDENTIFIER.REQUEST_CAR_HEADER, for: indexPath as IndexPath) as! RequestCarReusableView
        headerView.configureHeader()
        headerView.delegate = self
        return headerView
    }
    
    // MARK: - UICollectionView Delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return menuArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.DIRECTIONS, for: indexPath as IndexPath) as! DirectionsCell
        cell.configureCell(indexPath: indexPath, menuObj:menuArray[indexPath.row])
        
        //cell.myLabel.text = self.challenges[indexPath.item]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0://Open Uber
            if UIApplication.shared.canOpenURL(NSURL(fileURLWithPath: "uber://") as URL) {
                UIApplication.shared.openURL(URL(string: String(format: "%@", uberDeeplink))!)
                // Uber app is installed, construct and open deep link.
            } else {
                // No Uber app, open the mobile site.
                UIApplication.shared.openURL(URL(string: String(format: "itms://itunes.apple.com/us/app/uber/id368677368?mt=8"))!)
            }
        case 1://Open lyft
            if UIApplication.shared.canOpenURL(NSURL(fileURLWithPath: "lyft://") as URL) {
                UIApplication.shared.openURL(URL(string: String(format: "%@", lyftDeepLink))!)
            } else {
                UIApplication.shared.openURL(URL(string: String(format: "itms://itunes.apple.com/us/app/lyft/id529379082?mt=8"))!)
            }
        case 2://open Super Shuttle
            if UIApplication.shared.canOpenURL(NSURL(fileURLWithPath: "supershuttle://") as URL) {
                 UIApplication.shared.openURL(URL(string: String(format: "supershuttle://"))!)
            } else {
                UIApplication.shared.openURL(URL(string: String(format: "itms://itunes.apple.com/us/app/supershuttle-execucar/id376771013?mt=8"))!)
            }
        case 3:// Open Taxi
            if UIApplication.shared.canOpenURL(NSURL(fileURLWithPath: "taximagic://") as URL) {
                UIApplication.shared.openURL(URL(string: String(format: "taximagic://"))!)
                // curb app is installed, construct and open deep link.
            } else {
                // No curb app, open the mobile site.
                UIApplication.shared.openURL(URL(string: String(format: "itms://itunes.apple.com/us/app/curb-the-taxi-app/id299226386?mt=8"))!)
            }
        case 4:// Open Waze
            if UIApplication.shared.canOpenURL(NSURL(fileURLWithPath: "waze://") as URL) {
                UIApplication.shared.openURL(URL(string: String(format: "%@", wazeDeepLink))!)
                // Uber app is installed, construct and open deep link.
            } else {
                // No Uber app, open the mobile site.
                UIApplication.shared.openURL(URL(string: String(format: "itms://itunes.apple.com/us/app/waze-navigation-live-traffic/id323229106?mt=8"))!)
            }
        case 5:
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                if isRequestForCar{
                    UIApplication.shared.openURL(URL(string: String(format: "http://maps.google.com/?saddr=%@&directionsmode=drive", hotelAddress))!)
                }else{
                    UIApplication.shared.openURL(URL(string: String(format: "http://maps.google.com/?daddr=%@&directionsmode=drive", destinationAddress))!)
                }
            }else if UIApplication.shared.canOpenURL(NSURL(fileURLWithPath: "maps://") as URL) {
                // Map app is installed, construct and open deep link.
                if isRequestForCar{
                    UIApplication.shared.openURL(URL(string: String(format: "http://maps.apple.com/?saddr=%@&&dirflg=d", hotelAddress))!)
                }else{
                    UIApplication.shared.openURL(URL(string: String(format: "http://maps.apple.com/?daddr=%@&&dirflg=d", destinationAddress))!)
                }
            }
        default:
            break
        }
    }
    
    
//    MARK: Request Car Delegate
    func requestCarWith(ticketNumber : String) {
        
            if ticketNumber.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
                self.showMessage(number: ticketNumber)
//                let dict = ["valet_number":ticketNumber]
                
//                DispatchQueue.main.async(execute: {
//                    self.activateView(self.view, loaderText: LOADER_TEXT.loading)
//                })
//                let bizObject = BusinessLayer()
//                bizObject.requestCar(obj: dict as NSDictionary, {status, title, message in
//                    DispatchQueue.main.async(execute: {
//                        self.deactivateView(self.view)
//                    })
//                    if status {
//                        var alertTitle = ""
//                        var alertMessage = ""
//                        if title == "" {
//                            alertTitle = "Request Accepted."
//                        }
//                        else{
//                            alertTitle = title
//                        }
//                        if message == ""{
//                            alertMessage = "Your request for car has been accepted."
//                        }
//                        else{
//                            alertMessage = message
//                        }
//                        self.showConfirmationDialog(title: alertTitle, message: alertMessage)
//                    }
//                    else{
//                        Helper.showAlert(sender: self, title: title, message: message)
//                    }
//
//                })
            }
        
    }
    func showMessage(number : String) {
        if !MFMessageComposeViewController.canSendText() {
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Your device doesn't support SMS!")
        }
            let receiver = [Helper.getValetNumber()]
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
            controller.recipients = receiver
            controller.body = number
            self.present(controller, animated: true, completion: nil)
    }
    
    
}
extension DirectionsMenuVC : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            break
        case .failed:
            break
        case .sent:
            break
        }
        controller.dismiss(animated: true, completion: nil)
 
    }
}




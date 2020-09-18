//
//  BookingDayVC.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 9/26/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class BookingDayVC: BaseViewController, AlertVCDelegate  {
    
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var btn_previous: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var tbl_list: UITableView!
    @IBOutlet weak var btn_increment: UIButton!
    @IBOutlet weak var lbl_totalKids: UILabel!
    @IBOutlet weak var btn_decrement: UIButton!
    @IBOutlet weak var lbl_numberOfKids: UILabel!
    @IBOutlet weak var btn_reserve: UIButton!
    @IBOutlet var view_top: UIView!
    @IBOutlet weak var lbl_dailyEvent: UILabel!
    
    var dateArray : [DateModel] = []
    var menuArray : [Menu] = []
    var department : [Department]?
    var showingArray : [Menu] = []
    var selectedMenu : Menu = Menu()
    var selectedIndex : Int = 1
    var totalPerson = 1
    var titleBarText: String? = "Planet Kids"
    var isModification = false
    var tableCellType : CellType = .none
    var reservationModel : ReservationModel?
    var centrePoint : CGPoint = CGPoint(x: 0, y: 0)
    var centerIndexPath : IndexPath = IndexPath(row: 1, section: 0)
    var room_number : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_dailyEvent.text = TITLE.DailyEvent
        dateArray = getDateArray(date: "")
        dayCollectionView.reloadData()
        
        tbl_list.separatorColor = .clear
        view_top.addBorder(color: .white)
        if let dept = department?.first {
            if let items = dept.items {
                self.menuArray = items
            }
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Planet Kids"
        
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        scrollToIndex(index: 1)
        
        lbl_totalKids.text = "\(totalPerson)"
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: PERSON ACTIONS
    @IBAction func actionDecrement(_ sender: UIButton) {
        if totalPerson > 1 {
            totalPerson = totalPerson - 1
        }
        lbl_totalKids.text = "\(totalPerson)"

    }
    
    @IBAction func actionIncrement(_ sender: UIButton) {
        totalPerson = totalPerson + 1
        lbl_totalKids.text = "\(totalPerson)"

    }
    
    //MARK: DAYS ACTIONS
    @IBAction func nextDateAction(_ sender: UIButton) {
        nextDateSelected()
    }
    @IBAction func previousDateAction(_ sender: UIButton) {
        previousDateSelected()
    }
    
    func nextDateSelected(){
        
        if dateArray.count > selectedIndex {
            if selectedIndex + 1 == (dateArray.count - 1) {
                return
            }
            self.updateDateArray(index: selectedIndex + 1)
            scrollToIndex(index: selectedIndex)
            
        }
        
    }
    
    func previousDateSelected(){
        if selectedIndex > 0 {
            if selectedIndex - 1 == 0 {
                return
            }
            self.updateDateArray(index: selectedIndex - 1)
            scrollToIndex(index: selectedIndex)
            
        }
    }
    func getDateArray(date : String) -> [DateModel]{
        var array : [DateModel] = []
       
        let calendar = Calendar.current
        var component = DateComponents()
//        component.day = 1;
//        let currentDate = calendar.date(byAdding: component, to: Date())
        let currentDate = Date()
        
        for i in -1...7 {
            component.day = i;
            let tempDate = calendar.date(byAdding: component, to: currentDate)
            let weekDay = calendar.component(.weekday, from: tempDate!)
            let dt = calendar.component(.day, from: tempDate!)
            let month = calendar.component(.month, from: tempDate!)
            let year = calendar.component(.year, from: tempDate!)
            
            
            let date = DateModel()
            date.weekDayNo = weekDay
            date.date = dt
            date.monthNo = month
            date.yearNo = year
            //            date.month = months[i]
            if tempDate == currentDate  {
                date.isSelected = true
            }
            else{
                date.isSelected = false
            }
            array.append(date)
        }
        return array
    }
    func updateDateArray(index : Int){
        for date in dateArray {
            date.isSelected = false
        }
        selectedIndex = index
        dateArray[selectedIndex].isSelected = true
    }
    
    @IBAction func reserveAction(_ sender: UIButton) {
        self.showRoomDialog(model: ReservationModel())
    }
    
    func reserve() {
        if let disclaimer = selectedMenu.disclaimer {
            let controller = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.DisclaimerVC) as! DisclaimerVC
            controller.disclaimerText = disclaimer
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            makeReservation()
        }
    }
    func makeReservation() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        
        let bizObject = BusinessLayer()
        let model : ReservationModel = ReservationModel()
        model.module_id = selectedMenu.module_id
        model.department_id = selectedMenu.department_Id
        model.discount = selectedMenu.discount
        model.items = []
        model.number_of_people = totalPerson
        model.appointment_date = getDateTime()
        model.room_number = self.room_number
        if isModification == true {
            model.isModification = true
            model._id = selectedMenu.order_Id
            bizObject.modifyReservation(obj: model, isOrder: false, { (status, reservationModel,title,message) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                })
                if status{
                    if let model = reservationModel {
                        self.reservationModel = model
                    }
                    self.showConfirmationDialog(title: title, message : message)
                }
                else {
                    Helper.showAlert(sender: self, title: title, message: message)
                }
            })
        }
        else{
            bizObject.reservation(obj: model, isOrder: false, { (status, reservationModel,title,message) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                })
                if status{
                    if let model = reservationModel {
                        self.reservationModel = model
                    }
                    self.showConfirmationDialog(title: title, message : message)
                }
                else {
                    Helper.showAlert(sender: self, title: title, message: message)
                }
            })
        }
    }
    func showRoomDialog(model : ReservationModel){
        if let room_number = Helper.getRoomNumber(), room_number != "" {
            model.room_number = room_number
            self.room_number = room_number
            self.reserve()
        }
        else {
            let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SelectChairVC") as! SelectChairVC
            objUpgrade.delegate = self
            objUpgrade.titleBarText = self.titleBarText
            objUpgrade.showRoom = true
            objUpgrade.reservationModel =  model
            objUpgrade.alreadyReserved = model.isModification
            objUpgrade.alertText = ALERTSTRING.ROOM_NUMBER
            self.definesPresentationContext = true
            objUpgrade.modalPresentationStyle = .overCurrentContext
            objUpgrade.modalTransitionStyle = .crossDissolve
            objUpgrade.view.backgroundColor = .clear
            DispatchQueue.main.async(execute: {
                self.navigationController?.present(objUpgrade, animated: true, completion: nil)
            })
        }
        
    }
    func getDateTime() -> String {
        let date = dateArray[selectedIndex]
        let calendar = Calendar.current
        return "\(calendar.component(.year, from: Date()))-\(date.monthNo)-\(date.date) \(Helper.getStringFromDate(format: DATEFORMATTER.H_MM, date: Date()))"
    }
    
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            objAlert.delegate = self
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.present(objAlert, animated: false) {
            }
        })
    }
    
    func alertDismissed(){
        
        let controller : PlanetKidsOrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: "PlanetKidsOrderVC") as! PlanetKidsOrderVC
        controller.titleBarText = titleBarText
        controller.reservation = self.reservationModel
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(controller, animated: true)
        })
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
extension BookingDayVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, DisclaimerDelegate{
   
    //    MARK: Collection Delegates And Datasources
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.DATECELL, for: indexPath) as! DateCollectionCell
        
        let date = dateArray[indexPath.row]
        cell.configureWeekDayCell(date: date)
        if date.isSelected {
            selectedIndex = indexPath.row
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 4)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centrePoint = CGPoint(x:(scrollView.center.x + scrollView.contentOffset.x),y:(scrollView.center.y))
        print (centrePoint)
        updateCollectionView(point : centrePoint)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            centrePoint = CGPoint(x:(scrollView.center.x + scrollView.contentOffset.x),y:(scrollView.center.y))
            print (centrePoint)
            updateCollectionView(point : centrePoint)
        }
    }
    func updateCollectionView(point : CGPoint) {
        if let pt = dayCollectionView.indexPathForItem(at: point) {
            centerIndexPath = pt
            selectedIndex = centerIndexPath.row

            print (centerIndexPath)
            updateDateArray(index: selectedIndex)
            scrollToIndex(index: selectedIndex)
        }
    }
    func scrollToIndex(index : Int){
        let indexPath = IndexPath.init(row: index, section: 0)
        if let day = dateArray[index].weekDay {
            showingArray = menuArray.filter({
                $0.daysArray.contains(day.lowercased())
            })
        }
        print(showingArray)
        tbl_list.reloadData()
        dayCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        dayCollectionView.reloadData()
    }
        
//    MARK: TABLE VIEW DELEGATES AND DATASOURCES
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CustomTableCell()
        cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CUSTOM_CELL) as! CustomTableCell
        cell.configureCellForPlanetKids(menuObj: showingArray[indexPath.row] ,type : tableCellType )
        return cell
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //    MARK: Disclaimer Delegate
    func disclaimerAgreed(){
        makeReservation()
    }
}
extension BookingDayVC : SelectChairVCDelegate {
    func fillRoom(alohaOrderModel: AlohaOrder, reservationModel: ReservationModel, controller: UIViewController) {
        
    }
    
    //    MARK: Select Chair Dialog
    func selectedRoom(model : ReservationModel,controller : UIViewController) {
        controller.dismiss(animated: true, completion: {
            self.room_number = model.room_number
            self.reserve()
        })
    }
    func selectedChair(model: ReservationModel, controller: UIViewController) {
        //        for later use
    }
    
    func selectedQuantity(quantity: Int) {
        //        for later use
    }
    
}

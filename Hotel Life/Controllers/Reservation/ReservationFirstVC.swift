//
//  ReservationFirstVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 10/06/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit
import FSCalendar

class ReservationFirstVC: BaseViewController {
    
    @IBOutlet weak var tableView : UITableView?
    var titleValue : String? = "Reservation"
    
    var itemPicker: UIPickerView? = UIPickerView()
    var ocationPicker: UIPickerView? = UIPickerView()
    var durationArr = ["1 Hour","2 Hours","3 Hours","4 Hours","5 Hours","6 Hours","7 Hours","8 Hours","9 Hours","10 Hours","11 Hours","12 Hours"]
    
    var occationArr = ["Birthday","Anniversary","Party"]
    var bowlingTFPlaceHolderArr = ["Select Duration","", "Select Ocation","Select no. of people"]
    
    
    
   
    @IBOutlet weak var btnGoBack: UIButton?
    @IBOutlet weak var btnNext: UIButton?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title : titleValue ?? "Reservation")
        self.setLocalizeStringToParameters()
        self.setDurationPicker()

        // Do any additional setup after loading the view.
    }
    
    private func setDurationPicker(){

          itemPicker?.delegate = self
          itemPicker?.dataSource = self
          ocationPicker?.delegate = self
          ocationPicker?.dataSource = self
          
    }
    
    private func setLocalizeStringToParameters(){
        btnGoBack?.setTitle(BUTTON_TITLE.Go_Back, for: .normal)
        btnNext?.setTitle(BUTTON_TITLE.Next, for: .normal)
        //txtChooseDuration?.placeholder = PLACEHOLDER.choose_duration
    }
    
    @IBAction func goBackAction(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender:UIButton) {
        
        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ReservationSecondVC) as? ReservationSecondVC{
            vc.titleValue = titleValue!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}

extension ReservationFirstVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0, 2, 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.textFieldCell, for: indexPath as IndexPath) as! TextFieldCell
            cell.indeXValue = indexPath.row
            cell.setBorder()
            
            let formName = "\(bowlingTFPlaceHolderArr[indexPath.row])"
            cell.selectionStyle = .none
                       
            cell.textField?.placeholder = formName
            cell.textField?.delegate = self
            cell.textField?.tag = indexPath.row
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.dateTimeCell, for: indexPath as IndexPath) as! DateTimeCell
            cell.setBorder()
            
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    
}


//MARK: UItextFields delegate methods

extension ReservationFirstVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textField.inputView = itemPicker
        case 2:
            textField.inputView = ocationPicker
        case 3:
            textField.inputView = nil
            textField.keyboardType = .numberPad
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 3:
            if (string == " ") {
                return false
            }
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            //textField.text = newString
        default:
            break
        }
        return true
    }
    
}







//MARK: Pickerview datasource and delegate methods
extension ReservationFirstVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case itemPicker:
            return durationArr.count
        case ocationPicker:
            return occationArr.count
        default:
            return durationArr.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case itemPicker:
            return durationArr[row]
        case ocationPicker:
            return occationArr[row]
        default:
            return durationArr[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch pickerView {
        case itemPicker:
            let indexPath = NSIndexPath(row: 0, section: 0)
            if let cell  = self.tableView?.cellForRow(at: indexPath as IndexPath) as? TextFieldCell{
                cell.textField?.text = durationArr[row]
            }
        case ocationPicker:
            let indexPath = NSIndexPath(row: 2, section: 0)
            if let cell  = self.tableView?.cellForRow(at: indexPath as IndexPath) as? TextFieldCell{
                cell.textField?.text = occationArr[row]
            }
        default:
            break
        }
        
        
    }
    
}

//MARK: FSCalender Datasource and  delegate methods
extension ReservationFirstVC: FSCalendarDataSource, FSCalendarDelegate{
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}






//MARK: Text fields tableview cell class
class TextFieldCell : UITableViewCell{
    
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var backImageView: UIImageView?
    var indeXValue : Int? = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBorder(){
        
        switch indeXValue {
        case 0:
            self.backImageView?.borders(for: [.left, .right, .top, .bottom], width: 1, color: .gray)

        case 2:
            self.backImageView?.borders(for: [.left, .right], width: 1, color: .gray)

        case 3:
            self.backImageView?.borders(for: [.left, .right, .bottom], width: 1, color: .gray)

        default:
            break
        }
    }
    
}




//MARK: Date time tableview cell class
class DateTimeCell: UITableViewCell{
    
    @IBOutlet weak var lblChooseDate: UILabel?
    @IBOutlet weak var lblChooseTime: UILabel?
    @IBOutlet weak var calenderView: FSCalendar?
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var backView: UIView?
    @IBOutlet weak var collectionBackView: UIView?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLocalizeStringToParameters()
        collectionBackView?.addBorder(color: .lightGray)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        collectionBackView?.addBorder(color: .lightGray)


        // Configure the view for the selected state
    }
    
    func setBorder(){
        self.backView?.borders(for: [.left, .right], width: 1, color: .gray)
    }
    
    func setLocalizeStringToParameters(){
      lblChooseDate?.text = TITLE.ChooseDate
      lblChooseTime?.text = TITLE.ChooseTime
    }
    
    
    @IBAction func nextMonthAction(_ sender:UIButton) {
        calenderView?.setCurrentPage(getNextMonth(date: calenderView?.currentPage ?? Date()), animated: true)
    }

    @IBAction  func previousTapped(_ sender:UIButton) {
        calenderView?.setCurrentPage(getPreviousMonth(date: calenderView?.currentPage ?? Date()), animated: true)
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }

    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
}








//MARK: collectionview delegate and datasource methods from  DateTimeCell
extension DateTimeCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.addBorder(color: .lightGray)
        return cell
        
        //return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/2.0
        //let yourHeight = yourWidth

        return CGSize(width: yourWidth - 7 , height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .systemYellow
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
    }
    
    
}




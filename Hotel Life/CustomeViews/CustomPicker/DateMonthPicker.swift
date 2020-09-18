//
//  DateMonthPicker.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 03/10/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class DateMonthPicker: UIPickerView {
    var monthArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var daysArray : [String] = []
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    var month = ""
    var day = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
        //setDate(Date(), animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDate(_ date : Date, animated : Bool) {
        
        let monthNo = calendar.component(.month, from: date)
        let dayNo = calendar.component(.day, from: date)
        daysArray = getDays(monthNo: monthNo)
        self.reloadAllComponents()
        if (monthNo - 1) < monthArray.count {
            month = monthArray[monthNo - 1]
        self.selectRow(monthNo - 1, inComponent: 0, animated: animated)
        }
        if (dayNo - 1) < daysArray.count {
            day = daysArray[dayNo - 1]
            self.selectRow(dayNo - 1, inComponent: 1, animated: animated)
        }
        print(month, day)
    }
    
    func getDays(monthNo : Int) -> [String]{
        
        let year = calendar.component(.year, from: Date())
        dateComponents.year = year
        dateComponents.month = monthNo
        
        let date = calendar.date(from: dateComponents)
        let cal = Calendar(identifier: .gregorian)
        let monthRange = cal.range(of: .day, in: .month, for: date!)!
        var daysInMonth = monthRange.count
        if monthNo == 2 {
            daysInMonth = 29
        }
        daysArray.removeAll()
        for i in 1...daysInMonth {
            daysArray.append("\(i)")
        }
        return daysArray
    }
    
    func getDateString() -> String{
        // this works properly if you have already set the date first
        return "\(month) \(day)"
    }
    
    func getCompleteDateString(dateStr:String) -> String? {
//        like "25-03-1993"
        var selectedMonth = 1
        var selectedDate = 01
        let dateArr = dateStr.components(separatedBy: " ")
        if dateArr.count > 1 {
            if let monthIndex = monthArray.index(of: dateArr.first!)  {
                selectedMonth = monthIndex + 1
            }
            if let date = dateArr.last as NSString? {
                selectedDate = date.integerValue
            }
            dateComponents.day = selectedDate
            dateComponents.month = selectedMonth
            if let finalDate = calendar.date(from: dateComponents) {
                print(finalDate)
                return Helper.getStringFromDate(format: DATEFORMATTER.DD_MM_YYYY, date: finalDate)
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

}
extension DateMonthPicker : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0://Month
            return monthArray.count
        case 1://Day
            return daysArray.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return monthArray[row]
        case 1:
//            if daysArray.count < row {
//                return daysArray[row]
//            }
            return daysArray[row]
//            fallthrough
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0://Month
            month = monthArray[row]
            daysArray = getDays(monthNo: row+1)
            self.reloadComponent(1)
        case 1://Day
            day = daysArray[row]
        default: break

        }
    }

}

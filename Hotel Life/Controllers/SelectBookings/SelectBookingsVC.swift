//
//  SelectBookingsVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 07/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol SelectBookingDelegate {
    func selectedBooking(booking : Booking?, controller : SelectBookingsVC)
}
class SelectBookingsVC: UIViewController {

    @IBOutlet weak var tbl_booking: UITableView!
    @IBOutlet weak var bgView: UIView!
//    @IBOutlet weak var lbl_checkin: UILabel!
//    @IBOutlet weak var lbl_select: UILabel!
    
    var delegate : SelectBookingDelegate?
    var bookings : [Booking] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.addBorder(color: .white)
        Helper.logScreen(screenName : "Choose/Select Booking", className : "SelectBookingsVC")

        // Do any additional setup after loading the view.
    }
    @IBAction func dismissAction(_ sender: Any) {
        delegate?.selectedBooking(booking: nil, controller: self)
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
extension SelectBookingsVC : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell : CustomTableCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.HEADER_CELL) as! CustomTableCell
            cell.lbl_headerTitle.text = "Check in \n Multiple users with the same name found. Select yourself to check in."
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CELL) as! BookingCell
        cell.booking = bookings[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedBooking(booking: bookings[indexPath.row], controller: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

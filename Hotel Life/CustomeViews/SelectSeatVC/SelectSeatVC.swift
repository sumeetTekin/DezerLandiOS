//
//  SelectSeatVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 26/11/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol SelectSeatVCDelegate {
    func selectedSeat(model : ReservationModel?)
}
class SelectSeatVC: UIViewController {
   
    @IBOutlet weak var lblPickSection: UILabel!
    @IBOutlet weak var seatCollectionLeft: UICollectionView!
    @IBOutlet weak var seatSelectionRight: UICollectionView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var lblNote: UILabel!
    
//    @IBOutlet weak var rightView: UIView!
//    @IBOutlet weak var leftView: UIView!
    var delegate : SelectSeatVCDelegate?
    var reservationModel : ReservationModel?
    var arrayLeft : [String] = ["E-5", "E-4", "E-3", "E-2", "E-1","C-5", "C-4", "C-3", "C-2", "C-1","A-5", "A-4", "A-3", "A-2", "A-1"]
    var arrayRight : [String] = ["F-1", "F-2", "F-3", "F-4", "F-5","D-1", "D-2", "D-3", "D-4", "D-5","B-1", "B-2", "B-3", "B-4", "B-5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteView.layer.cornerRadius = 10
        noteView.layer.borderColor = COLORS.LIGHTBLUE_SEAT.cgColor
        noteView.layer.borderWidth = 2
        lblNote.text = TITLE.beachNote
        lblPickSection.text = TITLE.pickSection.uppercased()
//        rightView.cornerRadius(cornerRadius: self.rightView.frame.width/2)
//        leftView.cornerRadius(cornerRadius: self.leftView.frame.width/2)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
      // kAppDelegate.shouldRotate = true
           AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft, andRotateTo: UIInterfaceOrientation.landscapeRight)
      // UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
//        kAppDelegate.shouldRotate = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        headerImage.isHidden = true
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

  

      //  kAppDelegate.shouldRotate = false
      //  UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SelectSeatVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.seatCollectionLeft {
            return arrayLeft.count
        }
        else {
            return arrayRight.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.SEAT_CELL, for: indexPath) as! SeatCell
       
        if collectionView == self.seatCollectionLeft {
            cell.seatTitle.text = arrayLeft[indexPath.row]
        }
        else {
            cell.seatTitle.text = arrayRight[indexPath.row]
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.height < 375{
            return CGSize(width: collectionView.frame.width/5 - 8, height:  collectionView.frame.height/3 - 5)
        }
        return CGSize(width: collectionView.frame.width/5 - 10, height:  collectionView.frame.height/3 - 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if UIScreen.main.bounds.height < 375{
            return 7
        }
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         if UIScreen.main.bounds.height < 375{
            return 8
        }
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.seatCollectionLeft {
           let seat = arrayLeft[indexPath.row]
            reservationModel?.beach_location = seat
            delegate?.selectedSeat(model: reservationModel)
        }
        else {
            let seat = arrayRight[indexPath.row]
            reservationModel?.beach_location = seat
            delegate?.selectedSeat(model: reservationModel)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
}

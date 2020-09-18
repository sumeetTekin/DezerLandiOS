//
//  CarDetailVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 15/06/20.
//  Copyright © 2020 jasvinders.singh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CarDetailVC: BaseViewController {
    
    
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var btnGoBack: UIButton?
    
    @IBOutlet weak var tableViewHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var headerBackImage: UIImageView!
    @IBOutlet weak var lblCarName: UILabel!
    
    var qrCodeDetail : QRCodeData?
    var count = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "Car Details")
        
        headerBackImage.borders(for: [.top, .left, .right], width: 1, color: .gray)
        lblCarName.text = qrCodeDetail?.name
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  var tableViewHeight:CGFloat = 0;
        //        for (var i = tableView(self.tableView , numberOfRowsInSection: 0) - 1; i>0; i-=1 ){
        //            tableViewHeight = height + tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0) )
        //        }
        //        tableViewHeightLayout.constant = tableViewHeight
        self.tableView?.backgroundColor = .clear
        self.view.layoutIfNeeded()
        self.tableViewHeightLayout.constant = CGFloat(self.tableView?.contentSize.height ?? 0)
    }
    
    
    
    @IBAction func gobackAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    
    
}

extension CarDetailVC : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if qrCodeDetail?.images?.count != 0 && qrCodeDetail?.videos?.count != 0{
            count = 3
        }
        else if qrCodeDetail?.images?.count == 0 && qrCodeDetail?.videos?.count == 0{
            count = 1
        }
        else if qrCodeDetail?.images?.count == 0 || qrCodeDetail?.videos?.count == 0{
            count = 2
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CarDetailCell, for: indexPath as IndexPath) as! CarDetailCell
            cell.setCarDetail(carData: qrCodeDetail)
            return cell
        case 1:
            if count == 2 && qrCodeDetail?.videos?.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.ImageCell, for: indexPath as IndexPath) as! CarVideoCell
                cell.isLastContent = true
                cell.imagesArr = qrCodeDetail?.images
                cell.setViewBorder()
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.VideoCell, for: indexPath as IndexPath) as! CarVideoCell
                cell.isVideoCell = true
                cell.videoArr = qrCodeDetail?.videos
                cell.touchUp = { index in
                    if let url = URL(string: self.qrCodeDetail?.videos?[index] ?? "https://www.videvo.net/videvo_files/converted/2015_03/videos/BirdNoSound.mp480023.mp4"){
                        self.playVideo(url: url)
                    }else{
                        Helper.showAlert(sender: self, title: "Error", message: "Un-supported video link")
                    }
                    
                }
                cell.setViewBorder()
                return cell
                
            }
            
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.ImageCell, for: indexPath as IndexPath) as! CarVideoCell
            cell.isLastContent = true
            cell.imagesArr = qrCodeDetail?.images
            cell.setViewBorder()
            return cell
            
        default:
            
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row <= 2 ? UITableViewAutomaticDimension : 0
    }
}

class CarDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblModel: UILabel?
    @IBOutlet weak var lblMake: UILabel?
    @IBOutlet weak var lblYear: UILabel?
    @IBOutlet weak var lblBodyStyle: UILabel?
    @IBOutlet weak var lblTransmission: UILabel?
    @IBOutlet weak var lblMovie: UILabel?
    
    @IBOutlet weak var lblModelValue: UILabel?
    @IBOutlet weak var lblMakeValue: UILabel?
    @IBOutlet weak var lblYearValue: UILabel?
    @IBOutlet weak var lblBodyStyleValue: UILabel?
    @IBOutlet weak var lblTransmissionValue: UILabel?
    @IBOutlet weak var lblMovieValue: UILabel?
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setLocalizeStringToParameters()
        backgroundImage.borders(for: [.left, .right], width: 1, color: .gray)
        
        // Configure the view for the selected state
    }
    
    private func setLocalizeStringToParameters(){
        // btnGoBack?.setTitle(BUTTON_TITLE.Go_Back, for: .normal)
        
        lblModel?.text = TITLE.modelTitle
        lblMake?.text = TITLE.makeTitle
        lblYear?.text = "Room:"//TITLE.yearTitle
        lblBodyStyle?.text = TITLE.bodyStyleTitle
        lblTransmission?.text = TITLE.description
        lblMovie?.text = TITLE.movieTitle
        
    }
    
    func setCarDetail(carData : QRCodeData?){
        if let detail = carData{
            lblModelValue?.text = detail.model
            lblMakeValue?.text = detail.make
            lblYearValue?.text = detail.room
            lblTransmissionValue?.text = detail.description
            
            lblMovieValue?.isHidden = true
            lblBodyStyleValue?.isHidden = true
            
        }
        
    }
    
}

class CarVideoCell: UITableViewCell {
    
    @IBOutlet weak var collectioView: UICollectionView?
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    var isVideoCell : Bool = false
    var videoArr : [String]?
    var imagesArr : [String]?
    
    var isLastContent : Bool? = false
    
    var touchUp: ((_ indexValue: Int) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectioView?.delegate = self;
        self.collectioView?.dataSource = self;
        self.collectioView?.register(UINib(nibName: "YoutubeCell", bundle: nil), forCellWithReuseIdentifier: "YoutubeCell")
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setViewBorder(){
        if isLastContent ?? false{
            backgroundImage.borders(for: [.left, .right, .bottom], width: 1, color: .gray)
        }else{
            backgroundImage.borders(for: [.left, .right, ], width: 1, color: .gray)
        }
    }
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    
    
}








extension CarVideoCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isVideoCell == true ? videoArr?.count as! Int : imagesArr?.count as! Int
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        
        
        
        if let urlStr = self.videoArr?[indexPath.item] as? String, (urlStr.contains(find: "youtube") && isVideoCell == true){
            let cell : YoutubeCell = collectioView?.dequeueReusableCell(withReuseIdentifier: "YoutubeCell", for: indexPath) as! YoutubeCell
            let myVideoURL = NSURL(string: urlStr)
            cell.playerView.loadVideoURL(myVideoURL! as URL)
            cell.addBorder(color: .lightGray)
            return cell
        }else{
            
            
            if isVideoCell == true{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = UIColor.clear
                
                let playBtn = cell.viewWithTag(9) as? UIButton
                playBtn?.isHidden = true
                if let imageView = cell.viewWithTag(10) as? UIImageView{
                    
                    
                    DispatchQueue.global(qos: .background).async {
                        print("This is run on the background queue")
                        
                        //                    if let url = URL(string: "https://www.videvo.net/videvo_files/converted/2015_03/videos/BirdNoSound.mp480023.mp4"){
                        if let url = URL(string: self.videoArr?[indexPath.item] ?? "https://www.videvo.net/videvo_files/converted/2015_03/videos/BirdNoSound.mp480023.mp4"){
                            if let thumbnailImage = self.getThumbnailImage(forUrl: url){
                                DispatchQueue.main.async {
                                    print("This is run on the main queue, after the previous code in outer block")
                                    imageView.image = thumbnailImage
                                    playBtn?.isHidden = false
                                }
                            }
                        }
                        
                    }
                    
                }
                
                cell.addBorder(color: .lightGray)
                return cell
            }
            else{
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageViewCellCell
                cell.backgroundColor = UIColor.clear
                
                
                cell.imageView.sd_setImage(with: URL.init(string:imagesArr![indexPath.row]), placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
                })
                
                cell.buttonPreviousClosure  = { sender in
                    collectionView.scrollToPreviousItem()
                }
                
                cell.buttonNextClosure  = { sender in
                    collectionView.scrollToNextItem()
                }
                
                
                cell.addBorder(color: .lightGray)
                return cell
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        
        return UICollectionViewCell()
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width
        let yourHeight = collectionView.bounds.height
        
        
        return CGSize(width: yourWidth , height: yourHeight)
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //
    //        let totalCellWidth = (collectionView.bounds.width ) * 1
    //        let totalSpacingWidth = 10
    //
    //        let leftInset = (collectionView.bounds.width - CGFloat(CGFloat(totalCellWidth) + CGFloat(totalSpacingWidth))) / 2
    //        let rightInset = leftInset
    //
    //        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    //    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.touchUp?(indexPath.row)
        
    }
    
    
    
    
}

/* paging */
extension CarVideoCell {
    
    /* In case the user scrolls for a long swipe, the scroll view should animate to the nearest page when the scrollview decelerated. */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToPage(scrollView, withVelocity: CGPoint(x:0, y:0))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollToPage(scrollView, withVelocity: velocity)
    }
    
    func scrollToPage(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) {
        let cellWidth: CGFloat = self.collectioView?.bounds.width ?? 0  as CGFloat
        let cellPadding: CGFloat = 10
        
        var page: Int = Int((scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1)
        if velocity.x > 0 {
            page += 1
        }
        if velocity.x < 0 {
            page -= 1
        }
        page = max(page, 0)
        let newOffset: CGFloat = CGFloat(page) * (cellWidth + cellPadding)
        
        scrollView.setContentOffset(CGPoint(x:newOffset, y:0), animated: true)
    }
}





class ImageViewCellCell: UICollectionViewCell {
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var buttonNextClosure : ((UIButton) -> Void)?
    var buttonPreviousClosure : ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func nextAxtion(_ sender : UIButton){
        self.buttonNextClosure!(sender)
    }
    @IBAction func previousAxtion(_ sender : UIButton){
        self.buttonPreviousClosure!(sender)
    }
    
}

extension UICollectionView {

    func scrollToNextItem() {
        let scrollOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width + 10))
        self.scrollToFrame(scrollOffset: scrollOffset)
    }

    func scrollToPreviousItem() {
        let scrollOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width - 10))
        self.scrollToFrame(scrollOffset: scrollOffset)
    }

    func scrollToFrame(scrollOffset : CGFloat) {
        guard scrollOffset <= self.contentSize.width - self.bounds.size.width else { return }
        guard scrollOffset >= 0 else { return }
        self.setContentOffset(CGPoint(x: scrollOffset, y: self.contentOffset.y), animated: true)
    }
}





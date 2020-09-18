//
//  TabImageTitleVC.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 11/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import SDWebImage

protocol SelectedScreen{
    func selectedScreenType(type:Int)
}
class TabImageTitleVC: UIViewController {
    var delegate:SelectedScreen?
    
    //Collection
    var flowLayout : UICollectionViewFlowLayout?
    var collection_slideMenu : UICollectionView?
    var cellIdentifier = "VMSliderMenuCellIdentifier"
    //Scroll
    var scroll_viewControllers : UIScrollView?
    //Data
    var pagesArray : [PageModel] = []
    var menuYOffset : CGFloat = 63
    var headerYOffset : CGFloat = Device.IS_IPHONE_X ? 40 : 0
    var selectedIndex = 0
    var tabMargin : CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout = UICollectionViewFlowLayout()
        flowLayout?.scrollDirection = .horizontal
        collection_slideMenu = UICollectionView.init(frame: CGRect(x:0, y:menuYOffset, width:Device.SCREEN_WIDTH, height:60), collectionViewLayout: flowLayout!)
        collection_slideMenu?.register(UINib.init(nibName: "PageItemCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collection_slideMenu?.delegate = self
        collection_slideMenu?.dataSource = self
        collection_slideMenu?.backgroundColor = COLORS.DARKGREY_COLOR
        collection_slideMenu?.showsHorizontalScrollIndicator = false
        collection_slideMenu?.showsVerticalScrollIndicator = false
        collection_slideMenu?.bounces = false
        collection_slideMenu?.tag = 999
        self.view.addSubview(collection_slideMenu!)
        
        scroll_viewControllers = UIScrollView.init(frame: CGRect(x:(collection_slideMenu?.frame.minX)!, y:(collection_slideMenu?.frame.maxY)!,width:Device.SCREEN_WIDTH, height:self.view.frame.height - (collection_slideMenu?.frame.maxY)! - headerYOffset))
        scroll_viewControllers?.delegate = self
        scroll_viewControllers?.backgroundColor = .clear
        scroll_viewControllers?.bounces = false
        self.view.addSubview(scroll_viewControllers!)
        // Do any additional setup after loading the view.
    }
    func setPageModelArray(_ pages : [PageModel]) {
        self.pagesArray = pages
        scroll_viewControllers?.isPagingEnabled = true
        
        var index : CGFloat = 0
        var frame = CGRect(x: 0, y:0, width:Device.SCREEN_WIDTH, height: (scroll_viewControllers?.frame.height)!)
        for page in self.pagesArray {
            if let controller = page.viewController {
                frame.origin.x = index * Device.SCREEN_WIDTH
                controller.view.frame = frame
                scroll_viewControllers?.addSubview(controller.view)
                index = index + 1
            }
        }
        //Set Content size
        scroll_viewControllers?.contentSize = CGSize(width: Device.SCREEN_WIDTH * CGFloat(pagesArray.count), height: (scroll_viewControllers?.frame.height)!)
        
        //Reload Collection View
        collection_slideMenu?.reloadData()
    }
}
extension TabImageTitleVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    //    MARK: ColectionDelegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PageItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PageItemCell
        let page = pagesArray[indexPath.row]
        cell.lbl_title.text = page.title
        cell.backgroundColor = COLORS.DARKGREY_COLOR
        cell.img_cacheNormal.backgroundColor = .black
        cell.img_cache.backgroundColor = .black
        
        if let image = page.image {
            cell.btn_image.setImage(image, for: .normal)
        }
        else{
            cell.img_cacheNormal.sd_setImage(with: page.imageURL, placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
                DispatchQueue.main.async(execute: {
                    cell.btn_image.setImage(image, for: .normal)
                })
            })
        }
        
        if let image = page.highlightedImage {
           cell.btn_image.setImage(image, for: .selected)
        }
        else{
            cell.img_cache.sd_setImage(with: page.highlightedImageUrl, placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
                DispatchQueue.main.async(execute: {
                    cell.btn_image.setImage(image, for: .selected)
                })
            })
        }
        
        
        if page.isSelected == true {
            cell.view_bar.isHidden = false
            cell.lbl_title.textColor = cell.view_bar.backgroundColor
            cell.btn_image.isSelected = true
        }
        else{
            cell.view_bar.isHidden = true
            cell.lbl_title.textColor = .white
            cell.btn_image.isSelected = false
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        pagesArray[selectedIndex].isSelected = false
        collectionView.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        selectedIndex = index
        pagesArray[index].isSelected = true
        collectionView.reloadItems(at: [indexPath])
        self.collection_slideMenu?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        scroll_viewControllers?.scrollRectToVisible(CGRect(x: CGFloat(index) * Device.SCREEN_WIDTH, y:0, width:Device.SCREEN_WIDTH, height: (scroll_viewControllers?.frame.height)!), animated: true)
        
        //collectionView.reloadData()
    }
    
    //    MARK: Sizes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = pagesArray.count
        var size = CGSize(width: Device.SCREEN_WIDTH / 3 , height: (collection_slideMenu?.frame.height)!)
        if count > 3 {
            size = CGSize(width: Device.SCREEN_WIDTH / 4, height: (collection_slideMenu?.frame.height)!)
        }
        else{
            size = CGSize(width: Device.SCREEN_WIDTH / CGFloat(count), height: (collection_slideMenu?.frame.height)!)
        }
//        if count < 3 {
//            size = CGSize(width: Device.SCREEN_WIDTH / CGFloat(count), height: (collection_slideMenu?.frame.height)!)
//        }
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return tabMargin
    }
    
    //    MARK: ScrollViewDelegate

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.tag == 999 {
            return
        }
        let index = targetContentOffset.pointee.x / Device.SCREEN_WIDTH
//        print(index)
        let indexPath : IndexPath = IndexPath(row: Int(index), section: 0)
        delegate?.selectedScreenType(type: Int(index))
        DispatchQueue.main.async(execute: {
            
            //            TODO: Look for better solution
            self.collection_slideMenu?.delegate?.collectionView!(self.collection_slideMenu!, didSelectItemAt: indexPath)
            self.collection_slideMenu?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })
    }
    
}


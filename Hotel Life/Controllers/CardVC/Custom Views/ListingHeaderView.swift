//
//  ListingHeaderView.swift
//  Kangaroo Propane
//
//  Created by Lokesh Negi on 05/02/2020.
//  Copyright © 2020 Adil Mir. All rights reserved.
//

import UIKit

protocol ListingHeaderViewDelegate {
    func addTank(for section: Int)
    func scanQR(for section: Int)
}

class ListingHeaderView: UIView {

    static let nibId = "ListingHeaderView"
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet var contentView: UIView!
    
    // MARK: Variables Recieved
    
    var show_optionsView: Bool = true {
        didSet {
            optionsView.isHidden = !show_optionsView
        }
    }
    var section: Int?
    var delegate: ListingHeaderViewDelegate?
    
    // MARK: Initialization
    
    init(with frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        Bundle.main.loadNibNamed("ListingHeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        //contentView.layer.borderWidth = 1
        //contentView.layer.borderColor = UIColor.hexStringToUIColor(hex: "#F4F4F4").cgColor
        addSubview(contentView)
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addButton.addTarget(self, action: #selector(addTank), for: .touchUpInside)
        scanQRButton.addTarget(self, action: #selector(scanQR), for: .touchUpInside)
        //titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#131313")
        titleLabel.font = UIFont(name:"Montserrat-Medium",size:16)
    }
    
    // MARK: Button Actions
    
    @objc func addTank() {
        if let section = section {
            delegate?.addTank(for: section)
        }
    }
    
    @objc func scanQR() {
        if let section = section {
            delegate?.scanQR(for: section)
        }
    }
}


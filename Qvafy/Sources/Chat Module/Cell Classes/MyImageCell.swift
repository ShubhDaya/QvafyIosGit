//
//  MyImageCell.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit

class MyImageCell: UITableViewCell {

    @IBOutlet weak var imgMySide: UIImageView!
    @IBOutlet weak var viewMyImage: UIView!
    @IBOutlet weak var lblMyMsgTime: UILabel!
    @IBOutlet weak var btnZoomImage: UIButton!
    @IBOutlet weak var lblMsgDay: UILabel!
    @IBOutlet weak var viewMsgDay: UIView!
    @IBOutlet weak var imgSeen: UIImageView!
    @IBOutlet weak var ImageIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMyImage.layer.cornerRadius = 10
        viewMyImage.clipsToBounds = true
        viewMyImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

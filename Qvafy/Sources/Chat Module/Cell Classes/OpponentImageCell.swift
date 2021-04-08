//
//  OpponentImageCell.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit

class OpponentImageCell: UITableViewCell {

    @IBOutlet weak var imgOppSide: UIImageView!
    @IBOutlet weak var viewOppImage: UIView!
    @IBOutlet weak var lblOppMsgTime: UILabel!
    @IBOutlet weak var btnZoomImage: UIButton!
    
    @IBOutlet weak var lblMsgDay: UILabel!
    @IBOutlet weak var viewMsgDay: UIView!
    
    @IBOutlet weak var OppImageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblOppoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
               viewOppImage.layer.cornerRadius = 10
               viewOppImage.clipsToBounds = true
               viewOppImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

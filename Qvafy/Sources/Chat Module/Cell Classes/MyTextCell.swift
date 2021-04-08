//
//  MyTextCell.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit

class MyTextCell: UITableViewCell {

    @IBOutlet weak var viewMyText: UIView!
    @IBOutlet weak var lblMyMessage: UILabel!
    @IBOutlet weak var lblMyMsgTime: UILabel!
    
    @IBOutlet weak var lblMsgDay: UILabel!
    @IBOutlet weak var viewMsgDay: UIView!
    @IBOutlet weak var imgSeen: UIImageView!
    @IBOutlet weak var viewMytext: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMytext.layer.cornerRadius = 10
        viewMytext.clipsToBounds = true
        viewMytext.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

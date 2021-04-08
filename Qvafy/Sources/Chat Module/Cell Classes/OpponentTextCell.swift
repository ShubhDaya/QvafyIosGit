//
//  OpponentTextCell.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit

class OpponentTextCell: UITableViewCell {

    @IBOutlet weak var viewOppText: UIView!
    @IBOutlet weak var lblOppMessage: UILabel!
    @IBOutlet weak var lblOppMsgTime: UILabel!
    @IBOutlet weak var lblMsgDay: UILabel!
    @IBOutlet weak var viewMsgDay: UIView!
    @IBOutlet weak var viewOpponenttext: UIView!
    
     @IBOutlet weak var lblOppoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOpponenttext.layer.cornerRadius = 10
        viewOpponenttext.clipsToBounds = true
        viewOpponenttext.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner] 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

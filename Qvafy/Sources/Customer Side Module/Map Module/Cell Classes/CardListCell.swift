//
//  CardListCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 26/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class CardListCell: UITableViewCell {

    @IBOutlet var vwContainer: UIView!
    @IBOutlet var vwImageContainer: UIView!
    @IBOutlet var lblCardNumber: UILabel!
    @IBOutlet var lblCardAddDate: UILabel!
    @IBOutlet var imgVwCardType: UIImageView!
    @IBOutlet var imgCheck: UIImageView!
    @IBOutlet var btnCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwContainer.setShadowWithCornerRadius()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



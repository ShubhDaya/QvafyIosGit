//
//  SavedCardList.swift
//  Qvafy
//
//  Created by IOS-Shubham-40 on 25/03/21.
//  Copyright © 2021 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class SavedCardListCell: UITableViewCell {

    @IBOutlet var vwContainer: UIView!
    @IBOutlet var vwImageContainer: UIView!
    @IBOutlet var lblCardNumber: UILabel!
    @IBOutlet var lblCardAddDate: UILabel!
    @IBOutlet var imgVwCardType: UIImageView!
    @IBOutlet var imgCheck: UIImageView!
    @IBOutlet var btnCheck: UIButton!
    
    @IBOutlet weak var btnDeleteCard: UIButton!
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



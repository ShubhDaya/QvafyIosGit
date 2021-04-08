//
//  ItemCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 21/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//


import Foundation
import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    


}

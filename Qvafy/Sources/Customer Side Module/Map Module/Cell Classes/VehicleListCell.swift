//
//  VehicleListCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 27/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//


import UIKit

class VehicleListCell: UICollectionViewCell {
    
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var imgVehicle: UIImageView!

    
    
    
    override func awakeFromNib() {
    super.awakeFromNib()
        
        
        self.viewSelected.setCornerRadius(radius: 8)
        self.viewSelected.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        self.viewSelected.layer.borderWidth = 2.0

        
//        self.viewSelected.layer.cornerRadius = self.viewSelected.layer.frame.size.height / 2
//        self.viewSelected.layer.masksToBounds = true
        
    }
    
    func selectedHighletedView(){
        self.viewSelected.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.2156862745, alpha: 1)
        self.viewSelected.layer.borderWidth = 1.0

    }
    func selectedGrayView(){
        self.viewSelected.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        self.viewSelected.layer.borderWidth = 1.0

    }
    
    
}

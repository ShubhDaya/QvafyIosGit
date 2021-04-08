//
//  RestaurantTableCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 01/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class RestaurantTableCell: UITableViewCell {

      @IBOutlet weak var vwRestaurant: UIView!
      @IBOutlet weak var vwDotted: UIView!
      @IBOutlet weak var vwRating: UIView!
      @IBOutlet weak var lblRating: UILabel!
      @IBOutlet weak var lblName: UILabel!
      @IBOutlet weak var lblCetagory: UILabel!
      @IBOutlet weak var lblDistance: UILabel!
      @IBOutlet weak var imgRestaurant: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwDotted.creatDashedLine(view: vwDotted)
       // self.vwRestaurant.setCornerRadius(radius: 12)
       // self.imgRestaurant.setImgeRadius()
        
        self.imgRestaurant.clipsToBounds = true
        self.imgRestaurant.layer.cornerRadius = 8
        
        
//        vwRestaurant.clipsToBounds = true
      // vwRestaurant.layer.cornerRadius = CGFloat(10.0)
//        self.vwRestaurant.layer.setImgeRadius()

    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class RestaurantCVCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblOFF: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var imgOffer: UIImageView!
    @IBOutlet weak var lblLOCode: UILabel!
    
      override func awakeFromNib() {
        super.awakeFromNib()
            
        }
        

        
}

class CetagoryCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCetagory: UILabel!
    @IBOutlet weak var vwContainer: UIView!


      override func awakeFromNib() {
        super.awakeFromNib()
            
     //  self.vwContainer.setCornerRadBoarder(color: #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1), cornerRadious: 4)
        

        }
        
    
    func selectedHighletedView(){
        
        self.vwContainer.backgroundColor = #colorLiteral(red: 0.9994242787, green: 0.7029308677, blue: 0, alpha: 1)
        self.vwContainer.layer.cornerRadius = 4
        self.vwContainer.layer.borderColor = #colorLiteral(red: 0.9994242787, green: 0.7029308677, blue: 0, alpha: 1)
        self.lblCetagory.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.vwContainer.layer.borderWidth = 1.0

    }
    func selectedGrayView(){
        self.vwContainer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblCetagory.textColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
        self.vwContainer.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.vwContainer.layer.borderWidth = 1.0
        self.vwContainer.layer.cornerRadius = 4

    }

        
}

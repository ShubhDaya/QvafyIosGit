//
//  ItemCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 11/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MenuCell: UITableViewCell {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSubstract: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var imgAdd: UIImageView!
    @IBOutlet weak var imgSubstract: UIImageView!
    @IBOutlet weak var viewSubstract: UIView!
    @IBOutlet weak var viewCount: UIView!
    @IBOutlet weak var viewPlus: UIView!
    @IBOutlet weak var vwMenu: UIView!

    var isOpen = ""
    
    override func awakeFromNib() {
    super.awakeFromNib()
    // self.vwMenu.setSubProfileVerifyView(vwOuter: self.vwMenu, img: self.imgMenu ,radius : 4)
    self.imgMenu.layer.cornerRadius = self.imgMenu.frame.height/2
    self.imgMenu.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    self.imgMenu.layer.borderWidth = 2
    self.checkUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func checkUI(){
        if self.isOpen == "1"{
            self.btnSubstract.isUserInteractionEnabled = true
            self.btnAdd.isUserInteractionEnabled = true
                       self.lblTitle.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                       self.lblQuantity.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                       self.lblPrice.textColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)

                       self.imgMenu.isHidden = false
                      // self.imgMenu.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            //self.vwContainer.layer.opacity = 1.0

             self.imgAdd.image = #imageLiteral(resourceName: "plus_ico")
             self.imgSubstract.image = #imageLiteral(resourceName: "minus_ico")

        }else if self.isOpen == "0" {
            self.btnSubstract.isUserInteractionEnabled = false
            self.btnAdd.isUserInteractionEnabled = false

            self.lblTitle.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.lblPrice.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.lblQuantity.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

            self.imgAdd.image = #imageLiteral(resourceName: "gray_PLUS_ICO")
            self.imgSubstract.image = #imageLiteral(resourceName: "gray_MINUS_ICO")
            /// self.imgMenu.isHidden = true
            self.imgMenu.image = nil
             self.imgMenu.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
           // self.vwContainer.layer.opacity = 0.5
        }
    }
    
 
    // MARK: - Common function for Cart List

   func cartListCell(obj:CartModel) {
    
    lblTitle.text = obj.strName.capitalizingFirstLetter()
    lblPrice.text = "$" + obj.strPriceWithCommision
    lblQuantity.text = obj.strQuantity
    
    if obj.strAvatar != "" {
        let url = URL(string: obj.strAvatar)
        self.imgMenu.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "circle_placeholder_img"))
    }else{
        self.imgMenu.image = UIImage.init(named: "circle_placeholder_img")
    }
    
    
    if obj.strQuantity == "" {
        self.btnSubstract.isUserInteractionEnabled = false
        self.lblQuantity.isHidden = true
        self.imgSubstract.isHidden = true
        self.viewSubstract.isHidden = true
        self.viewCount.isHidden = true
    }
      
   }

}

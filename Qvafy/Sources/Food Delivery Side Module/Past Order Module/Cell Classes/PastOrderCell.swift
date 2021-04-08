//
//  PastOrderCell.swift
//  Qvafy
//  Created by ios-deepak b on 25/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.

import UIKit

class PastOrderCell: UITableViewCell {
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var vwProfile: UIView!
    
    @IBOutlet weak var lblRestaurant: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCoustomer: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var imgCustomer: UIImageView!
    @IBOutlet weak var imgRestaurant: UIImageView!
    
    @IBOutlet weak var vwRestaurant: UIView!
    @IBOutlet weak var vwDotted: UIView!
    @IBOutlet weak var vwRating: UIView!

    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // self.vwRestaurant.setCornerRadius(radius: 11)
        
       // self.vwRestaurant.setCornerRadius(radius: 12)
        self.imgRestaurant.setImgeRadius()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCorners(){
        
        self.vwContainer.layer.shadowColor = UIColor.lightGray.cgColor
        self.vwContainer.layer.shadowOpacity = 2
        self.vwContainer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.vwContainer.layer.shadowRadius = 5
        self.vwContainer.layer.masksToBounds = false
        self.vwContainer.layer.cornerRadius = 8
       // self.vwRestaurant.setCornerRadius(radius: 8)
      //  self.imgRestaurant.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }
    
    func showItemswithId(obj: UpcomingModel){
    
    var item = NSMutableAttributedString()
    var items = NSMutableAttributedString()
    var reference = NSMutableAttributedString()

    let strNameColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)


        item = NSMutableAttributedString(string: obj.strTotalItems + " \("item".localize)", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 13.0)!,NSAttributedString.Key.foregroundColor : strNameColor])
        items = NSMutableAttributedString(string: obj.strTotalItems + " \("items".localize)", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 13.0)!,NSAttributedString.Key.foregroundColor : strNameColor])
        reference = NSMutableAttributedString(string: " (#" + obj.strReferenceId + ")", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 11.0)!,NSAttributedString.Key.foregroundColor : strNameColor])
     
        let itemCombination = NSMutableAttributedString()
        itemCombination.append(item)
        itemCombination.append(reference)
        
        let itemCombinations = NSMutableAttributedString()
        itemCombinations.append(items)
        itemCombinations.append(reference)

//self.lblItems.attributedText = combination
        
        if obj.strTotalItems == "1"{
           // cell.lblItems.text = obj.strTotalItems + " item" + " (#" + obj.strReferenceId + ")"
           // self.lblItems.attributedText = itemCombination + " item" + referenceCombination
            self.lblItems.attributedText = itemCombination
        }else{
           // self.lblItems.text = obj.strTotalItems + " items" + " (#" + obj.strReferenceId + ")"
           // self.lblItems.attributedText = itemCombination + " items" + referenceCombination
            self.lblItems.attributedText = itemCombinations
        }
        
    }
    
    
}

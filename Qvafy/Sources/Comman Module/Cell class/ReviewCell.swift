//
//  ReviewCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 22/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SDWebImage
import HCSStarRatingView

 class ReviewCell: UITableViewCell {
    
     @IBOutlet weak var imgProfile: UIImageView!
     @IBOutlet weak var vwProfile: UIView!
     @IBOutlet weak var vwRating: HCSStarRatingView!
     @IBOutlet weak var vwDotted: UIView!
     @IBOutlet weak var lblFullName: UILabel!
     @IBOutlet weak var lblReview: UILabel!
     @IBOutlet weak var lblDate: UILabel!

     override func awakeFromNib() {
         super.awakeFromNib()
        
//        self.vwDotted.creatDashedLine(view: vwDotted)
        
        self.vwProfile.setSubProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile ,radius : 4)
       // self.vwProfile.setSubProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile ,radius : 4)

        
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

     }
     // MARK: - Common function for Review List

     func reviewListCell(obj:ReviewListModal) {


        lblFullName.text = obj.strFullName.capitalizingFirstLetter()
         lblReview.text = obj.strReview

        let ratingData = Double(obj.strRating)
         vwRating.value  = CGFloat(ratingData!)


        
        if obj.strUserImage != "" {
            let url = URL(string: obj.strUserImage)
            imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            imgProfile.image = UIImage.init(named: "inactive_profile_ico")
        }

//        if obj.strCreatedAt != ""{
//                   let date = objAppShareData.CalculateDays(strDate: obj.strCreatedAt )
//                                      lblDate.text = date + " day ago "
//               }
        lblDate.text = obj.strRemainingTime
        
     }

 }


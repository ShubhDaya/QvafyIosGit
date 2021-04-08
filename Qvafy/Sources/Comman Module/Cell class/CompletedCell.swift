//
//  CompletedCell.swift
//  Qvafy
//
//  Created by ios-deepak b on 23/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SDWebImage

class CompletedCell: UITableViewCell {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwReview: UIView!
    @IBOutlet weak var vwDotted: UIView!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblKilometer: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLOKilometer: UILabel!
    @IBOutlet weak var lblLOPrice: UILabel!
    @IBOutlet weak var btnTime: UIButton!

    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var vwBtnReview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

      
        //self.vwContainer.setCornerRadius(radius: 16)
        self.vwContainer.setShadowListCornerRadius(cornerRadious:10)
        
       /// self.btnReview.setCornerRadWithBoarder(color: #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1), cornerRadious: 4)


        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Common function for Past Trip List

    func pastTripCell(obj:BookingModel , tripType : String , userType : String) {


        lblSource.text = obj.strSource
        lblDestination.text = obj.strDestination
        lblKilometer.text = obj.strDistance
        lblPrice.text = "$" + obj.strPrice
        
        if obj.strCreatedAt != ""{
          //  let date = objAppShareData.changeDateformat(strDate: obj.strCreatedAt )
          //  let date = objAppShareData.convertLocalTime(strDateTime: obj.strCreatedAt) // convert local
            let date = objAppShareData.pastTripDateTime(strDateTime: obj.strCreatedAt) // convert local for today check
         
            lblTime.text = date
        }
        
        
        
        if obj.strRating == "" {
            btnReview.setTitle("Give_Review".localize, for: .normal)

        }else {
            btnReview.setTitle("View_review".localize, for: .normal)
        }
        
        
        if userType == "1"{
        if  tripType == "2" {
            vwReview.isHidden = true
        } else {
             vwReview.isHidden = false
            }
            
        }else{
            vwReview.isHidden = true
        }
        
    }

}

//
//  Cell_ChatHistory.swift
//  Appointment
//
//  Created by Apple on 13/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit

class Cell_ChatHistory: UITableViewCell {

    //For MyFavorites list
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var iconCamera: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var lblOorderNumber: UILabel!
    
    @IBOutlet weak var lblMsgName: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet weak var lblMsgCount: UILabel!
    @IBOutlet weak var viewMsgCount: UIView!
    @IBOutlet weak var viewIconCamera: UIView!
    @IBOutlet weak var viewImage: UIView!
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewOffer: UIView!
    @IBOutlet weak var viewStack: UIView!
    @IBOutlet weak var vwOnline: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.lblMsgCount.layer.cornerRadius = self.lblMsgCount.frame.height/2
        self.lblMsgCount.clipsToBounds = true
//       self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.height/2
//      self.imgUserProfile.clipsToBounds = true
        
      //  self.viewImage.setProfileVerifyView(vwOuter: self.viewImage, img: self.imgUserProfile)
        self.viewImage.setUserProfileView(vwOuter: self.viewImage, img: self.imgUserProfile , radius : 4)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

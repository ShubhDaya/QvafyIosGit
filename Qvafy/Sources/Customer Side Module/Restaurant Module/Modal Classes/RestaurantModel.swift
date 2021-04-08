//
//  RestaurantModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 07/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class RestaurantModel: NSObject {
    
    var strUserID: String = ""
    var strFullName: String = ""
    var strAvatar: String = ""
    var strBusinessType: String = ""
    var strAvgRating: String = ""
    var strDistance: String = ""
    
    
    init(dict : [String:Any]) {
        
        if let userID = dict["userID"]  as? String{
            self.strUserID = userID
        }else if let userID = dict["userID"]  as? Int{
            self.strUserID = "\(userID)"
        }
        if let fullName = dict["full_name"] as? String{
            self.strFullName = fullName
        }
        if let avatar = dict["avatar"] as? String{
            self.strAvatar = avatar
        }
        if let businessType = dict["business_type"] as? String{
            self.strBusinessType = businessType
        }
        if let avgRating = dict["avg_rating"] as? String{
            self.strAvgRating = avgRating
        }
        if let distance = dict["distance"] as? String{
            self.strDistance = distance
        }
        
        
    }
    
}

class PromoCodeModel: NSObject {
    
    var strPromoCodeID: String = ""
    var strTitle: String = ""
    var strPercentage: String = ""
    var strPromoCode: String = ""
    var strExpiryDate: String = ""
    var strPromoImage: String = ""
    
    init(dict : [String:Any]) {
        
        if let promoCodeID = dict["promoCodeID"]  as? String{
            self.strPromoCodeID = promoCodeID
        }else if let promoCodeID = dict["promoCodeID"]  as? Int{
            self.strPromoCodeID = "\(promoCodeID)"
        }
        
        if let title = dict["title"] as? String{
            self.strTitle = title
        }
        
        if let percentage = dict["percentage"] as? String{
            self.strPercentage = percentage
        }
        
        if let promoCode = dict["promo_code"] as? String{
            self.strPromoCode = promoCode
        }
        
        if let expiryDate = dict["expiry_date"] as? String{
            self.strExpiryDate = expiryDate
        }
        if let promoImage = dict["promo_image"] as? String{
            self.strPromoImage = promoImage
        }
        
    }
    
}

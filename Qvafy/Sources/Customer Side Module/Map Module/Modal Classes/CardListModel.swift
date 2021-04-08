//
//  CardListModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 27/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class CardListModel: NSObject {

        var strCardID: String = ""
        var strUserID: String = ""
        var strCreatedAt: String = ""
        var strStripeCardId: String = ""
        var strBrand: String = ""
        var strCardLast4: String = ""

        init(dict : [String:Any]) {
            
            if let userID = dict["user_id"]  as? String{
                self.strUserID = userID
            }else if let userID = dict["user_id"]  as? Int{
                self.strUserID = "\(userID)"
            }
          
            if let cardID = dict["cardID"]  as? String{
                           self.strCardID = cardID
                       }else if let cardID = dict["cardID"]  as? Int{
                           self.strCardID = "\(cardID)"
                       }
            
            
            if let created_at = dict["created_at"] as? String{
                self.strCreatedAt = created_at
            }
          
          if let stripe_card_id = dict["stripe_card_id"] as? String{
              self.strStripeCardId = stripe_card_id
          }
          
          if let card_brand_type = dict["card_brand_type"] as? String{
              self.strBrand = card_brand_type
          }
            
            
            if let userID = dict["card_last_4_digits"]  as? String{
                           self.strCardLast4 = userID
                       }else if let userID = dict["card_last_4_digits"]  as? Int{
                           self.strCardLast4 = "\(userID)"
                       }
          
      }
      
}

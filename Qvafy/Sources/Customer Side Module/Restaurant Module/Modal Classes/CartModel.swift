//
//  CartModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 13/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import Foundation
import UIKit

class CartModel: NSObject {
    
    var strMenuID: String = ""
    var strAvatar: String = ""
    var strQuantity: String = ""
    var strCommision: String = ""
    var strName: String = ""
    var strActualPrice: String = ""
    var strPriceWithCommision: String = ""
    var strCartItemID: String = ""
    var strRestaurantID: String = ""
    var strRestaurantName: String = ""

    
    init(dict : [String:Any]) {
        
        if let menuID = dict["menu_id"]  as? String{
            self.strMenuID = menuID
        }else if let menuID = dict["menu_id"]  as? Int{
            self.strMenuID = "\(menuID)"
        }
        
        if let restaurantId = dict["restaurant_id"]  as? String{
            self.strRestaurantID = restaurantId
        }else if let restaurantId = dict["restaurant_id"]  as? Int{
            self.strRestaurantID = "\(restaurantId)"
        }
        
        if let cartItemID = dict["cartItemID"]  as? String{
            self.strCartItemID = cartItemID
        }else if let cartItemID = dict["cartItemID"]  as? Int{
            self.strCartItemID = "\(cartItemID)"
        }
        
        if let quantity = dict["quantity"]  as? String{
            self.strQuantity = quantity
        }else if let quantity = dict["quantity"]  as? Int{
            self.strQuantity = "\(quantity)"
        }
        
        if let commision = dict["commision"]  as? String{
            self.strCommision = commision
        }else if let commision = dict["commision"]  as? Int{
            self.strCommision = "\(commision)"
        }
        
        if let menuImage = dict["menu_image"] as? String{
            self.strAvatar = menuImage
        }
        
        if let menuImage = dict["menu_image"] as? String{
            self.strAvatar = menuImage
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let restaurant_name = dict["restaurant_name"] as? String{
            self.strRestaurantName = restaurant_name
        }
        if let actualPrice = dict["actual_price"] as? String{
            self.strActualPrice = actualPrice
        }
        
        if let priceWithCommision = dict["price_with_commision"] as? String{
            self.strPriceWithCommision = priceWithCommision
        }
    }
}

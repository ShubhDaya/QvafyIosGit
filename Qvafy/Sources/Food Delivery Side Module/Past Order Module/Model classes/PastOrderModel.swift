//
//  PastOrderModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 26/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class PastOrderModel: NSObject {
    
    var strOrderID: String = ""
    var strRestaurantName: String = ""
    var strCustomerName: String = ""
    var strCreatedAt: String = ""
    var strRestaurantImage: String = ""
    var strCustomerImage: String = ""
    var strTotalItems: String = ""
    var strTotalAmount: String = ""
    var strCurrentStatus: String = ""
    var strRestAvgRating: String = ""

    init(dict : [String:Any]) {
        
        if let OrderID = dict["OrderID"]  as? String{
            self.strOrderID = OrderID
        }else if let OrderID = dict["OrderID"]  as? Int{
            self.strOrderID = "\(OrderID)"
        }
        if let restaurantName = dict["restaurant_name"] as? String{
            self.strRestaurantName = restaurantName
        }
        if let customerName = dict["customer_name"] as? String{
            self.strCustomerName = customerName
        }
        if let restaurantImage = dict["restaurant_image"] as? String{
            self.strRestaurantImage = restaurantImage
        }
        if let customerImage = dict["customer_image"] as? String{
            self.strCustomerImage = customerImage
        }
        if let createdAt = dict["created_at"] as? String{
            self.strCreatedAt = createdAt
        }
        if let totalItems = dict["total_items"] as? String{
            self.strTotalItems = totalItems
        }
        if let totalAmount = dict["total_amount"] as? String{
            self.strTotalAmount = totalAmount
        }
        if let currentStatus = dict["current_status"] as? String{
            self.strCurrentStatus = currentStatus
        }
        
        if let restAvgRating = dict["rest_avg_rating"] as? String{
            self.strRestAvgRating = restAvgRating
        }
    }
    
}

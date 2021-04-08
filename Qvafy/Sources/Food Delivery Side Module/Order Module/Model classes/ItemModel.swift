//
//  ItemModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 21/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class ItemModel: NSObject {

  
    var strMenuName: String = ""
    var strMenuPrice: String = ""
    var strQuantity: String = ""
    
    init(dict : [String:Any]) {
        
       
        if let name = dict["menu_name"] as? String{
            self.strMenuName = name
        }
        if let Price = dict["menu_price"] as? String{
            self.strMenuPrice = Price
        }
        
        if let quantity = dict["quantity"] as? String{
            self.strQuantity = quantity
        }
        

        
    }
    
}

class OrderTracking: NSObject {

    var strCreatedTime: String = ""
    var strCurrentStatus: String = ""
    var strCurrentStatusTitle: String = ""
    var strOrderTrackingID: String = ""
    var strOrderId: String = ""
    

    init(dict : [String:Any]) {
           
          
           if let createdTime = dict["created_time"] as? String{
               self.strCreatedTime = createdTime
           }
           if let currentStatus = dict["current_status"] as? String{
               self.strCurrentStatus = currentStatus
           }
           
           if let currentStatusTitle = dict["current_status_title"] as? String{
               self.strCurrentStatusTitle = currentStatusTitle
           }
           if let orderTrackingID = dict["orderTrackingID"] as? String{
               self.strOrderTrackingID = orderTrackingID
           }
           
           if let orderId = dict["order_id"] as? String{
               self.strOrderId = orderId
           }

           
       }
    
}

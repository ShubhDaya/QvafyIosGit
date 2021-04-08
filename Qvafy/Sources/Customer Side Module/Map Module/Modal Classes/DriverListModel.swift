//
//  DriverListModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 26/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class DriverListModel: NSObject {

      var strDistance: String = ""
      var strUserID: String = ""
      var strFullName: String = ""
      var strLatitude: String = ""
      var strLongitude: String = ""

      init(dict : [String:Any]) {
          
          if let userID = dict["userID"]  as? String{
              self.strUserID = userID
          }else if let userID = dict["userID"]  as? Int{
              self.strUserID = "\(userID)"
          }
        
          
          if let full_name = dict["full_name"] as? String{
              self.strFullName = full_name
          }
        
        if let latitude = dict["latitude"] as? String{
            self.strLatitude = latitude
        }
        
        if let longitude = dict["longitude"] as? String{
            self.strLongitude = longitude
        }
        
        if let distance = dict["distance"] as? String{
            self.strDistance = distance
        }
    }
    
}

class VehicleListModel: NSObject {

    
      var strvehicleMetaID: String = ""
      var strPrice: String = ""
      var strTotalDistance: String = ""
      var strTotalPrice: String = ""
      var strVehicleModel: String = ""
      var strVehicleImage: String = ""
       var strDistance: String = ""


      init(dict : [String:Any]) {
          
          if let vehicleMetaID = dict["vehicleMetaID"]  as? String{
              self.strvehicleMetaID = vehicleMetaID
          }else if let vehicleMetaID = dict["vehicleMetaID"]  as? Int{
              self.strvehicleMetaID = "\(vehicleMetaID)"
          }
        
          
          if let price = dict["price"] as? String{
              self.strPrice = price
          }
        
        if let total_distance = dict["total_distance"] as? String{
            self.strTotalDistance = total_distance
        }
        
        if let totalPrice = dict["total_price"] as? String{
            self.strTotalPrice = totalPrice
        }
        
        if let vehicle_model = dict["vehicle_model"] as? String{
            self.strVehicleModel = vehicle_model
        }
        if let vehicle_image = dict["vehicle_image"] as? String{
            self.strVehicleImage = vehicle_image
        }
        if let distance = dict["distance"] as? String{
            self.strDistance = distance
        }
    }
    
    
}


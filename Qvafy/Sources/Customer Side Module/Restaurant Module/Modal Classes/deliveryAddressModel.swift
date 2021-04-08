//
//  deliveryAddressModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 14/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import Foundation
import UIKit

class deliveryAddressModel: NSObject {
    
    var strDeliveryAddID: String = ""
    var strAddress: String = ""
    var strLongitude: String = ""
    var strlatitude: String = ""
    var strIsDefault: String = ""
    var isSelect = false

    init(dict : [String:Any]) {
        
        if let deliveryAddressId = dict["delivery_address_id"]  as? String{
            self.strDeliveryAddID = deliveryAddressId
        }else if let deliveryAddressId = dict["delivery_address_id"]  as? Int{
            self.strDeliveryAddID = "\(deliveryAddressId)"
        }
        
        if let isDefault = dict["is_default"]  as? String{
            self.strIsDefault = isDefault
        }else if let isDefault = dict["is_default"]  as? Int{
            self.strIsDefault = "\(isDefault)"
        }

        
        if let address = dict["address"] as? String{
            self.strAddress = address
        }
        if let latitude = dict["latitude"] as? String{
            self.strlatitude = latitude
        }
        if let actualPrice = dict["longitude"] as? String{
            self.strLongitude = actualPrice
        }
        
    }
    
}

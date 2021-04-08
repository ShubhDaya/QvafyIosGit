//
//  VehicleModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 11/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import Foundation
import UIKit

class VehicleModel: NSObject {
    var strVehicleCompanyId: String = ""
    var strMehicleMetaId: String = ""
    var strCompany: String = ""
    var strModel: String = ""
    var arrVehicleType = [VehicleModel]()
    
    init(dict : [String:Any]) {
        
        if let vehicleCompanyId = dict["vehicle_company_id"]  as? String{
            self.strVehicleCompanyId = vehicleCompanyId
        }else if let vehicleCompanyId = dict["vehicle_company_id"]  as? Int{
            self.strVehicleCompanyId = "\(vehicleCompanyId)"
        }
        
        if let vehicleMetaID = dict["vehicleMetaID"]  as? String{
            self.strMehicleMetaId = vehicleMetaID
        }else if let vehicleMetaID = dict["vehicleMetaID"]  as? Int{
            self.strMehicleMetaId = "\(vehicleMetaID)"
        }
        
        if let company = dict["company"] as? String{
            self.strCompany = company
        }
        
        if let model = dict["model"] as? String{
            self.strModel = model
        }
        
        if let arrVehicle = dict["vehicle_type"] as? [[String:Any]]{
            for subType in arrVehicle{
                let objType = VehicleModel.init(dict: subType)
                self.arrVehicleType.append(objType)
            }
            
        }
        
        
    }
    
}


class FilterModel: NSObject {
    var strCategoryID: String = ""
    var strBusinessTypeID: String = ""
    var strName: String = ""
    var strCategoryName: String = ""
    
    init(dict : [String:Any]) {
        
        if let businessTypeID = dict["businessTypeID"]  as? String{
            self.strBusinessTypeID = businessTypeID
        }else if let businessTypeID = dict["businessTypeID"]  as? Int{
            self.strBusinessTypeID = "\(businessTypeID)"
        }
        
        if let categoryID = dict["categoryID"]  as? String{
            self.strCategoryID = categoryID
        }else if let categoryID = dict["categoryID"]  as? Int{
            self.strCategoryID = "\(categoryID)"
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let categoryName = dict["category_name"] as? String{
            self.strCategoryName = categoryName
        }
        

        
        
    }
    
}

//
//  MenuModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 12/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import Foundation
import UIKit

class MenuModel: NSObject {
    
    var strMenuID: String = ""
    var strSubCategoryId: String = ""
    var strAvatar: String = ""
    var strQuantity: String = ""
    var strCommision: String = ""
    var strSubCategory: String = ""
    var strName: String = ""
    var strActualPrice: String = ""
    var strPriceWithCommision: String = ""
    
    var arrList = [MenuModel]()

    
    
    init(dict : [String:Any]) {
        
        if let menuID = dict["menuID"]  as? String{
            self.strMenuID = menuID
        }else if let menuID = dict["menuID"]  as? Int{
            self.strMenuID = "\(menuID)"
        }
        
        if let subCategoryId = dict["sub_category_id"]  as? String{
            self.strSubCategoryId = subCategoryId
        }else if let subCategoryId = dict["sub_category_id"]  as? Int{
            self.strSubCategoryId = "\(subCategoryId)"
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
        
        if let subCategory = dict["sub_category"] as? String{
            self.strSubCategory = subCategory
        }
        if let menuImage = dict["menu_image"] as? String{
            self.strAvatar = menuImage
        }
        if let name = dict["name"] as? String{
            self.strName = name
        }
        if let actualPrice = dict["actual_price"] as? String{
            self.strActualPrice = actualPrice
        }
        
        if let priceWithCommision = dict["price_with_commision"] as? String{
            self.strPriceWithCommision = priceWithCommision
        }
        
        if let arrVehicle = dict["list"] as? [[String:Any]]{
            for subType in arrVehicle{
                let objType = MenuModel.init(dict: subType)
                self.arrList.append(objType)
            }
            
        }
        
    }
    
}

class CategoryModel: NSObject {
    
    var strCategoryId: String = ""
    var strCategoryName: String = ""
    
    init(dict : [String:Any]) {
        
        if let categoryId = dict["categoryID"]  as? String{
            self.strCategoryId = categoryId
        }else if let categoryId = dict["categoryID"]  as? Int{
            self.strCategoryId = "\(categoryId)"
        }
        
        if let subCategory = dict["category_name"] as? String{
            self.strCategoryName = subCategory
        }
        
    }
    
}


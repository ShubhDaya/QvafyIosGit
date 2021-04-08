//
//  CommonModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 18/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//


import Foundation
import UIKit

class CommonModel: NSObject {
    var strCubaBankID: String = ""
    var strBankName: String = ""
    var strCreatedAt: String = ""
    var strPrivacyPolicy: String = ""
    var strPrivacyPolicyUrl: String = ""
    var strTermsConditions: String = ""
    var strTermsConditionsUrl: String = ""
    
    init(dict : [String:Any]) {
        
        if let cubaBankID = dict["cubaBankID"]  as? String{
            self.strCubaBankID = cubaBankID
        }else if let cubaBankID = dict["cubaBankID"]  as? Int{
            self.strCubaBankID = "\(cubaBankID)"
        }
        
        if let bankName = dict["bank_name"]  as? String{
            self.strBankName = bankName
        }
        
        if let createdAt = dict["created_at"] as? String{
            self.strCreatedAt = createdAt
        }
        
        if let privacyPolicy = dict["privacy_policy"] as? String{
            self.strPrivacyPolicy = privacyPolicy
        }
        if let privacyPolicyUrl = dict["privacy_policy_url"] as? String{
            self.strPrivacyPolicyUrl = privacyPolicyUrl
        }
        if let termsConditions = dict["terms_conditions"] as? String{
            self.strTermsConditions = termsConditions
        }
        if let termsConditionsUrl = dict["terms_conditions_url"] as? String{
            self.strTermsConditionsUrl = termsConditionsUrl
        }

    }
    
}



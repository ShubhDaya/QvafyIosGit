//
//  UserDefaultExtension.swift
//  Habito
//
//  Created by MINDIII on 11/9/17.
//  Copyright © 2017 MINDIII. All rights reserved.
//

import Foundation
import UIKit

var deviceToken: String? {
     get {
         return UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.deviceToken) as? String ?? ""
     }
 }

extension UserDefaults{
    
    enum KeysDefault {
      //user Info
     // crime use
        static let strAccessToken = "access_token"
        static let strVenderId = "udid"
        static let userInfo = "userInfo"
        static let vechicleInfo = "vechicleInfo"
        static let deviceToken = "device_token"
        static let termsCoditionAccept = "Terms&conditonAccept"
        
        static let kAuthToken = "authToken"
        static  let kOnboardingStep = "onboarding_step"
        static  let kProfileComplete = "profile_complete"
        static let kRole = "role"
        static let KStripeConnectAccountId = "stripe_connect_account_id"
        static let KcustomerStripeID = "customerStripeID"
        static let kUserId = "userID"
        static let kAccountNo = "account_number"
    }
    
}


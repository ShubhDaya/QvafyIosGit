//
//  SignupModelClass.swift
//  CrimeSpotter
//
//  Created by MS-H110 on 06/02/20.
//  Copyright © 2020 MS-H110. All rights reserved.
//

import UIKit
import Foundation


class userDetailModel: NSObject {
    
    // for user details
    
    var strFullName : String = ""
    var strUserID : String = ""
    var strEmail : String = ""
    var strPassword : String = ""
    var strRole : String = ""
    var strUserStatus : String = ""
    var strAvatar : String = ""
    var strSignupFrom : String = ""
    var strProfileTimezone : String = ""
    var strAddress : String = ""
    var strLatitude : String = ""
    var strLongitude : String = ""
    var strCountryCode : String = ""
    var strUpdatedAt : String = ""
    var strCreatedAt : String = ""
    var strDeviceType : String = ""
    var strDeviceId : String = ""
    var strDeviceToken : String = ""
    var strAuthtoken : String = ""
    var strDeviceTimeZone : String = ""
    var strPushAlertStatus : String = ""
    var strIsVerified : String = ""
    var strProfileComplete : String = ""
    var strOnboardingStep : String = ""
    var strStripeCustomerId : String = ""
    var strStripeConnectAccountId : String = ""
    var strStripeConnectAccountVerified : String = ""
    var strIsUserCuba : String = ""
    var strCubaBankId: String = ""
    var strCubaBankCard : String = ""
    
    // for Vehicle details
    var strLicenseImgLink: String = ""
    var strLicenseVerify: String = ""
    var strMake: String = ""
    var strModelNumber: String = ""
    var strPrice: String = ""
    var strRegistrationImgLink: String = ""
    var strRegistrationVerify: String = ""
    var strType: String = ""
    var strTypeofDriver: String = ""
    var strVehicleCompanyID: String = ""
    var strVehicleInfoID: String = ""
    var strVehicleMetaID: String = ""
    var strVehicleNumber: String = ""
    var strVehicleType: String = ""
    var strVehicleYear: String = ""
    var strAvgRating : String = ""
    var strTotalRating : String = ""
    var strIsOnline : String = ""
    
    // for bank details
    var strAccountHolderName : String = ""
    var strAccountNumber : String = ""
    var strBankName : String = ""
    var strBankCreatedAt : String = ""
    var strExternalAccountID : String = ""
    var strIsDefault : String = ""
    var strRoutingNumber : String = ""
    var strStripeExternalAccountId : String = ""
    var strBankUpdatedAt : String = ""
    var strBankUserId : String = ""
    
     // for Customer Info
    var strPhoneNumber : String = ""
      var strPastTripCount : String = ""
      var strPastOrdersCount : String = ""
      var strGender : String = ""
      var strDialCode : String = ""
    
    init(dict : [String:Any]) {
        // for User details
        
        if let userID = dict["userID"] as? Int
        {
            self.strUserID = "\(userID)"
        }
        else if let userID = dict["userID"] as? String
        {
            self.strUserID = userID
        }
        
        self.strFullName = dict["full_name"] as? String ?? ""
        self.strEmail = dict["email"] as? String ?? ""
        self.strPassword = dict["password"] as? String ?? ""
        self.strRole = dict["role"] as? String ?? ""
        self.strUserStatus = dict["user_status"] as? String ?? ""
        self.strAvatar = dict["avatar"] as? String ?? ""
        self.strSignupFrom = dict["signup_from"] as? String ?? ""
        self.strStripeCustomerId = dict["stripe_customer_id"] as? String ?? ""
        self.strProfileTimezone = dict["profile_timezone"] as? String ?? ""
        self.strAddress = dict["address"] as? String ?? ""
        self.strLatitude = dict["latitude"] as? String ?? ""
        self.strLongitude = dict["longitude"] as? String ?? ""
        self.strCountryCode = dict["country_code"] as? String ?? ""
        self.strUpdatedAt = dict["updated_at"] as? String ?? ""
        self.strCreatedAt = dict["created_at"] as? String ?? ""
        self.strDeviceType = dict["device_type"] as? String  ?? ""
        self.strDeviceId = dict["device_id"] as? String ?? ""
        self.strAuthtoken = dict["authtoken"] as? String ?? ""
        self.strDeviceToken = dict["device_token"] as? String ?? ""
        self.strDeviceTimeZone = dict["device_timezone"] as? String ?? ""
        self.strPushAlertStatus = dict["push_alert_status"] as? String ?? ""
        self.strIsVerified = dict["is_verified"] as? String ?? ""
        self.strProfileComplete = dict["profile_complete"] as? String ?? ""
        self.strOnboardingStep = dict["onboarding_step"] as? String ?? ""
        self.strCubaBankCard = dict["cuba_bank_card"] as? String ?? ""
        self.strCubaBankId = dict["cuba_bank_id"] as? String ?? ""
        self.strIsUserCuba = dict["is_user_cuba"] as? String ?? ""
        self.strStripeConnectAccountId = dict["stripe_connect_account_id"] as? String ?? ""
        self.strStripeConnectAccountVerified = dict["stripe_connect_account_verified"] as? String ?? ""
        
        // for Vehicle details
        
        self.strModelNumber = dict["model_number"] as? String ?? ""
        self.strPrice = dict["price"]  as? String ?? ""
        self.strRegistrationImgLink = dict["registration"] as? String ?? ""
        self.strRegistrationVerify = dict["registration_verify"]  as? String ?? ""
        self.strType = dict["type"] as? String ?? ""
        self.strTypeofDriver = dict["type_of_driver"]  as? String ?? ""
        self.strVehicleCompanyID = dict["vehicleCompanyID"] as? String ?? ""
        self.strVehicleInfoID = dict["vehicleInfoID"]  as? String ?? ""
        self.strVehicleMetaID = dict["vehicleMetaID"] as? String ?? ""
        self.strVehicleNumber = dict["vehicle_number"]  as? String ?? ""
        self.strVehicleType = dict["vehicle_type"] as? String ?? ""
        self.strVehicleYear = dict["vehicle_year"]  as? String ?? ""
        self.strLicenseVerify = dict["license_verify"] as? String ?? ""
        self.strLicenseImgLink =  dict["license"]  as? String ?? ""
        self.strMake = dict["make"]  as? String ?? ""
        
        self.strAvgRating = dict["avg_rating"] as? String ?? ""
        self.strTotalRating = dict["total_rating"] as? String ?? ""
        self.strIsOnline = dict["is_online"] as? String ?? ""

       

        
        //        if let bankName = dict["license"]  as? String{
        //            self.strLicenseImgLink = bankName
        //        }
        //
        //        if let createdAt = dict["license_verify"] as? String{
        //            self.strLicense_verify = createdAt
        //        }
        //
        //        if let bankName = dict["make"]  as? String{
        //            self.strMake = bankName
        //        }
        //
        //        if let createdAt = dict["model_number"] as? String{
        //            self.strModelNumber = createdAt
        //        }
        //        if let bankName = dict["price"]  as? String{
        //            self.strPrice = bankName
        //        }
        //
        //        if let createdAt = dict["registration"] as? String{
        //            self.strRegistrationImgLink = createdAt
        //        }
        //        if let bankName = dict["registration_verify"]  as? String{
        //            self.strRegistrationVerify = bankName
        //        }
        //
        //        if let createdAt = dict["type"] as? String{
        //            self.strType = createdAt
        //        }
        //
        //        if let bankName = dict["type_of_driver"]  as? String{
        //            self.strTypeofDriver = bankName
        //        }
        //
        //        if let createdAt = dict["vehicleCompanyID"] as? String{
        //            self.strVehicleCompanyID = createdAt
        //        }
        //        if let bankName = dict["vehicleInfoID"]  as? String{
        //            self.strVehicleInfoID = bankName
        //        }
        //
        //        if let createdAt = dict["vehicleMetaID"] as? String{
        //            self.strVehicleMetaID = createdAt
        //        }
        //        if let bankName = dict["vehicle_number"]  as? String{
        //            self.strVehicleNumber = bankName
        //        }
        //
        //        if let createdAt = dict["vehicle_type"] as? String{
        //            self.strVehicleType = createdAt
        //        }
        //        if let bankName = dict["vehicle_year"]  as? String{
        //            self.strVehicleYear = bankName
        //        }
        
        // for bank details
        self.strAccountHolderName = dict["account_holder_name"] as? String ?? ""
        self.strAccountNumber = dict["account_number"] as? String ?? ""
        self.strBankName = dict["bank_name"] as? String ?? ""
        self.strBankCreatedAt = dict["created_at"] as? String ?? ""
        self.strExternalAccountID = dict["externalAccountID"] as? String ?? ""
        self.strIsDefault = dict["is_default"] as? String ?? ""
        self.strRoutingNumber = dict["routing_number"] as? String ?? ""
        self.strStripeExternalAccountId = dict["stripe_external_account_id"] as? String ?? ""
        self.strBankUpdatedAt = dict["updated_at"] as? String ?? ""
        self.strBankUserId = dict["user_id"] as? String ?? ""
     
        // for Customer Info

        
        self.strGender = dict["gender"] as? String ?? ""
        self.strPastOrdersCount = dict["past_orders_count"] as? String ?? ""
        self.strPastTripCount = dict["past_trip_count"] as? String ?? ""
        self.strPhoneNumber = dict["phone_number"] as? String ?? ""
        self.strDialCode = dict["dial_code"] as? String ?? ""
        
    }
}


//class customerDetailModel: NSObject {
//
//
//    var strFullName : String = ""
//    var strUserID : String = ""
//    var strEmail : String = ""
//    var strUserStatus : String = ""
//    var strAvatar : String = ""
//
//    var strPhoneNumber : String = ""
//    var strPastTripCount : String = ""
//    var strPastOrdersCount : String = ""
//    var strGender : String = ""
//    var strDialCode : String = ""
//    init(dict : [String:Any]) {
//
//
//        self.strFullName = dict["full_name"] as? String ?? ""
//        self.strEmail = dict["email"] as? String ?? ""
//        self.strAvatar = dict["avatar"] as? String ?? ""
//        self.strUserID = dict["userID"] as? String ?? ""
//        self.strUserStatus = dict["user_status"] as? String ?? ""
//
//        self.strGender = dict["gender"] as? String ?? ""
//        self.strPastOrdersCount = dict["past_orders_count"] as? String ?? ""
//        self.strPastTripCount = dict["past_trip_count"] as? String ?? ""
//        self.strPhoneNumber = dict["phone_number"] as? String ?? ""
//        self.strDialCode = dict["dial_code"] as? String ?? ""
//
//    }
//}

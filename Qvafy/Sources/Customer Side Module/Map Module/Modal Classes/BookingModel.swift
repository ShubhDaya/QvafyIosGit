//
//  BookingModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 03/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class BookingModel: NSObject {
    
    // for user details
    
    var strFullName : String = ""
    var strUserID : String = ""
    var strAvatar : String = ""
    var strPrice: String = ""
    var strStatus : String = ""
    var strTime : String = ""
    var strTripCode : String = ""
    var strSLatitude : String = ""
    var strSLongitude : String = ""
    var strDLatitude : String = ""
    var strDLongitude : String = ""
    var strCustomerId : String = ""
    var strBookingID : String = ""
    var strDriverId : String = ""
    var strVehicleYear : String = ""
    var strCompany : String = ""
    var strVehicleModel : String = ""
    var strVehicleImage : String = ""
    var strDialCode : String = ""
    var strPhoneNumber : String = ""
    var strCustomerName : String = ""
    var strAdminFee: String = ""
    var strCreatedAt : String = ""
    var strDeletedBy : String = ""
    var strDestination : String = ""
    var strDriverFee : String = ""
    var strPaymentMethod : String = ""
    var strPaymentStatus : String = ""
    var strStripeCardId : String = ""
    var strSource : String = ""
    var strDistance : String = ""
    var strRating : String = ""
    var strReview : String = ""
    
    // new deepak updated testing
    var strCustomerImage : String = ""
    var strDriverImage : String = ""
    var strDriverName : String = ""

    // new deepak updated testing
    
    init(dict : [String:Any]) {
        
        if let status = dict["status"] as? Int
        {
            self.strStatus = "\(status)"
        }
        else if let status = dict["status"] as? String
        {
            self.strStatus = status
        }
        
        if let customer_id = dict["customer_id"] as? Int
        {
            self.strCustomerId = "\(customer_id)"
        }
        else if let customer_id = dict["customer_id"] as? String
        {
            self.strCustomerId = customer_id
        }
        
        if let bookingID = dict["bookingID"] as? Int
        {
            self.strBookingID = "\(bookingID)"
        }
        else if let bookingID = dict["bookingID"] as? String
        {
            self.strBookingID = bookingID
        }
        
        if let driver_id = dict["driver_id"] as? Int
        {
            self.strDriverId = "\(driver_id)"
        }
        else if let driver_id = dict["driver_id"] as? String
        {
            self.strDriverId = driver_id
        }
        
        
        self.strTime = dict["time"] as? String ?? ""
        self.strTripCode = dict["trip_code"] as? String ?? ""
        self.strAvatar = dict["avatar"] as? String ?? ""
        self.strFullName = dict["full_name"] as? String ?? ""
        self.strDLatitude = dict["d_latitude"] as? String ?? ""
        self.strDLongitude = dict["d_longitude"] as? String ?? ""
        self.strSLatitude = dict["s_latitude"] as? String ?? ""
        self.strSLongitude = dict["s_longitude"] as? String ?? ""
        self.strPrice = dict["price"]  as? String ?? ""
        self.strVehicleYear = dict["vehicle_year"]  as? String ?? ""
        self.strCompany = dict["company"] as? String ?? ""
        self.strVehicleModel = dict["vehicle_model"] as? String ?? ""
        self.strVehicleImage = dict["vehicle_image"]  as? String ?? ""
        self.strDialCode = dict["dial_code"]  as? String ?? ""
        self.strPhoneNumber = dict["phone_number"]  as? String ?? ""
        self.strCustomerName = dict["customer_name"]  as? String ?? ""
        self.strAdminFee = dict["admin_fee"] as? String ?? ""
        self.strCreatedAt = dict["created_at"]  as? String ?? ""
        self.strDeletedBy = dict["deleted_by"] as? String ?? ""
        self.strDestination = dict["destination"]  as? String ?? ""
        self.strDistance = dict["distance"] as? String ?? ""
        self.strDriverFee = dict["driver_fee"] as? String ?? ""
        self.strPaymentMethod =  dict["payment_method"]  as? String ?? ""
        self.strPaymentStatus = dict["payment_status"]  as? String ?? ""
        self.strStripeCardId = dict["stripe_card_id"]  as? String ?? ""
        self.strSource = dict["source"]  as? String ?? ""
        self.strRating = dict["rating"]  as? String ?? ""
        self.strReview = dict["review"]  as? String ?? ""
               
        // new deepak updated testing
        self.strCustomerImage = dict["customer_image"] as? String ?? ""
        self.strDriverImage = dict["driver_image"] as? String ?? ""
        self.strDriverName = dict["driver_name"] as? String ?? ""
        // new deepak updated testing
    }
}




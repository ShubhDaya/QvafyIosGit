//
//  UpcomingModel.swift
//  Qvafy
//
//  Created by ios-deepak b on 26/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class UpcomingModel: NSObject {
    
    var strOrderID: String = ""
    var strRestaurantName: String = ""
    var strAvatar: String = ""
    var strTotalItems: String = ""
    var strTotalAmount: String = ""
    var strCurrentStatus: String = ""
    var strReferenceId: String = ""
    var strCreatedAt: String = ""
    
    var date = Date()
    var currentDate = Date()
    var strRemainingTime = ""
    
    init(dict : [String:Any]) {
        super.init()
        if let OrderID = dict["OrderID"]  as? String{
            self.strOrderID = OrderID
        }else if let OrderID = dict["OrderID"]  as? Int{
            self.strOrderID = "\(OrderID)"
        }
        if let restaurantName = dict["restaurant_name"] as? String{
            self.strRestaurantName = restaurantName
        }
        if let avatar = dict["restaurant_image"] as? String{
            self.strAvatar = avatar
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
        
        if let number = dict["number"] as? String{
            self.strReferenceId = number
        }
        self.strCreatedAt = dict["created_at"] as? String ?? ""

        if self.strCreatedAt != ""{
            self.date = self.strCreatedAt.dateWithFormat(format: "yyyy-MM-dd HH:mm:ss")
            self.currentDate = UpcomingListDateTime.dateWithFormat(format: "yyyy-MM-dd HH:mm:ss")
            self.strRemainingTime = relativePastTime(for: self.date, currentDate: self.currentDate)
        }
        
    }
    
    func relativePastTime(for date : Date,currentDate : Date) -> String {

        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: currentDate)

        if components.year! > 0 {
            return "\(components.year!) " + (components.year! > 1 ? "years ago".localize : "year ago".localize)

        } else if components.month! > 0 {
            return "\(components.month!) " + (components.month! > 1 ? "months ago".localize : "month ago".localize)

        } else if components.weekOfYear! > 0 {
            return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "weeks ago".localize : "week ago".localize)

        } else if (components.day! > 0) {
            return (components.day! > 1 ? "\(components.day!) \("days ago".localize)" : "Yesterday".localize)

        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago".localize : "hour ago".localize)

        } else if components.minute! > 0 {
            return "\(components.minute!) " + (components.minute! > 1 ? "minutes ago".localize : "minute ago".localize)

        } else {
           // return "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
            return "Just now".localize
        }
    }
    
}

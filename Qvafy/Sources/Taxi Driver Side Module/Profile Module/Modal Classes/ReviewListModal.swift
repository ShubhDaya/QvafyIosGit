//
//  ReviewListModal.swift
//  Qvafy
//
//  Created by ios-deepak b on 22/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import Foundation

import UIKit

class ReviewListModal: NSObject {

        var strRating: String = ""
        var strRatingID: String = ""
        var strCreatedAt: String = ""
        var strReview: String = ""
        var strUserImage: String = ""
        var strFullName: String = ""
    var date = Date()
    var currentDate = Date()
    var strRemainingTime = ""
        init(dict : [String:Any]) {
            super.init()
            if let ratingID = dict["ratingID"]  as? String{
                self.strRatingID = ratingID
            }else if let ratingID = dict["ratingID"]  as? Int{
                self.strRatingID = "\(ratingID)"
            }
          
            self.strCreatedAt = dict["created_at"] as? String ?? ""
            self.strFullName = dict["full_name"] as? String ?? ""
            self.strRating = dict["rating"] as? String ?? ""
            self.strReview = dict["review"] as? String ?? ""
            self.strUserImage = dict["user_image"] as? String ?? ""
            
            if self.strCreatedAt != ""{
                self.date = self.strCreatedAt.dateWithFormat(format: "yyyy-MM-dd HH:mm:ss")
                self.currentDate = currentDateForReview.dateWithFormat(format: "yyyy-MM-dd HH:mm:ss")
                self.strRemainingTime = relativePastTime(for: self.date, currentDate: self.currentDate)
            }
}
}
extension ReviewListModal{
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
          //  return "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
            return "Just now".localize
        }
    }
}

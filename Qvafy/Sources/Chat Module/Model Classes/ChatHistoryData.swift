//
//  ChatHistoryData.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit

class user: NSObject {

var str_Name: String = ""
var str_ProfileImage: String = ""
var isOnline: String = ""
var userType: String = ""
var userId: String = ""
}

class ChatHistoryData: Equatable {
    

    var userId = ""
    var chatId = ""
    var chatType = ""
    var time: Double = 0.0
    var strDateTime = ""
    var unreadCount = 0
    var str_imageURL = ""
    var str_Type = ""
    var str_isImage = 0
    var str_Name = ""
    var str_message = ""
    var str_ProfileImage = ""
    var isBlocked = "0"
    var isOnline = ""
    var strOrdernumber = ""
    
    var strProductName  = ""
    var strProductImage  = ""
    var strBuyerId = ""
    var strSellerId = ""
    var strOppentId = ""
    var strChatHistoryId = ""
    var isOffer = 0
    var isTyping = 0
       
     var strOrderRideId = ""
     var strMsgReadTick = ""
    var strKey = ""
     var userType = ""
    static func == (lhs: ChatHistoryData, rhs: ChatHistoryData) -> Bool {
        return lhs.userId == rhs.userId
    }
}

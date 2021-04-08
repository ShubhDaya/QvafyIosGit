//
//  ChatData.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit
import Firebase

class ChatData: Equatable {
    
    var calendarDate = ServerValue.timestamp()
    
    var strKey = ""
  
    var strOrderRideId = ""
    var strReferenceId = ""
    var strOppId = ""
    var strOppName = ""
    var strImageURL = ""
    var strIsImage = 0
    var strMessage = ""
    var isMsgRead = 0
    var strTimeStamp = ""
    var TimeStamp:Double = 0
    var strRelativePastTime = ""
    
    static func == (lhs: ChatData, rhs: ChatData) -> Bool {
        return lhs.strKey == rhs.strKey
    }
}

class DisputeChatData: Equatable {
    
    
    
    var calendarDate = ServerValue.timestamp()
    
    var strKey = ""
    var strOppId = ""
    var strOppName = ""
    var strImageURL = ""
    var strIsImage = 0
    var strMessage = ""
    var isMsgRead = 0
    var strTimeStamp = ""
    var TimeStamp:Double = 0
    var strRelativePastTime = ""
    
    static func == (lhs: DisputeChatData, rhs: DisputeChatData) -> Bool {
         return lhs.strKey == rhs.strKey
    }
}

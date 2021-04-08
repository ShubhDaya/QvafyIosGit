//
//  CustomText.swift
//  Qvafy
//  Created by IOS-Shubham-40 on 15/02/21.
//  Copyright © 2021 IOS-Aradhana-cat. All rights reserved.

import Foundation
import UIKit

class TextField: UITextField {

}

class CustomTextField: UITextField {
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        if action == #selector(select(_:)) {
                   return false
               }
               if action == #selector(selectAll(_:)) {
                   return false
               }
               if action == #selector(cut(_:)) {
                   return false
               }
               if action == #selector(copy(_:)) {
                   return false
               }
               if action == #selector(paste(_:)) {
                   return false
               }
               if action == #selector(delete(_:)) {
                   return false
               }
               return super.canPerformAction(action, withSender: sender)
      }
}

class CustomTextView: UITextView {

 override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
        return false
    }
    if action == #selector(select(_:)) {
               return false
           }
           if action == #selector(selectAll(_:)) {
               return false
           }
           if action == #selector(cut(_:)) {
               return false
           }
           if action == #selector(copy(_:)) {
               return false
           }
           if action == #selector(paste(_:)) {
               return false
           }
           if action == #selector(delete(_:)) {
               return false
           }
           return super.canPerformAction(action, withSender: sender)
  }
}

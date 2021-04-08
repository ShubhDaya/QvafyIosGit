//
//  CustomTextfield.swift
//  Qvafy
//
//  Created by IOS-Shubham-40 on 15/02/21.
//  Copyright © 2021 IOS-Aradhana-cat. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
     func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "paste:" {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
}

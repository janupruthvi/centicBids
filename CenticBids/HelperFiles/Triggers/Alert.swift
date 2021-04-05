//
//  alert.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-04-02.
//

import Foundation
import UIKit

class Alert {
    
    //  method to present alert
    static func triggerAlert(title: String, msg: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}

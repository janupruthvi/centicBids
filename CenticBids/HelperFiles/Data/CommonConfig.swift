//
//  CommonConfig.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-30.
//

import Foundation

class CommonConfig {
    // Currency Value
    static let currencyString = "LKR"

    // Notification constants
    static let signInCompleted = Notification.Name("signInCompleted")
    static let signOutCompleted = Notification.Name("signOutCompleted")
    
    //Firebase realtime datebase
    static let realTimeDBName = "UpdateBidsLog"
    
    //amount generating method with currency value
    static func generateCurrencyAmt(Amt: Float) -> String {
        return "\(CommonConfig.currencyString) \(Amt)"
    }
    
    //generate Remaining Date with startDate & end Date
    static func generateDaysRemaining(toDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm:a"
        var dayRemainingString = ""
        let components = Calendar.current.dateComponents([.day, .hour], from: toDate, to: endDate)
        dayRemainingString = "\(components.day ?? 0)d \(components.hour ?? 0)h left"
        return dayRemainingString
    }
}

//  enum for sign in/out button text
enum LoginBtn: String {
    case signIn = "Sign In"
    case signOut = "Sign Out"
}



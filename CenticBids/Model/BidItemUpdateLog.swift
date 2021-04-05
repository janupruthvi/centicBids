//
//  BidItemUpdateLog.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-04-02.
//

import Foundation

struct BidItemUpdateLog: Codable {
    var bidItemId: String
    var bidItemName: String
    var latestBidAmt: Float
    var latestUpdatedUser: String
}

//
//  LatestBidAmtDataMapper.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-04-03.
//

import Foundation

class LatestBidAmtDataMapper {
    
    private let notificationSender = NotificationSender()
    
    //  method to observe bid item and notify users if a higher bid has been placed
    func observeBidAmtAndNotify() {
        AuctionListService.shared.bidAmtObserver(completion: {data in
            var bidItemUpdateLogList = [BidItemUpdateLog]()
            for (key, _) in data {
                print("key - ", key)
                if let dataById = data[key] as? [String: Any] {
                    print("dataById - ", dataById)
                    if let bidItemId = dataById["bidItemId"] as? String,
                       let bidItemName = dataById["bidItemName"] as? String,
                       let latestBidAmt = dataById["latestBidAmt"] as? Float,
                       let latestUpdatedUser = dataById["latestUpdatedUser"] as? String {
                        let bidItemUpdateLog = BidItemUpdateLog(bidItemId: bidItemId, bidItemName: bidItemName, latestBidAmt: latestBidAmt, latestUpdatedUser: latestUpdatedUser)
                        bidItemUpdateLogList.append(bidItemUpdateLog)
                    }
                }
            }
            self.findLatestBidAmt(itemsBidAmtLogDBdataList : bidItemUpdateLogList)
        })
    }
    
    private func findLatestBidAmt(itemsBidAmtLogDBdataList : [BidItemUpdateLog]) {
        for itemBidAmtLogdata in itemsBidAmtLogDBdataList {
            if let signInUser = SignInService.shared.getSignedInUser(), itemBidAmtLogdata.latestUpdatedUser == signInUser.uid {
                let userFilteredItemList = itemsBidAmtLogDBdataList.filter({$0.bidItemId == itemBidAmtLogdata.bidItemId})
                if !userFilteredItemList.isEmpty {
                    let sortedItemListByAmt = userFilteredItemList.sorted(by: {$0.latestBidAmt > $1.latestBidAmt})
                    if sortedItemListByAmt.first?.latestUpdatedUser != signInUser.uid {
                        self.notificationSender.sendNotification(title: "Centic Bids", subtitle: itemBidAmtLogdata.bidItemName, body: "Another user has been placed an higher bid for \(CommonConfig.currencyString) \(itemBidAmtLogdata.latestBidAmt)")
                    }
                }
        
            }
        }
    }
}

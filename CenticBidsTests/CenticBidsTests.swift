//
//  CenticBidsTests.swift
//  CenticBidsTests
//
//  Created by Pruthvi Nithyanandan on 2021-04-04.
//

import XCTest
@testable import CenticBids

class CenticBidsTests: XCTestCase {

    func testGenerateCurrencyAmt() {
        
        let currencyString = CommonConfig.currencyString
        let currencyValueResult = CommonConfig.generateCurrencyAmt(Amt: 123.59)
        XCTAssertEqual(currencyValueResult, "\(currencyString) 123.59")
        
    }
    
    func testGenerateDaysRemaining() {
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let startDate = formatter.date(from: "2020/04/04 10:31")
        let endDate = formatter.date(from: "2020/04/08 22:31")
        
        let remainingDaysString = CommonConfig.generateDaysRemaining(toDate: startDate!, endDate: endDate!)
        XCTAssertEqual(remainingDaysString, "4d 12h left")
        
    }
    
    func testGetAllBidItemData() {
        let expectation = XCTestExpectation(description: "get data from firebase firestore")
        AuctionListService.shared.getAllBidItemData(completion: {bidItemData, error, success in
            XCTAssertNotNil(bidItemData, "No bidItemData")
            expectation.fulfill()
            if (success) {
                let bidItemList = (bidItemData?.compactMap { bidItemSnapshot -> BidItemModel? in
                    return try? bidItemSnapshot.data(as: BidItemModel.self)
                })
                XCTAssertTrue(bidItemList!.count > 0)
            }
        })
        wait(for: [expectation], timeout: 10.0)
    }

}

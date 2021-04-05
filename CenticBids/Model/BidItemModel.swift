//
//  BidItemModel.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-26.
//

import Foundation
import FirebaseFirestoreSwift

struct BidItemModel:Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var basePrice: Float
    var latestBid: Float?
    var imagesUrls: [String]?
    var startDate: Date?
    var endDate: Date?
}

//
//  AuctionListService.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-31.
//

import Foundation
import Firebase

class AuctionListService {
    
    static let shared = AuctionListService()
    private init() {}
    
    // database instance from firebase firestore
    private let db = Firestore.firestore()
    
    // database reference from firebase real time database
    let ref: DatabaseReference = Database.database().reference()
    
    
    func getAllBidItemData(completion:@escaping(_ data:[DocumentSnapshot]?, _ errorMsg:String?, _ success:Bool) ->()) {
        db.collection("bidItem").getDocuments { (querySnapshot, err) in
            
            if let err = err {
                completion(nil, err.localizedDescription, false)
                print("Error getting documents: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    return
                }
                completion(documents, nil, true)
            }
        }
        
    }
    
    //  method to update bid item user update in firebase firestore
    func updateBidAmt(id:String ,bidAmt: Float, itemName:String, completion:@escaping(_ success:Bool, _ error:String?) -> ()) {
        db.collection("bidItem").document(id).setData([ "latestBid": bidAmt ], merge: true){ err in
            if let err = err {
                completion(false, err.localizedDescription)
                print("Error writing document: \(err)")
            } else {
                completion(true, nil)
                if let currentUser = SignInService.shared.getSignedInUser() {
                    let bidItemLogData: [String: Any] =  ["bidItemId": id,
                                                          "bidItemName": itemName,
                                                          "latestBidAmt": bidAmt,
                                                          "latestUpdatedUser": currentUser.uid]
                    self.bidAmtLogUpdate(bidItemLogData: bidItemLogData)
                }
                print("Document successfully written!")
            }
        }

    }
    
    // subscription method to observe bid item user update
    func bidAmtObserver(completion:@escaping(_ data:NSDictionary) -> ()) {
        self.ref.child(CommonConfig.realTimeDBName).observe(.value , with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          completion(value ?? [:])
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //  method to update bid item user update in firebase real time DB
    func bidAmtLogUpdate(bidItemLogData: [String: Any]) {
        let uuid = UUID().uuidString
        self.ref.child(CommonConfig.realTimeDBName).child(uuid).setValue(bidItemLogData)
    }
    

    
    
}

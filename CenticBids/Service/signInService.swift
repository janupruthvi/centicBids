//
//  signInService.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-30.
//

import Foundation
import FirebaseAuth

class SignInService {
    
    static let shared = SignInService()
    private init() {}
    
    func signInUser(email: String, password: String, completion: @escaping(_ success: Bool, _ msg: String) -> ()) {
        // sign in API from firebase
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult != nil {
                completion(true, "")
            } else {
                completion(false, error?.localizedDescription ?? "")
            }
        }
    }
    
    func signOutUser(completion:(_ success: Bool, _ msg: String)->()) {
        do {
        // sign out API from firebase
          try Auth.auth().signOut()
            completion(true, "")
        } catch let signOutError as NSError {
            completion(false, signOutError.localizedDescription)
        }
    }
    
    func getSignedInUser() -> User? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!
        } else {
            return nil
        }
    }
}

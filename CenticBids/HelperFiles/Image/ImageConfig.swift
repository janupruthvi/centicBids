//
//  ImageConfig.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-04-04.
//

import Foundation
import UIKit

class ImageConfig {
    
    //  asynchronous method to load image
    static func loadImage(url: URL, completion: @escaping(_ image: UIImage)->()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }
    }
    
}

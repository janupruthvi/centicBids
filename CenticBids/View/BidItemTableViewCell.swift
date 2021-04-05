//
//  BidItemTableViewCell.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-26.
//

import UIKit

class BidItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var basePriceLbl: UILabel!
    @IBOutlet weak var latestBidLbl: UILabel!
    @IBOutlet weak var daysLeftLbl: UILabel!
    @IBOutlet weak var backgrdView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }

    
    func setUpView() {
        // Initialization of UI
        self.backgrdView.backgroundColor = .white
        self.backgrdView.layer.borderWidth = 1
        self.backgrdView.layer.borderColor = UIColor(ciColor: .gray).cgColor
        self.backgrdView.layer.cornerRadius = 5
        self.contentView.backgroundColor = .systemGray6
        
        self.descLbl.lineBreakMode = .byWordWrapping
        self.descLbl.numberOfLines = 3
    }
    
    func loadImage(url: URL) {
        // Asynchronous image load
        ImageConfig.loadImage(url:url, completion: {image in
            DispatchQueue.main.async {
                self.itemImage.image = image
                self.itemImage.contentMode = UIView.ContentMode.scaleAspectFit
            }
        })
    }
    
}

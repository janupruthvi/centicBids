//
//  AuctionListViewController.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-26.
//

import UIKit

class AuctionListViewController: UIViewController {

    @IBOutlet weak var auctionListTblView: UITableView!
    @IBOutlet weak var signInBtn: UIBarButtonItem!
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var signedInUserLbl: UILabel!
    
    var bidItemList: [BidItemModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.notificationObservers()
        self.confSignInView()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // fetch data when the navigating to this screen
        self.getAllBidItemData()
    }
    
    deinit {
        // removing the observers
        NotificationCenter.default.removeObserver(self, name: CommonConfig.signInCompleted, object: nil)
        NotificationCenter.default.removeObserver(self, name: CommonConfig.signOutCompleted, object: nil)
    }
    
    // registering the table view cell for auction item list
    func registerNib() {
        self.auctionListTblView.register(UINib(nibName: "BidItemTableViewCell", bundle: nil), forCellReuseIdentifier: "BidItemTableViewCell")
    }
    
    // initializing UI
    func setUpView() {
        self.headerBackgroundView.layer.cornerRadius = 5
        self.headerBackgroundView.layer.borderWidth = 0.7
        self.headerBackgroundView.layer.borderColor = UIColor(ciColor: .gray).cgColor
    }
    
    // subscription method for sign in/out action
    func notificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeViewForSignInObserver(notification:)), name: CommonConfig.signInCompleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeViewForSignInObserver(notification:)), name: CommonConfig.signOutCompleted, object: nil)
    }
    
    // initializing sign in view based on sign in state
    func confSignInView() {
        let user = SignInService.shared.getSignedInUser()
        if user != nil {
            self.signInBtn.title = LoginBtn.signOut.rawValue
            self.signedInUserLbl.text = "Welcome \(user?.email ?? "")"
            self.signedInUserLbl.isHidden = false
        } else {
            self.signInBtn.title = LoginBtn.signIn.rawValue
            self.signedInUserLbl.isHidden = true
        }
    }
    
    // method to fetch biditem data for table view
    func getAllBidItemData() {
        AuctionListService.shared.getAllBidItemData(completion: {bidItemData, error, success in
            if (success) {
                DispatchQueue.main.async {
                    self.bidItemList = bidItemData?.compactMap { bidItemSnapshot -> BidItemModel? in
                        return try? bidItemSnapshot.data(as: BidItemModel.self)
                    }
                    self.auctionListTblView.reloadData()
                    
                }
            } else {
                let alert = Alert.triggerAlert(title: "Error", msg: error ?? "")
                self.present(alert, animated: true)
            }
        })
    }
    
    // method to navigate the selected item screen
    func loadDetailsScreen(bidItem: BidItemModel){
        let auctionDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "auctionDetailsVC") as! AuctionItemDetailsViewController
        auctionDetailsVC.bidItemData = bidItem
        self.navigationController?.pushViewController(auctionDetailsVC, animated: true)
        
    }
    
    // Trigger this even for sign in/out observer
    @objc func changeViewForSignInObserver(notification:NSNotification) {
        self.confSignInView()
    }
    
    // present sign in form
    func loadSignInScreen() {
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signInModalVC") as! signInViewController
        signInVC.modalPresentationStyle = .overCurrentContext
        signInVC.modalTransitionStyle = .crossDissolve
        self.present(signInVC, animated: true)
    }
    
    // sign in bitton pressed from navigation panel
    @IBAction func signInBtnPressed(_ sender: UIBarButtonItem) {
        if sender.title == LoginBtn.signIn.rawValue {
            loadSignInScreen()
        } else {
            SignInService.shared.signOutUser(completion: {success, msg in
                if success {
                    NotificationCenter.default.post(name: CommonConfig.signOutCompleted, object: nil)
                } else {
                    print("error", msg)
                    let alert = Alert.triggerAlert(title: "Error", msg: msg)
                    self.present(alert, animated: true)
                }
            })
        }
    }
    

}

extension AuctionListViewController: UITableViewDelegate, UITableViewDataSource {
    // table view delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bidItemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 115
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidItemTableViewCell", for: indexPath) as! BidItemTableViewCell
        let bidItem = self.bidItemList?[indexPath.row]
        cell.titleLbl.text = bidItem?.title
        cell.descLbl.text = bidItem?.description
        if let basePrice = bidItem?.basePrice {
            cell.basePriceLbl.text = CommonConfig.generateCurrencyAmt(Amt: basePrice)
        }
        if let latestBid = bidItem?.latestBid {
            cell.latestBidLbl.text = CommonConfig.generateCurrencyAmt(Amt: latestBid)
        } else {
            cell.latestBidLbl.text = "\(CommonConfig.currencyString) 0.0"
        }
        if let imageUrl = bidItem?.imagesUrls?.first {
            cell.loadImage(url: URL(string: imageUrl)!)
        }
        if let startDate = bidItem?.startDate, let endDate = bidItem?.endDate  {
            cell.daysLeftLbl.text = CommonConfig.generateDaysRemaining(toDate: startDate, endDate: endDate)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bidItem = self.bidItemList?[indexPath.row] {
            self.loadDetailsScreen(bidItem: bidItem)
        }
    }
    
}

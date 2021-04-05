//
//  AuctionItemDetailsViewController.swift
//  CenticBids
//
//  Created by Pruthvi Nithyanandan on 2021-03-29.
//

import UIKit

class AuctionItemDetailsViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var basePriceLbl: UILabel!
    @IBOutlet weak var LatestBidLbl: UILabel!
    @IBOutlet weak var bidAmtView: UIView!
    @IBOutlet weak var remainingTimeLbl: UILabel!
    @IBOutlet weak var signInBtn: UIBarButtonItem!
    @IBOutlet weak var daysLeftLbl: UILabel!
    var bidAmtField:UITextField?
    
    var bidItemData: BidItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpDataForDisplay()
        self.addDoneButtonOnKeyboard()
    }
    
    deinit {
        // removing the observers
        NotificationCenter.default.removeObserver(self, name: CommonConfig.signInCompleted, object: nil)
        NotificationCenter.default.removeObserver(self, name: CommonConfig.signOutCompleted, object: nil)
    }
    
    // initializing UI
    func setUpView() {
        self.imageCV.layer.borderColor = UIColor.gray.cgColor
        self.imageCV.layer.borderWidth = 0.5
        self.imageCV.layer.cornerRadius = 5
        self.notificationObservers()
        self.setUpViewForLoginState()
        self.descriptionLbl.isUserInteractionEnabled = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.imageCV.collectionViewLayout = layout
    }
    
    // method to initialize and map data to dispaly on view
    func setUpDataForDisplay() {
        if let bidItem = bidItemData {
            self.titleLbl.text = bidItem.title
            self.descriptionLbl.text = bidItem.description
            self.basePriceLbl.text = "\(CommonConfig.currencyString) \(bidItem.basePrice)"
            self.LatestBidLbl.text = "\(CommonConfig.currencyString) \(bidItem.latestBid ?? 0)"
            self.daysLeftLbl.isHidden = true
            if let fromDt = bidItem.startDate, let toDt = bidItem.endDate {
                self.daysLeftLbl.text = "Remaining Time: " + CommonConfig.generateDaysRemaining(toDate: fromDt, endDate: toDt)
                self.daysLeftLbl.isHidden = false
            }
            
        }
    }
    
    // method to initialize sign in button programatically on details screen section
    func confSignInBtn() {
        let frameObj = self.bidAmtView.bounds
        let signInBtn = UIButton(frame: CGRect(x: frameObj.minX,
                                               y: frameObj.height / 2,
                                               width: 200,
                                               height: 40))
        signInBtn.setTitle("Sign In to bid", for: .normal)
        signInBtn.tintColor = .white
        signInBtn.backgroundColor = .systemBlue
        signInBtn.addTarget(self, action: #selector(signInBtnAction), for: .touchUpInside)
        self.bidAmtView.addSubview(signInBtn)
        
        signInBtn.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: signInBtn, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.bidAmtView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: signInBtn, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.bidAmtView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: signInBtn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        let heightConstraint = NSLayoutConstraint(item: signInBtn, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
        self.bidAmtView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
    }
    
    // method to initialize bid button programatically on details screen section
    func confBidTextField() {
        let frameObj = self.bidAmtView.bounds
        let yPosition = (self.bidAmtView.bounds.midY / 2) - 20
        
        let currencyLabel = UILabel(frame: CGRect(x: frameObj.minX + 10,
                                                  y: yPosition,
                                                  width: 25,
                                                  height: 40))
        
        currencyLabel.text = CommonConfig.currencyString
        currencyLabel.adjustsFontSizeToFitWidth = true
        
        let bidAmtField = UITextField(frame: CGRect(x: currencyLabel.frame.maxX + 5,
                                                    y: yPosition,
                                                    width: 130,
                                                    height: 40))
        bidAmtField.borderStyle = .roundedRect
        bidAmtField.placeholder = "Enter Amt"
        bidAmtField.keyboardType = .decimalPad
        
        let bidNowBtn = UIButton(frame: CGRect(x: bidAmtField.frame.maxX,
                                               y: yPosition,
                                               width: 100,
                                               height: 40))
        bidNowBtn.setTitle("Bid Now", for: .normal)
        bidNowBtn.setTitleColor(.black, for: .normal)
        bidNowBtn.backgroundColor = .green
        bidNowBtn.addTarget(self, action: #selector(updateBidAmountForItem), for: .touchUpInside)
        bidAmtField.delegate = self
        self.bidAmtField = bidAmtField
        self.bidAmtView.addSubview(bidAmtField)
        self.bidAmtView.addSubview(bidNowBtn)
        self.bidAmtView.addSubview(currencyLabel)
    }
    
    // method to determine sign in view or bid view to be displayed
    func setUpViewForLoginState() {
        
        let subviews = self.bidAmtView.subviews
        for view in subviews {
            view.removeFromSuperview()
        }
        let user = SignInService.shared.getSignedInUser()
        if user != nil {
            self.confBidTextField()
            self.signInBtn.title = LoginBtn.signOut.rawValue
        } else {
            self.confSignInBtn()
            self.signInBtn.title = LoginBtn.signIn.rawValue
        }
        
    }
    
    // subscription method for sign in/out action
    func notificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeViewForSignInObserver(notification:)), name: CommonConfig.signInCompleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeViewForSignInObserver(notification:)), name: CommonConfig.signOutCompleted, object: nil)
    }
    
    @objc func changeViewForSignInObserver(notification:NSNotification) {
        self.setUpViewForLoginState()
    }
    
    // present sign in form
    func loadSignInScreen() {
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signInModalVC") as! signInViewController
        signInVC.modalPresentationStyle = .overCurrentContext
        signInVC.modalTransitionStyle = .crossDissolve
        self.present(signInVC, animated: true)
    }
    
    //  sign in button pressed from items detail section
    @objc func signInBtnAction(sender: UIButton!) {
        self.loadSignInScreen()
    }
    
    // method trigger when bid now button pressed
    @objc func updateBidAmountForItem(){
        guard let bidAmt = self.bidAmtField?.text, let bidItemId = self.bidItemData?.id, let bidItemName = self.bidItemData?.title else {
            return
        }
        let bidAmtFloat = (bidAmt as NSString).floatValue
        AuctionListService.shared.updateBidAmt(id: bidItemId, bidAmt: bidAmtFloat, itemName: bidItemName, completion: {success, error in
            if (success) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                let alert = Alert.triggerAlert(title: "Error", msg: error ?? "")
                self.present(alert, animated: true)
            }
        })
    }
    
    //  sign in button pressed from navigation panel
    @IBAction func signInBtnPressed(_ sender: UIBarButtonItem) {
        if sender.title == LoginBtn.signIn.rawValue {
            // present sign in form
            loadSignInScreen()
        } else {
            // sign out user
            SignInService.shared.signOutUser(completion: {success, msg in
                if success {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: CommonConfig.signOutCompleted, object: nil)
                    }
                } else {
                    
                }
            })
        }
    }
    
    

}

extension AuctionItemDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // collection view delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bidItemData?.imagesUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemImageCell", for: indexPath)
        if let itemImage = self.bidItemData?.imagesUrls?[indexPath.row] {
            let imageView = UIImageView(frame: cell.bounds)
            if let imgUrl = URL(string: itemImage) {
                ImageConfig.loadImage(url:imgUrl, completion: {image in
                    DispatchQueue.main.async {
                        imageView.image = image
                        imageView.contentMode = UIView.ContentMode.scaleAspectFit
                        cell.addSubview(imageView)
                    }
                })
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 5
        let width = collectionView.frame.width - 3
        return CGSize(width: 250, height: height)
    }
    
}

extension AuctionItemDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            self.animateTextFieldMoving(up: true, moveValue: 242)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            self.animateTextFieldMoving(up: false, moveValue: 242)
    }

    func animateTextFieldMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.bidAmtField?.inputAccessoryView = doneToolbar

    }

    @objc func doneButtonAction()
    {
        self.bidAmtField?.resignFirstResponder()
    }
    
}

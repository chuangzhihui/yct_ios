//
//  ContactDetailVC.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/21/24.
//

import UIKit

class ContactDetailVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    @IBOutlet weak var lblOfficialWeb: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblTitleOfficalWeb: UILabel!
    @IBOutlet weak var lblSocialMedia: UILabel!
    @IBOutlet weak var lblFB: UILabel!
    @IBOutlet weak var lblTwitter: UILabel!
    @IBOutlet weak var lblYoutube: UILabel!
    @IBOutlet weak var lblContactInfoTitle: UILabel!
    
    //MARK: - Variables & Constants
    var filterData: [TradeFilterModel] = [
        TradeFilterModel(title: "   All    ".localizeString(), count: 0, isSelected: true),
        TradeFilterModel(title: " Email ".localizeString(), count: 0),
        TradeFilterModel(title: " Whatsapp ".localizeString(), count: 0),
        TradeFilterModel(title: " Telephone ".localizeString(), count: 0),
    ]
    var selectedIndex: Int = 0
    var companyName: String = ""
    var contactDetailVM: ContactDetailVM = ContactDetailVM()
    var contatcData: ContactDetailModel?
    var filteredContacts: [ContactData] = []
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        contactDetailVM.delegate = self
        configureTableView()
        configureCollectionView()
        configureLanguage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showLoader()
        contactDetailVM.contactDetailAPI(companyName: companyName)
    }
    
    //MARK: - Custom Functions
    func configureLanguage() {
        lblHeader.text = "Contact Details".localizeString()
        lblTitleOfficalWeb.text = "Official Website".localizeString()
        lblSocialMedia.text = "Social Media".localizeString()
        lblFB.text = "Facebook".localizeString()
        lblTwitter.text = "Twitter".localizeString()
        lblYoutube.text = "Youtube".localizeString()
        lblContactInfoTitle.text = "Contact Information".localizeString()
    }
    
    func configureTableView() {
        let tableCellNib = UINib(nibName: "ContactDetailTableViewCell", bundle: nil)
        contactTableView.register(tableCellNib, forCellReuseIdentifier: "ContactDetailTableViewCell")
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
    
    func configureCollectionView() {
        let cellNib = UINib(nibName: "TradeFilterCell", bundle: nil)
        filterCollectionView.register(cellNib, forCellWithReuseIdentifier: "TradeFilterCell")
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
    }
    
    func filterContacts(by type: String?) {
        guard let contacts = contatcData?.contacts else { return }
        if let type = type {
            filteredContacts = contacts.filter { $0.type == type }
        } else {
            filteredContacts = contacts // Show all contacts
        }
        contactTableView.reloadData()
    }
    
    func handleSocialMedia(type: String) {
        guard let contacts = contatcData?.contacts else { return }
        let filteredLinks = contacts.filter { $0.type == type && !($0.value?.isEmpty ?? true) }
        
        if let firstLink = filteredLinks.first?.value, let url = URL(string: firstLink) {
            openURLInBrowser(url: url)
        } else {
            self.showAlert(message: "No valid \(type) link found.")
        }
    }
    
    func openURLInBrowser(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            self.showAlert(message: "Unable to open the link.")
        }
    }

    //MARK: - Custom ACTIONS
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func faceBookTapped(_ sender: UIButton) {
        handleSocialMedia(type: "facebook")
    }
    
    @IBAction func twitterTapped(_ sender: UIButton) {
        handleSocialMedia(type: "twitter")
    }
    
    @IBAction func youtubeTapped(_ sender: UIButton) {
        handleSocialMedia(type: "youtube")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ContactDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "TradeFilterCell", for: indexPath) as! TradeFilterCell
        
        let isCountZero = filterData[indexPath.row].count == 0
        let title = isCountZero ? filterData[indexPath.row].title : "\(filterData[indexPath.row].title) (\(filterData[indexPath.row].count))"
        cell.lblTitle.text = title
        
        if filterData[indexPath.row].isSelected {
            cell.viewBack.backgroundColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            cell.lblTitle.textColor = UIColor.white
        } else {
            cell.viewBack.borderColor = UIColor.hexStringToUIColor(hex: "#022EA9")
            cell.viewBack.borderWidth = 1
            cell.viewBack.backgroundColor = UIColor.white
            cell.lblTitle.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = filterData.firstIndex(where: { $0.isSelected == true }) {
            filterData[index].isSelected = false
        }
        filterData[indexPath.row].isSelected = true
        filterCollectionView.reloadData()
        
        selectedIndex = indexPath.row
        switch filterData[indexPath.row].title {
        case " Email ":
            filterContacts(by: "email")
        case " Whatsapp ":
            filterContacts(by: "whatsapp")
        case " Telephone ":
            filterContacts(by: "telephone")
        case "   All   ":
            filterContacts(by: nil) // Show all
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ContactDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredContacts.isEmpty {
            return contatcData?.contacts?.count ?? 0//
        } else {
            return filteredContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell", for: indexPath) as! ContactDetailTableViewCell
        
        cell.vc = self
        let obj = filteredContacts.isEmpty ? (contatcData?.contacts?[indexPath.row]) : filteredContacts[indexPath.row]
        cell.configureCell(obj: obj)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}


extension ContactDetailVC: ContactDetailDelegate {
    func didReceiveContactDetailResponse(response: ContactDetailModel?, error: String?) {
        self.hideLoader()
        
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                contatcData = response
                lblOfficialWeb.text = response?.contacts?.first?.value ?? "-- --"
                contactTableView.reloadData()
            } else {
                self.showAlert(message: error ?? "")
            }
        }
    }
}

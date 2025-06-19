//
//  SearchCountryVC.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/6/24.
//

import UIKit
import CountryPicker

class SearchCountryVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var countryList = [Country]()
    var filteredCountryNames = [Country]()

//    var onSelectedCountry:((String) ->Void)?
    var searchActive: Bool = false
    var onSelectedCountry: ((String, String) -> Void)?
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        filteredCountryNames = countryList
        searchTextField.addTarget(self, action: #selector(searchCountry), for: .editingChanged)
        loadCountries()
    }
    
    //MARK: - Custom Functions
    func loadCountries() {
        countryList = CountryManager.shared.countries
        filteredCountryNames = countryList
    }

    func configureTableView() {
        let tableCellNib = UINib(nibName: "CountryCodeTableViewCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "CountryCodeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func searchCountry() {
        guard let searchText = searchTextField.text?.lowercased() else { return }
        
        if searchText.isEmpty {
            filteredCountryNames = countryList
        } else {
            filteredCountryNames = countryList.filter { country in
                country.countryName.lowercased().contains(searchText) ||
                (country.dialingCode?.contains(searchText) ?? false)
            }
        }
        tableView.reloadData() // Reload the table with filtered data
    }

    
    //MARK: - Custom Actions
    @IBAction func backButtonTappd(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
// MARK: - UITableViewDelegate UITableViewDataSource
extension SearchCountryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountryNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeTableViewCell", for: indexPath) as! CountryCodeTableViewCell
        let country = filteredCountryNames[indexPath.row]
        cell.lblCountryCodeName.text = country.countryName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = filteredCountryNames[indexPath.row]
        dismiss(animated: true) {
            self.onSelectedCountry?(selectedCountry.countryName, selectedCountry.countryCode)
        }
    }
}

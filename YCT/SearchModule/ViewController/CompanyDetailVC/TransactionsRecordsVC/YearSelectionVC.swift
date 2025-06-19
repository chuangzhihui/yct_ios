//
//  YearSelectionVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 02/12/2024.
//

import UIKit

class YearSelectionVC: UIViewController {

    @IBOutlet weak var yearTableView: UITableView!
    
    var currentYear: Int = 0
    var callBack: ((Int) -> ())?
    var yearArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        yearArray = getLastFiveYears()
        yearTableView.reloadData()
        
    }
    
    func configureTableView() {
        let cellNib = UINib(nibName: "YearTableCell", bundle: nil)
        yearTableView.register(cellNib, forCellReuseIdentifier: "YearTableCell")
        yearTableView.delegate = self
        yearTableView.dataSource = self
    }
    
    func getLastFiveYears() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (currentYear - 4...currentYear).map { $0 }
    }

    

    @IBAction func crossTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
}

extension YearSelectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yearArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = yearTableView.dequeueReusableCell(withIdentifier: "YearTableCell", for: indexPath) as! YearTableCell
        
        cell.lblYear.text = "\(yearArray[indexPath.row])"
        if currentYear == yearArray[indexPath.row] {
            cell.lblYear.textColor = UIColor.hexStringToUIColor(hex: "#022EA9")
        } else {
            cell.lblYear.textColor = UIColor.black
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: false) {
            self.callBack?(self.yearArray[indexPath.row])
        }
    }
}

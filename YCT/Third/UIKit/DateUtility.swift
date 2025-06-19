//
//  DateUtility.swift
//  YCT
//
//  Created by Huzaifa Munawar on 10/11/2024.
//

import Foundation
import UIKit

struct DateUtility {
    
    static func convertTime(miliseconds: Int64) -> String {
        
        var seconds: Int64 = 0
        var minutes: Int64 = 0
        var hours: Int64 = 0
        var days: Int64 = 0
        var secondsTemp: Int64 = 0
        var minutesTemp: Int64 = 0
        var hoursTemp: Int64 = 0
        var totalHours: Int64 = 0
        let customLightGray = #colorLiteral(red: 0.4549018741, green: 0.4549018741, blue: 0.4549018741, alpha: 1)
        
        if miliseconds < 1000 {
            return "0 hr"
            
        } else if miliseconds < 1000 * 60 {
            seconds = miliseconds / 1000
            return "\(seconds) s"
            
        } else if miliseconds < 1000 * 60 * 60 {
            secondsTemp = miliseconds / 1000
            minutes = secondsTemp / 60
            seconds = (miliseconds - minutes * 60 * 1000) / 1000
            
            return "\(minutes) m"
            
        } else if miliseconds < 1000 * 60 * 60 * 24 {
            minutesTemp = miliseconds / 1000 / 60
            hours = minutesTemp / 60
            minutes = (miliseconds - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            
            if hours == 1 {
                return "\(hours) hr"
            }
            return "\(hours) HRS"
            
        } else {
            hoursTemp = miliseconds / 1000 / 60 / 60
            days = hoursTemp / 24
            hours = (miliseconds - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60
            minutes = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            
            if(days >= 1){
                totalHours = (days * 24) + hours
            }
            
            return "\(totalHours) HRS"
        }
    }
    
    static func numberOfDaysBetween(from: Date,to: Date) -> Int {
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: from)
        let date2 = calendar.startOfDay(for: to)
        let numberOfDays = calendar.dateComponents([.day], from: date1, to: date2)
        return numberOfDays.day! + 1
    }
    
    
    static func addDays(fromDate: Date? = Date(), numberOfDays: Int) -> Date? {
        
        if let futureDaysLater = Calendar.current.date(byAdding: .day, value: numberOfDays, to: fromDate ?? Date()) {
            return futureDaysLater
        } else {
            print("Error adding days to the date.")
            return nil
        }
    }
    
    static func calculateAge(from dateOfBirth: Date) -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year], from: dateOfBirth, to: currentDate)
        let age = components.year ?? 0
        
        return age
    }
    
    static func sharedDateFormatterToSendToServerWithSeconds() -> DateFormatter {
        let sharedDateFormatter = DateFormatter()
        sharedDateFormatter.timeZone = TimeZone(identifier: "UTC")
        sharedDateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return sharedDateFormatter
    }
    
    static func getCurrentTimeZone() -> String {
        let localTimeZone = TimeZone.current
        let localAbbreviation = localTimeZone.abbreviation() ?? ""
        return localAbbreviation
    }
    
    static  func numberOfWeeksInMonthFromDate(_ date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let weekRange = calendar.range(of: .weekOfMonth,
                                       in: .month,
                                       for: date)
        return weekRange!.count
    }
    
    static  func numberOfDaysInMonthFromDate(_ date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        let weekRange = calendar.range(of: .day,
                                       in: .month,
                                       for: date)
        return weekRange!.count
    }
    
    static func currentDateForSchedule(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.string(from: date)
        return date
        
    }
    
    static func DateForHistory(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.string(from: date)
        return date
    }
    
    func is24HourFormat() -> Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.contains("H")
    }
    
    func convert24HourTo12HourFormat(_ inputDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Input format for 24-hour time
        
        if let date = dateFormatter.date(from: inputDate) {
            dateFormatter.dateFormat = "hh:mm a" // Output format for 12-hour time with AM/PM
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        } else {
            return "Invalid date format"
        }
    }
    
    
    static func presentDatePicker(from vc: UIViewController, shouldHideDays: Bool = false, datePickerMode: UIDatePicker.Mode = .date, initialDate: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil, dateSelected: @escaping (Date) -> Void) {
        // Create an action sheet
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create a UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.datePickerMode = datePickerMode
        if shouldHideDays {
            datePicker.datePickerMode = .init(rawValue: 4269) ?? .date // For Hiding Days
        }
        
        if let date = initialDate {
            datePicker.date = date
        }
        alertController.view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -60)
        ])
        
        let doneAction = UIAlertAction(title: "Done", style: .cancel) { _ in
            let selectedDate = datePicker.date
            dateSelected(selectedDate)
        }
        alertController.addAction(doneAction)
        
        // Configure popover presentation for iPad
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = vc.view
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        vc.present(alertController, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.view.heightAnchor.constraint(equalToConstant: 250).isActive = true // for iPad
        } else {
            alertController.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
    }
}

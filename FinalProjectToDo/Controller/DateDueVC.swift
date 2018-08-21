//
//  DateDueVC.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class DateDueVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    weak var delegate: DateDueDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.backgroundColor = UIColor.white
        timePicker.backgroundColor = UIColor.white
    }

    @IBAction func saveTapped(_ sender: Any) {
        let date = datePicker.date
        let time = timePicker.date
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, timeZone: calendar.timeZone, era: nil, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date), hour: calendar.component(.hour, from: time), minute: calendar.component(.minute, from: time), second: nil, nanosecond: nil, weekday: calendar.component(.weekday, from: date), weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let newDate = calendar.date(from: components)
        delegate.setDateDue(date: newDate!)
    }
}

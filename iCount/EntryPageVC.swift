//
//  EntryPageVC.swift
//  iCount
//
//  Created by Sadie Flick on 5/23/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import UIKit

class EntryPageVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var timeFramePicker: UIPickerView!
    @IBOutlet weak var limitPicker: UIPickerView!
    @IBOutlet weak var activityEntry: UITextField!
    @IBOutlet weak var goalNum: UITextField!
    
    var delegate: MyICountVC?
    var indexPath: IndexPath?
    var goal: Goal?
    
    
    var timeFrameOptions: [String] = ["per day", "per week", "per month"]
    var limitOptions: [String] = ["at least", "at most"]
    
    var period: String! = "per day"
    var countLimit: String! = "at least"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityEntry.text = goal?.goalTitle
        goalNum.text = goal?.times.description
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let count = Int32(goalNum.text!)
        var timeFrame: Int32
        var upLimit: Bool
        
        if period == "per day" {
            timeFrame = 1
        }
        else if period == "per week" {
            timeFrame = 7
        }
        else {
            timeFrame = 30
        }
        
        
        if countLimit == "at least" {
            upLimit = false
        }
        else {
            upLimit = true
        }
        
        
        delegate?.saveButtonPressed(num: 0, text: activityEntry.text, goalNum: count, period: timeFrame, upperBound: upLimit, sender: indexPath)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return timeFrameOptions.count
        }
        
        else {
            return limitOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return timeFrameOptions[row]
        }
        else {
            return limitOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("in did select row")
        if pickerView.tag == 1 {
            period = timeFrameOptions[row]
        }
        else if pickerView.tag == 2 {
            print("in assigning count else")
            countLimit = limitOptions[row]
        }
        
    }

}

//
//  ViewController.swift
//  iCount
//
//  Created by Sadie Flick on 5/23/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import UIKit
import CoreData

class MyICountVC: UIViewController , EntryPageVCDelegate, iCellDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [Goal] = [] 
    var testing: Bool = false

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchAllItems()

        tableView.rowHeight = 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchAllItems() {
        let request:NSFetchRequest<Goal> = Goal.fetchRequest()
        do {
            tableData = try context.fetch(request)
            // Here we can store the fetched data in an array
        } catch {

        }
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("In prepare")
        
        if segue.identifier == "mainSegue" {
            let navController = segue.destination as! UINavigationController
            let entryPageVC = navController.topViewController as! EntryPageVC
            entryPageVC.delegate = self

            if let ip = sender as? IndexPath {
                entryPageVC.indexPath = ip
                entryPageVC.goal = tableData[ip.row]
            }
        }
        
        else if segue.identifier == "ChartSegue" {
            let chartVC = segue.destination as! ChartVC
            if let ip = sender as! IndexPath? {
                chartVC.rawData = tableData[ip.row].dataToGoal
            }
        }
    }

    func countButtonPressed(cell: iCell) {
        
        // Set variables and constants
        let indexPath = tableView.indexPath(for: cell)
        tableData[(indexPath?.row)!].count += 1
        var countInt = Int32((cell.countLabel.titleLabel?.text)!)
        let goal = tableData[(indexPath?.row)!]

        
        // If period has expired
        if goal.endDate! < Date() {

            let newCountData = CountData(context: context)
            newCountData.count = countInt!
            newCountData.date = goal.startDate

            // Add data to chart data
            goal.addToDataToGoal(newCountData)
            print("data in button press: ", goal.dataToGoal)

            // Reset count
            countInt = 0
            if testing == true {
                goal.startDate = Date()
                goal.endDate = Calendar.current.date(byAdding: .minute, value: Int(goal.period), to: goal.startDate!)
            }
            else {
                goal.endDate = Calendar.current.date(byAdding: .day, value: Int(goal.period), to: goal.startDate!)
            }
            
            if goal.limit == true {
                cell.countButton.backgroundColor = UIColor.init(red: 0.20, green: 0.60, blue: 0.42, alpha: 1.0) // green
            }
            else {
                cell.countButton.backgroundColor = UIColor.init(red: 0.89, green: 0.47, blue: 0.47, alpha: 1.0) // red
            }
        }
        else {
            countInt = countInt! + 1
            if countInt! > goal.times && goal.limit == true {
                cell.countButton.backgroundColor = UIColor.init(red: 0.89, green: 0.47, blue: 0.47, alpha: 1.0) // red
            }
            else if countInt! >= goal.times && goal.limit == false {
                cell.countButton.backgroundColor = UIColor.init(red: 0.20, green: 0.60, blue: 0.42, alpha: 1.0) // green
            }
        }
        goal.count = countInt!
        cell.countLabel.setTitle(countInt?.description, for: .normal)

        saveContext()
    }

    func saveButtonPressed(num count: Int32?, text goal: String?, goalNum times: Int32?, period timeFrame: Int32?, upperBound upLimit: Bool?, sender indexPath: IndexPath?) {
        if let ip = indexPath {
            tableData[ip.row].count = count!
            tableData[ip.row].goalTitle = goal
            tableData[ip.row].period = timeFrame!
            tableData[ip.row].times = times!
            tableData[ip.row].limit = upLimit!
        }

        else {

            let newGoal = Goal(context: context)

            newGoal.count = count!
            newGoal.goalTitle = goal
            newGoal.period = timeFrame!
            newGoal.times = times!
            newGoal.limit = upLimit!
            newGoal.startDate = Date()
            newGoal.dataToGoal = NSSet()
//            newGoal.periodCounts = [Int]()

            if testing == true {
                newGoal.endDate = Calendar.current.date(byAdding: .minute, value: Int(newGoal.period), to: newGoal.startDate!)
            }

            else {
                newGoal.endDate = Calendar.current.date(byAdding: .day, value: Int(newGoal.period), to: newGoal.startDate!)
            }

            tableData.append(newGoal)
        }
        tableView.reloadData()
        saveContext()

        dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ChartSegue", sender: indexPath)
        
        // Encouragement Alert
        
        let goal = tableData[indexPath.row]
        
        if goal.limit == true && Int(goal.count) < Int(goal.times) {
            
            let optionMenu = UIAlertController(title: nil, message: "You still can make your goal! Keep resisting that urge. You can do it!", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
            
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
        
        else if goal.limit == false && Int(goal.count) < Int(goal.times)  {
            
            let optionMenu = UIAlertController(title: nil, message: "Your doing great so far. Go do it now if you can!", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
            
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
}

extension MyICountVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iCell", for: indexPath) as! iCell

        let timeFrame: String
        if tableData[indexPath.row].period == 1 {
            timeFrame = "day"
        }
        else if tableData[indexPath.row].period == 7 {
            timeFrame = "week"
        }
        else {
            timeFrame = "month"
        }

        let limit: String
        
        if tableData[indexPath.row].limit == true {
            limit = "at most"
            
            if tableData[indexPath.row].count < tableData[indexPath.row].times {
                cell.countButton.backgroundColor = UIColor.init(red: 0.20, green: 0.60, blue: 0.42, alpha: 1.0) // green
            }
            else {
                cell.countButton.backgroundColor = UIColor.init(red: 0.89, green: 0.47, blue: 0.47, alpha: 1.0) // red
            }
        }

        else {
            limit = "at least"
            
            if tableData[indexPath.row].count < tableData[indexPath.row].times {
            cell.countButton.backgroundColor = UIColor.init(red: 0.89, green: 0.47, blue: 0.47, alpha: 1.0) // red
            }
            else {
                cell.countButton.backgroundColor = UIColor.init(red: 0.20, green: 0.60, blue: 0.42, alpha: 1.0) // green
            }
        }


        cell.titleLabel.text = tableData[indexPath.row].goalTitle
        cell.countLabel.setTitle(String(tableData[indexPath.row].count), for: .normal)
        cell.timesPerPeriodLabel.text = "" + String(tableData[indexPath.row].times) + " times/" + timeFrame + ""
        cell.limitLabel.text = limit
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, nil) in
            self.performSegue(withIdentifier: "mainSegue", sender: indexPath)
        }

        edit.backgroundColor = UIColor.blue


        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            print("Delete")


            // Remove from core data/ context
            let goal = self.tableData[indexPath.row]
            self.context.delete(goal)

            // Remove from table data
            self.tableData.remove(at: indexPath.row)

            self.saveContext()

            tableView.reloadData()
        }

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}


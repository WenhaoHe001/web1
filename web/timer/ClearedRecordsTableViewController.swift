//
//  ClearedRecordsTableViewController.swift
//  timer
//
//  Created by kevinhe on 2019/11/24.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit
import os.log


class ClearedRecordsTableViewController: UITableViewController {
    
    //MARK: -properties
    var deletedTimeModels: TimeModels!
    

//    if let jsondata = try? Data(contentsOf: url) {
//        if let _timeModel = TimeModel(json: jsondata) {
//            temperModel = _timeModel
//        }
//    }
    
    
    
    
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    //MARK: - methods
    @IBAction func cleanDeleteRecords(_ sender: UIBarButtonItem) {
        if sender == clearButton {
             clearAllDeleteRecords()
            
        }
    }
    
    private func clearAllDeleteRecords() {
         deletedTimeModels.timeModels.removeAll()
         deletedTimeModels.fileURL = nil
        saveDelegateModel()
        tableView.reloadData()
    }
    
    
    @IBAction func recoverDeleteRecords(_ sender: UIBarButtonItem) {
        print("recover all records")
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("timeRecord") {
            if let jsonData = try? Data(contentsOf: url) {
                var timeModel = TimeModel(json: jsonData)
                for model in deletedTimeModels.timeModels {
                    for record in model.records {
                        timeModel?.records.append(record)
                    }
                    for story in model.story {
                        timeModel?.story.append(story)
                    }
                }
                
               try? timeModel?.json?.write(to: url)
            }
        }
        clearAllDeleteRecords()
    }
    
    
    private func saveDelegateModel() {
        do {
            let url = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("clearedTimeModel")
            try deletedTimeModels.json?.write(to: url)
                os_log("clearedTimeModels is saved", log: OSLog.default, type: OSLogType.default)
            } catch {
                os_log("clearedTimeModels is not saved", log: OSLog.default, type: .error)
            }
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("clean viewWillDisappear")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return deletedTimeModels.timeModels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return deletedTimeModels.timeModels[section].records.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DTimeTableViewCell", for: indexPath) as? DeleteTableViewCell  else { fatalError(" deleted no DeleteTableViewCell ")}

        // Configure the cell...
        
        cell.label.text = deletedTimeModels.timeModels[indexPath.section].records[indexPath.row]
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section)"
    }
    

    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.

        
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (contextualAction, view, boolValue) in
            print("Trailing Action style .destructive")
                self.deletedTimeModels.timeModels[indexPath.section].records.remove(at: indexPath.row)
                self.deletedTimeModels.timeModels[indexPath.section].story.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                if self.deletedTimeModels.timeModels[indexPath.section].records.isEmpty {
                    self.deletedTimeModels.timeModels.remove(at: indexPath.section)
                    tableView.deleteSections([indexPath.section], with: UITableView.RowAnimation.fade)
                }
                
                self.saveDelegateModel()
        }
        
            let recoverAction = UIContextualAction(style: .normal, title: "Recover") { (contextualAction, view, boolValue) in
                print("recoverAction")
                if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("timeRecord") {
                    if let jsonData = try? Data(contentsOf: url) {
                        var timeModel = TimeModel(json: jsonData)
                        let recoveredRecord = self.deletedTimeModels.timeModels[indexPath.section].records.remove(at: indexPath.row)
                        let recoverdStory = self.deletedTimeModels.timeModels[indexPath.section].story.remove(at: indexPath.row)
                        timeModel?.records.append(recoveredRecord)
                        timeModel?.story.append(recoverdStory)
                        
                       try? timeModel?.json?.write(to: url)
                    }
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                if self.deletedTimeModels.timeModels[indexPath.section].records.isEmpty {
                    self.deletedTimeModels.timeModels.remove(at: indexPath.section)
                    tableView.deleteSections([indexPath.section], with: UITableView.RowAnimation.fade)
                }
                self.saveDelegateModel()
        }
        
        var actions = [UIContextualAction]()
        actions.append(deleteAction)
        actions.append(recoverAction)
        let swipeActions = UISwipeActionsConfiguration(actions: actions)
        return swipeActions
    }
    
    //MARK:- methods for tableView
    
    


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("editingStyle == .delete")
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    
    /*      let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
          self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
          return
      }
      deleteButton.backgroundColor = UIColor.black
      return [deleteButton]*/
    
//UITableViewRowAction' was deprecated in iOS 13.0: Use UIContextualAction and related APIs instead.
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showDeleteStory" {
            if let svc = segue.destination.contents as? StoryViewController {
                guard let cell = sender as? DeleteTableViewCell  else {fatalError("no cell")}
                guard let selectIndexpath = tableView.indexPath(for: cell) else {fatalError("no indexpath")}
                
                svc.date = deletedTimeModels.timeModels[selectIndexpath.section].records[selectIndexpath.row]
                svc.storyContent = deletedTimeModels.timeModels[selectIndexpath.section].story[selectIndexpath.row].story ?? "no story"
                svc.dataInfo = deletedTimeModels.timeModels[selectIndexpath.section].story[selectIndexpath.row].dataInfo ?? [Story.DataInfo(x: nil, y: nil, data: nil, width: nil, height: nil)]
                svc.issegueFromClearVC = true
                svc.deleteIndexPath = selectIndexpath
                print("\(String(describing: svc.deleteIndexPath))")
            }
        }
        
        
        
        }
        
        
            
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    

}

//
//  PagesTableViewController.swift
//  web
//
//  Created by kevinhe on 2019/11/25.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit

class PagesTableViewController: UITableViewController {
    

    var urlsModelTitle = [String]()
    var urlsModelurl = [String]()
    
    //MARK: - properties
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var rhBarBtn: UIBarButtonItem!
    
    //MARK: - methods
    @IBAction func backToWeb(_ sender: UIBarButtonItem) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return urlsModelurl.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
//        cell.textLabel?.text = urlsModel[indexPath.row]
        cell.textLabel?.text = urlsModelTitle[indexPath.row]
        cell.detailTextLabel?.text = urlsModelurl[indexPath.row]
        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            urlsModelTitle.remove(at: indexPath.row)
            urlsModelurl.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let url = try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("bookMarks") {
                if let jsonData = try? Data(contentsOf: url) {
                    var bookMarks = BookMarks(json: jsonData)
                    bookMarks?.titles = urlsModelTitle
                    bookMarks?.urls = urlsModelurl
                    try? bookMarks?.json?.write(to: url)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    var defaults = UserDefaults.standard
    
    var notes = [String]()
    
    private var key = "note"

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotes" {
            if let nvc = segue.destination as? NotesTableViewController {
                notes = ["1", "2"]
                if let notes = defaults.array(forKey: key) as? [String] {
                    nvc.notes = notes
                }
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        
    }
    

}

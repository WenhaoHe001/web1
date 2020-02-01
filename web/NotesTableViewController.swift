//
//  NotesViewController.swift
//  web
//
//  Created by kevinhe on 2020/1/17.
//  Copyright © 2020 kevinhe. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {

    
    var defaults = UserDefaults.standard
    
    var notes = [String]()
    
    private var key = "note"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        tableView.rowHeight = tableView.visibleCells.first?.bounds.size.height ?? 33
        
//        if let notes = defaults.array(forKey: key) as? [String] {
//            print(notes)
//            self.notes = notes
//        }
//
        tableView.reloadData()
        
    }
    
    @IBAction func cleanNotes(_ sender: UIBarButtonItem) {
        defaults.removeObject(forKey: key)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notes") as? NoteTableViewcell else {fatalError("no cell")}
        cell.textField.placeholder = "enter note"
        cell.textField.text = notes[indexPath.row]
        cell.closre = { [weak self] in
            if let text = cell.textField.text {
                self?.notes.append(text)
                self?.setDefaults()
            }
        }
        
        return cell
    }
    
    func setDefaults(){

        defaults.set(notes, forKey: key)
        tableView.reloadData()
        print(notes)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



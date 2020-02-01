//
//  TimerViewController.swift
//  timer
//
//  Created by kevinhe on 2019/11/8.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit
import os.log

class TimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate {
    
    
    //MARK: - outlet properties
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var middleView: ToTapView!
    
    @IBOutlet weak var clearRecords: UIBarButtonItem!
    
    
    
    @IBOutlet weak var timeTableView: UITableView! {
        didSet{
            timeTableView.delegate = self
            timeTableView.dataSource = self
            timeTableView.rowHeight = 77
            timeTableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))
        }
    }
    
    

    //MARK:- TotapVIew outlet and IBfunc
    
    @IBOutlet weak var toTaoView: ToTapView!
    
    
    
    /*
     self.squareTableView.estimatedRowHeight = 200;

     self.squareTableView.rowHeight = UITableViewAutomaticDimension;
     */
    
    
    
    //MARK: - properties
    
    let oneSecond: TimeInterval = 1
    var week: Int?
    
    var timer: Timer? = nil
    var showSecond: Bool = true
    //var eyeIsMoving = false {didSet{ eyesMoving() }}
    var timeStart = false {didSet{ setUpTime() } }
    var templeRecord: String?
    // table datasource
    
    var timeModel: TimeModel!
    
    var clearedTimeModels = TimeModels()
    
    var recordCounts: String {
        return "\(timeModel.numbersOfrecords)"
    }
    
    private var lineIsMoving: Bool = false {didSet {lineMoving() }}
    
//    var timeRecords = [String]()
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let newValue = loadData() {
            timeModel = newValue
        } else {
            timeModel = TimeModel()
        }
        
        if let newValue = loadDelegateModel() {
            clearedTimeModels = newValue
        }
        
    }
    
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear!!!")
//
//        saveData()
//        saveDeleteModel()
        
        
        

        timeStart = true
        
        
        lineIsMoving = true
        
//        toTaoView.lineView.transform = toTaoView.lineView.transform.rotated(by: (toTaoView.bounds.width/2)/(toTaoView.bounds.height/2))
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(view.contentScaleFactor)
        
        reloadData()
        print("timer viewDidAppear")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("timer viewDidDisappear")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("traitCollectionDidChange")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        print("willTransition")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timeStart = false
        timer?.invalidate()
        print("timeStoped")
        lineIsMoving = false
    }
    
    //MARK: - funcs
    
    private func reloadData(){
    if let newValue = loadData() {
        timeModel = newValue
        timeTableView.reloadData()
    } else {
        timeModel = TimeModel()
    }
    if let newValue = loadDelegateModel() {
        clearedTimeModels = newValue
    }
        
        
    }
    
    
    @IBAction func clearAllRecords(_ sender: Any? = nil) {
            //store cleard recored
        
        let alert = UIAlertController(title: "Remove all records", message: "You can find records in recover", preferredStyle: UIAlertController.Style.alert)
            
        let action = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil)
        
        let clearAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) { (action) in
            self.removeAllRecords()
        }
        alert.addAction(action)
        alert.addAction(clearAction)
        
        present(alert, animated: true, completion: nil)
        /*let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("timeRecord")
        timeModel.fileURL = url
        try timeModel.json?.write(to: url)*/
        
    }
    
    private func removeAllRecords(){
    clearedTimeModels.timeModels.append(timeModel)
    saveDeleteModel()
    
    
    //clear timeModel
    timeModel.records.removeAll()
    timeModel.story.removeAll()
    timeModel.fileURL = nil
    timeTableView.reloadData()
    saveData()
    }
    
    private func saveDeleteModel() {
        do {
            let url = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("clearedTimeModel")
            try clearedTimeModels.json?.write(to: url)
                os_log("clearedTimeModels is saved", log: OSLog.default, type: OSLogType.default)
            } catch {
                os_log("clearedTimeModels is not saved", log: OSLog.default, type: .error)
            }
    }
    
    private func loadDelegateModel() -> TimeModels?{
        var temp: TimeModels?
        if let url = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("clearedTimeModel") {
            if let jsondata = try? Data(contentsOf: url) {
                if let _temp = TimeModels(json: jsondata) {
                    temp = _temp
                }
            }
        }
        return temp
    }
    
    
    //linemoving
    
    private var inAMoving = false
    
    private func lineMoving(){
        if lineIsMoving && !inAMoving {
            // change propertie superclass's properites
            inAMoving = true
            toTaoView.lineViewlineWidth = 3.0
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer  in
                // change propertie superclass's properites
                self?.toTaoView.lineViewlineWidth = 15.0
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer in
                    self?.inAMoving = false
                    self?.lineMoving()
                    
                }
            }
        }
        
    }

    

    
    func getWeek(_ date: Date) -> Int {
        let calendar = Calendar.current
//        let calendar = Calendar(identifier: Calendar.Identifier.chinese)
        var localweekday: Int = 0
        if let weekday = calendar.dateComponents([.weekday], from: date).weekday {
            localweekday = (weekday+5)%7
            
        }
        
        return localweekday
    }
    
    func setUpTime() {
        if timeStart {
//            print("timeStarted")
            timer = Timer.scheduledTimer(withTimeInterval: oneSecond, repeats: true) { [weak self] timer in
                let time = Date(timeIntervalSinceNow: 28800)
//                print("\(time)")
                let time2 = Date(timeIntervalSinceNow: 86200+200) //57600
//                print("\(time2)")
//                let day = self?.getWeek(time)
                let weekday = self?.getWeek(time2)
//                print("星期\(weekday!)")
                let string1 = "\(time)"
                let startIndex = string1.startIndex
                if let firstSpace = string1.firstIndex(of: " ") {
                    let secondWordIndex = string1.index(firstSpace, offsetBy: self!.showSecond ? 9 : 6)
                    let words = String(string1[startIndex ..< secondWordIndex])
                    let plusweekday = words + " " + (weekday?.weekNo ?? "?")
                    self?.timeLabel.text = plusweekday
                    self?.isAbleRecord = true
                    self?.templeRecord = plusweekday
                    
                }
            }
        }
    }
    
    
    
    //MARK: -saveData
    func saveData(){
        print("save  timeModel")
        
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("timeRecord")
            timeModel.fileURL = url
            try timeModel.json?.write(to: url)
            os_log("timerRecord is saved", log: OSLog.default, type: OSLogType.default)
            
        } catch {
            os_log("timerRecord is not saved", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: -loadData
    func loadData() -> TimeModel? {
        var temperModel: TimeModel?
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("timeRecord") {
            //        if let jsonData = try?
            if let jsondata = try? Data(contentsOf: url) {
                if let _timeModel = TimeModel(json: jsondata) {
                    temperModel = _timeModel
                }
            }
        }
        return temperModel
    }
    
    //MARK: -IBFuncs
    
    
    private var isAbleRecord: Bool = true
    
    @IBAction func tapToRecord(_ sender: UITapGestureRecognizer) {
        if isAbleRecord {
            switch sender.state {
            case .ended:
                
                print("tapToRecord")
                //        timeRecords.append(templeRecord ?? "?")
                timeModel.records.append(templeRecord ?? "?")
                timeModel.story.append(Story())
                timeTableView.reloadData()
                templeRecord = nil
                saveData()
                
            default: break
            }
            isAbleRecord = false
        }
    }
    
    // show alert viev
    @IBAction func showCounts(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "connts", message: recordCounts, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        

    }
    
    
    //MARK: -table datasource
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeModel.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as? TimeTableViewCell else {fatalError("no cell")}
        cell.timeLabel.text = timeModel.records[indexPath.row]
        
        return cell
    }

    //MARK: -table delegate
    
//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//        tableView.setEditing(true, animated: true)
//    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        print("canMoveRowAt")
//
//        return true
//    }
    
    
    //leadingSwipeActionsConfigurationForRowAt
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//    }
    
    
    private func addTextAlert(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Rename", message: "Unable to back", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Entry new story title"
            
        }
        let action2 = UIAlertAction(title: "ok", style: UIAlertAction.Style.destructive) { (action) in
            if let tf = alert.textFields?.first, let text = tf.text {
                self.changeName(str: text, indexPath: indexPath)
            }
         }
         
        alert.addAction(action)
        alert.addAction(action2)

        present(alert, animated: true, completion: nil)
    }
    
    private func changeName(str: String, indexPath: IndexPath) {
        self.timeModel.records[indexPath.row] = str
        timeTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        self.saveData()
    }
    
    
    private func deleteRow(_ indexPath: IndexPath) {
        // Delete the row from the data source
        if clearedTimeModels.timeModels.isEmpty {
            clearedTimeModels.timeModels.append(timeModel)
            clearedTimeModels.timeModels[indexPath.section].records.removeAll()
            clearedTimeModels.timeModels[indexPath.section].story.removeAll()
        }
        clearedTimeModels.timeModels[indexPath.section].records.append(timeModel.records[indexPath.row])
        clearedTimeModels.timeModels[indexPath.section].story.append(timeModel.story[indexPath.row])
        
        timeModel.records.remove(at: indexPath.row) // update model
        timeModel.story.remove(at: indexPath.row)
        saveData()
        saveDeleteModel()
        
        //            saveMeals()
        timeTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let renameAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Rename") { (action, view, boolValue) in
            self.addTextAlert(indexPath)
        }

        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "delete") { (action, view, boolValue) in
            self.deleteRow(indexPath)
        }
        
 

        var actions = [UIContextualAction]()
       actions.append(deleteAction)
        actions.append(renameAction)
        let swipeActions = UISwipeActionsConfiguration(actions: actions)
        return swipeActions
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = timeModel.records.remove(at: sourceIndexPath.row)
        let temp2 = timeModel.story.remove(at: sourceIndexPath.row)
        timeModel.records.insert(temp, at: destinationIndexPath.row)
        timeModel.story.insert(temp2, at: destinationIndexPath.row)
//        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)

        print("moveRowAt")
        tableView.setEditing(false, animated: true)
        saveData()
        saveDeleteModel()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        
        for cell in tableView.visibleCells {
            cell.backgroundColor = .clear
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? TimeTableViewCell {
            cell.backgroundColor = .cyan
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("didDeselectRowAt")

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _tableView = scrollView as? UITableView {
            _tableView.setEditing(false, animated: true)
            for cell in _tableView.visibleCells {
                cell.backgroundColor = .clear
            }
        }
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .ended:
            print(longPress)
            timeTableView.setEditing(true, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("didEndEditingRowAt")
        tableView.setEditing(false, animated: true)
        
    }
    

    
    
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowStory" {
        guard let destinationVC = segue.destination.contents as? StoryViewController else { fatalError("not StoryVC")}
        
        guard let cell = sender as? TimeTableViewCell else {
            fatalError("not TimeTableViewCell")
        }
        
        guard let selectIndexpath = timeTableView.indexPath(for: cell) else {fatalError("no indexpath")}
        
        destinationVC.date = timeModel.records[selectIndexpath.row]
        destinationVC.storyContent = timeModel.story[selectIndexpath.row].story ?? "new story"
            destinationVC.dataInfo = timeModel.story[selectIndexpath.row].dataInfo ?? [Story.DataInfo(x: nil, y: nil, data: nil, width: nil, height: nil)]
//        destinationVC.datas = timeModel.story[selectIndexpath.row].datas ?? [Data]()
        }
        if segue.identifier == "ShowInfo" {
            guard let destinationVC = segue.destination.contents as? InfoViewController else { fatalError("not Info")}
            destinationVC.timerRecord = timeModel
            if let ppc = destinationVC.popoverPresentationController {
                ppc.delegate = self
            }
        }
        
        if segue.identifier == "ShowClearedRecord" {
            
            guard let destinationVC = segue.destination.contents as? ClearedRecordsTableViewController else { fatalError("not ClearedRecordsTableViewController")}
                destinationVC.deletedTimeModels = clearedTimeModels
            destinationVC.title = "ClearedRecords"
            
        }
    }
    
    //MARK: - UIPOPpverPresentationControllerdelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    

    
    
    //MARK: -unwind segue
    
    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {
        guard let sourceVC = segue.source as? StoryViewController else {  fatalError("not StoryVC")}
        
        guard let content1 = sourceVC.storyContent else {  fatalError("not right storyContent")}
//        let imageDatas = sourceVC.datas
        let datainfos = sourceVC.dataInfo
        if let selectIndexpath = timeTableView.indexPathForSelectedRow {
            var story = Story()
            story.story = content1
            story.dataInfo = datainfos
//            story.datas = imageDatas
            print("\(selectIndexpath.row)")
            timeModel.story[selectIndexpath.row] = story
            
            
        }
        saveData()
    }
    
    @IBAction func unwindFromDeleteVC(segue: UIStoryboardSegue) {
        guard let sourceVC = segue.source as? ClearedRecordsTableViewController else {
            fatalError(" not ClearedVC")
        }
        guard let content = sourceVC.deletedTimeModels else {fatalError("not deletedTimeModels")}
        clearedTimeModels = content
        
        reloadData()
        timeTableView.reloadData()
        
    }
    
}

/*
// MARK: - Actions

@IBAction func unwindToMealList(segue: UIStoryboardSegue){
    
    
    if let mealVC = segue.source as? MealViewController, let newMeal = mealVC.meal {
        
        //edit a meal
        
        if let selectIndexPath = tableView.indexPathForSelectedRow {
            meals[selectIndexPath.row] = newMeal
            tableView.reloadRows(at: [selectIndexPath], with: UITableView.RowAnimation.none)
            
        } else {
            // Add a new meal
            
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            
            meals.append(newMeal)
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    saveMeals()
    
}
*/
extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

extension Int {
    var weekNo: String {
        switch self {
        case 1: return "Mon"
        case 2: return "Tues"
        case 3: return "Wednes"
        case 4: return "Thur"
        case 5: return "Fri"
        case 6: return "Sat"
        case 0: return "Sun"
        default: return "week 8"
        }
    }
}


/*
     //MARK: - Properties
     
     
     var eyeIsMoving = false {didSet{ eyesMoving() }}
     
     //MARK: - TimerInterval while eyesMove
     
     private struct EyesTimeInterval {
         static let CloseEyesTimeInterval: TimeInterval = 0.4
         static let OpenEyesTimeInterval: TimeInterval = 2.5
     }
     
     
     //MARK:- super method
     
 //    override func updateUI() {
 //        super.updateUI()
 ////        eyeIsMoving = expression.eyes == .squinting
 //    }
 //
     
     //MARK: - private methods
     
     private func eyesMoving() {
         if eyeIsMoving {
             // change propertie superclass's properites
             faceView.eyeIsOpen = false
             Timer.scheduledTimer(withTimeInterval: EyesTimeInterval.CloseEyesTimeInterval, repeats: false) { [weak self] timer  in
                 // change propertie superclass's properites
                 self?.faceView.eyeIsOpen = true
                 Timer.scheduledTimer(withTimeInterval: EyesTimeInterval.OpenEyesTimeInterval, repeats: false) { [weak self] timer in
                     self?.eyesMoving()
                 }
             }
         }
     }
     
     //MARK: -lifeCycle methods
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         eyeIsMoving = true // start eyeMove
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillAppear(animated)
         eyeIsMoving = false // stop time while view will disappear
     }*/



/*
 */
            //UIView animation
                
        
//                UIView.animate(
//                    withDuration: 0.5,
//                    animations: {self.toTaoView.linepath.lineWidth = 3}
//                    completion: { finished in
//                        UIView.animate(
//                            withDuration: 0.5,
//                            animations: {self.toTaoView.linepath.lineWidth = 15},
//                            completion: nil)
//                }
//                )
                
//                toTaoView.resizableSnapshotView(from: <#T##CGRect#>, afterScreenUpdates: <#T##Bool#>, withCapInsets: <#T##UIEdgeInsets#>)
                
                
                

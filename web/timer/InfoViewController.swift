//
//  InfoViewController.swift
//  timer
//
//  Created by kevinhe on 2019/11/18.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    @IBOutlet weak var returnToRecordsBtn: UIButton!
    
    @IBAction func done() {
        presentingViewController?.dismiss(animated: true, completion: {
            print("dismissed pop view")
        })
        
    }
    var timerRecord: TimeModel? {didSet {updateUI()}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    private let shoryDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
        
    }()
    
    func updateUI(){
        if sizeLabel != nil, createdLabel != nil,
            let attrubutes = try? FileManager.default.attributesOfItem(atPath: (timerRecord?.fileURL!.path)!)
            {
                print("\(timerRecord?.fileURL!.path ?? "?")")
                sizeLabel.text = "\(attrubutes[.size] ?? 0) bytes"
                if let created = attrubutes[.creationDate] as? Date {
                    createdLabel.text = shoryDateFormatter.string(from: created)
                }
        }
        if presentationController is UIPopoverPresentationController {
            returnToRecordsBtn?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize =  topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize){
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
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

//
//  TextViewViewController.swift
//  web
//
//  Created by kevinhe on 2020/2/1.
//  Copyright © 2020 kevinhe. All rights reserved.
//

import UIKit

class TextViewViewController: UIViewController, UITextViewDelegate {
    
    var defaults = UserDefaults.standard
    
    var key = "text"
    
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDoneButton()
        
        myTextView.delegate = self
        
        
        if let text = defaults.object(forKey: key) as? String {
            myTextView.text = text
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateDoneButton()
    }
    
    @IBAction func hideKeyboard(_ sender: UIBarButtonItem) {
        myTextView.resignFirstResponder()
        updateDoneButton()
        if let text = myTextView.text {
            defaults.set(text, forKey: key)
        }
    }
    
    private func updateDoneButton() {
        
        if myTextView.isFirstResponder {
            doneButton.tintColor = .blue
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
            doneButton.tintColor = .cyan
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

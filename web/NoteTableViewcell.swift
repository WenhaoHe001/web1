//
//  NoteTableViewcell.swift
//  web
//
//  Created by kevinhe on 2020/1/17.
//  Copyright © 2020 kevinhe. All rights reserved.
//

import UIKit

class NoteTableViewcell: UITableViewCell, UITextFieldDelegate {
    
    
    var closre: (()->Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closre!()
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            
            
            textField.delegate = self
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

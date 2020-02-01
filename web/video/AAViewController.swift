//
//  AAViewController.swift
//  web
//
//  Created by kevinhe on 2019/12/1.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit

class AAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Thread.isMainThread {
            print("on")
        } else {
            print("off")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("not video viewWillAppear")
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

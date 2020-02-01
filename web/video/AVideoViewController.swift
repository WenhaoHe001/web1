//
//  AVideoViewController.swift
//  web
//
//  Created by kevinhe on 2019/12/1.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AVideoViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") else {return}
        let playerr = AVPlayer(url: url)
        print("play")
        self.player = playerr
        if Thread.isMainThread {
            print("on main thread")
        } else {
            print("off main thread")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("video viewWillAppear")
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

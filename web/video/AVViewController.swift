//
//  AVViewController.swift
//  web
//
//  Created by kevinhe on 2019/11/29.
//  Copyright © 2019 kevinhe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AVViewController: UIViewController {

    
    @IBAction func playVideo(_ sender: UIButton) {
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") else {
            return
        }
        
//        guard let url2 = URL(string: "https://v1-tt.ixigua.com/e508fdb8356da612372c246afcb3d7aa/5de11ce4/video/m/2208bedbcc6cfbe4bf59a9870832abbaf9a116266ae000006307b570f893/?a=1768&br=1430&cr=0&cs=0&dr=0&ds=3&er=&l=20191129202647010014052020064677B4&lr=&qs=0&rc=ajd5NHM1Z3RpbTMzZTczM0ApOjs5Zzc2Z2UzNzU6ZWRkZGdzMWdtYTVfbHBfLS0wLS9zc14uNDA1XzA1YjY2LTI2Li86Yw%3D%3D") else {
//            return
//        }
        
/*https://v1-tt.ixigua.com/e508fdb8356da612372c246afcb3d7aa/5de11ce4/video/m/2208bedbcc6cfbe4bf59a9870832abbaf9a116266ae000006307b570f893/?a=1768&br=1430&cr=0&cs=0&dr=0&ds=3&er=&l=20191129202647010014052020064677B4&lr=&qs=0&rc=ajd5NHM1Z3RpbTMzZTczM0ApOjs5Zzc2Z2UzNzU6ZWRkZGdzMWdtYTVfbHBfLS0wLS9zc14uNDA1XzA1YjY2LTI2Li86Yw%3D%3D*/
//        guard let url2 = Bundle.main.url(forResource: "H6k", withExtension: "ts", subdirectory: nil) else {return }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
//        let item = AVPlayerItem(url: <#T##URL#>)
//        let player2 = AVPlayer(playerItem: <#T##AVPlayerItem?#>)

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.view.backgroundColor = .clear
        controller.player = player

        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

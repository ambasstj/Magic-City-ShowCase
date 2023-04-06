//
//  TestVideoController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/24/23.
//

import Foundation
import AVFoundation
import UIKit

class TestVideoController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
        
    @IBOutlet weak var videoView: UIView!
    
    
    @IBOutlet weak var logoView: UIImageView!
    
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let path = Bundle.main.path(forResource: "My Movie BQ", ofType:"mp4") else {
            
            debugPrint("My Movie BQ.mp4 not found  \(FileManager.default.currentDirectoryPath)")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resize

        videoView.layer.addSublayer(avPlayerLayer)
        videoView.addSubview(loginButtonOutlet)
        videoView.addSubview(registerButtonOutlet)
        videoView.addSubview(logoView)
        //videoView.addSubview(yearLabel)
        player.play()
       
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let avPlayerLayer = avPlayerLayer {
           avPlayerLayer.frame = videoView.layer.bounds
        }
        
    }
    
    
    
    
    
}

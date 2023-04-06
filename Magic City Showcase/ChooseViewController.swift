//
//  ChooseViewController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/25/23.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class ChooseViewController: UIViewController{
    
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var eventButton: UIButton!
    
    
    @IBOutlet weak var playerProfileButton: UIButton!
    
    
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let path = Bundle.main.path(forResource: "Football Match Instagram Story", ofType:"mp4") else {
            
            debugPrint("Football Match Instagram Story.mp4 not found  \(FileManager.default.currentDirectoryPath)")
            return
        }
        
        let eventsButton = UIButton()
        
        eventsButton.setTitle("Manage an event", for: .normal)
        eventsButton.backgroundColor = UIColor.gray
      
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resize

        videoView.layer.addSublayer(avPlayerLayer)
        videoView.addSubview(eventButton)
        videoView.addSubview(playerProfileButton)
       
        player.play()
        
        let times = [NSValue(time: CMTime.zero), NSValue(time: player.currentItem!.duration)]
        player.addBoundaryTimeObserver(forTimes: times, queue: nil) {
            [weak self] in
            self?.player.seek(to: .zero)
            self?.player.play()
            
            
            
            
        }
        
      
           
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        player.pause()
        player.seek(to: .zero)
        player.rate = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player.play()
    }
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let avPlayerLayer = avPlayerLayer {
           avPlayerLayer.frame = videoView.layer.bounds
        }
        
        loopVideo(videoPlayer: self.player)        }
        
    }


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
    
    
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
        
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var skipSignIn: UIButton!
    
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
        videoView.addSubview(skipSignIn)
        player.play()
       
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let avPlayerLayer = avPlayerLayer {
           avPlayerLayer.frame = videoView.layer.bounds
        }
        
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "skipSignIn", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "skipSignIn" {
            if let destinationVC = segue.destination as? PlayerProfileController {
                destinationVC.loadViewIfNeeded() // to make sure the view is loaded
                destinationVC.addAthleteButton.isHidden = true
                destinationVC.shouldHideButtons = true
            }
        } else {
            print("Why lord, why lord do I gotta suffer?")
        }
        
        
    }
}
    
    
    
    


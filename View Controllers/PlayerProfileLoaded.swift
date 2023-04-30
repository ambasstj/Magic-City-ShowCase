//
//  PlayerProfileLoaded.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/30/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseCore

class PlayerProfileLoaded: UIViewController{
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var handSpanLabel: UILabel!
    
    @IBOutlet weak var wingSpanLabel: UILabel!
    
    
    
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var broadJumpLabel: UILabel!
    
    
    @IBOutlet weak var shuttleRunLabel: UILabel!
    
    @IBOutlet weak var benchPressLabel: UILabel!
    
    @IBOutlet weak var verticalLabel: UILabel!
    
    @IBOutlet weak var fortyLabel: UILabel!
    
    
    var indexPath: Int?
    var playerArray: [PlayerListing]?
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    //resets screen orientations to all
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        nameLabel.text = playerArray?[indexPath ?? 0].name
        heightLabel.text = playerArray?[indexPath ?? 0].height
        weightLabel.text = playerArray?[indexPath ?? 0].weight
        handSpanLabel.text = playerArray?[indexPath ?? 0].handSpan
        wingSpanLabel.text = playerArray?[indexPath ?? 0].wingSpan
        schoolLabel.text = playerArray?[indexPath ?? 0].school
        broadJumpLabel.text = playerArray?[indexPath ?? 0].broadJump
        shuttleRunLabel.text = playerArray?[indexPath ?? 0].shuttleRun
        benchPressLabel.text = playerArray?[indexPath ?? 0].benchPress
        verticalLabel.text = playerArray?[indexPath ?? 0].Vertical
        fortyLabel.text = playerArray?[indexPath ?? 0].forty
        positionLabel.text = playerArray?[indexPath ?? 0].position
    
            
            }
    
}


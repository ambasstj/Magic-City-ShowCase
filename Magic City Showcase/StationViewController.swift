//
//  StationViewController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/27/23.
//

import Foundation
import UIKit

class StationViewController: UIViewController {
    

    //locks every screen orientation to portrait
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewDidLoad() {
        navigationItem.titleView?.backgroundColor = UIColor.white
        navigationItem.title = "Choose Your Station"
    }
    //resets screen orientations to all
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: K.stationSegue, sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.stationSegue {
            let destinationVC = segue.destination as! PlayerViewController
            if let senderButton = sender as? UIButton {
                destinationVC.navigationItem.title = senderButton.titleLabel?.text
                print(senderButton.titleLabel?.text ?? "no titleLabel.text found")
                   }
        }
    
        }
}

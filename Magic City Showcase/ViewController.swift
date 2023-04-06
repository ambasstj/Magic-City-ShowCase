//
//  ViewController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/24/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    let db = Firestore.firestore().collection("PlayerListing")

}


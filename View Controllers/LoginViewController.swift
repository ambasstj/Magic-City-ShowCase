//
//  LoginViewController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/25/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    
    
    var emailph: String?
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    
    override func viewDidLoad() {
        
        
        emailTextfield.layer.cornerRadius = 8
        
        
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "Email Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            
            passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    let errorAtSignIn = UIAlertController(title: "Error", message: "Please enter a valid username and password", preferredStyle: .alert)
    
  
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
                
                Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                    
                    if let e = error {
                        
                        print(e.localizedDescription)
                        self.present(self.errorAtSignIn, animated: true)
                        self.errorAtSignIn.addAction(self.okAction)
                    }
                    else {
                        
                        self.emailph = email
                        self.performSegue(withIdentifier: K.loginSegue, sender: self)
                    }
                    
                }}
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.loginSegue {
            
            let destinationVC = segue.destination as? ChooseViewController
            destinationVC?.navigationItem.title = emailph
            
        }
        
    }
    
    }

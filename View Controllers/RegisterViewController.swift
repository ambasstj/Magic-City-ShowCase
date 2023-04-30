//
//  RegisterViewController.swift
//  Magic City Showcase
//
//  Created by Tevin Jones on 3/25/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    //resets screen orientations to all
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    
    override func viewDidLoad() {
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "Email Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            
            passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
    }
    
    
    var emailph: String?
    
    let errorAtSignIn = UIAlertController(title: "Error", message: "Please enter a valid username and password", preferredStyle: .alert)
    
  
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                          
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        
        if  let email = emailTextfield.text, let password = passwordTextfield.text {
        
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e)
                    self.errorAtSignIn.addAction(self.okAction)
                    self.present(self.errorAtSignIn, animated: true)
                }
                else {
                    
                    self.emailph = email
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                    
    
                }
            
            }}}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.registerSegue {
            
            let destinationVC = segue.destination as? ChooseViewController
            destinationVC?.navigationItem.title = emailph
            
        }
        
    }
    }
    


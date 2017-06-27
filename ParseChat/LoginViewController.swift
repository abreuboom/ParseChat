//
//  LoginViewController.swift
//  ParseChat
//
//  Created by John Abreu on 6/26/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        // check if user is logged in.
        if PFUser.current() != nil {
            // if there is a logged in user then load the home view controller
            print("Already Logged In")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginUser(_ sender: UIButton) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        
        if username.isEmpty {
            let alertController = UIAlertController(title: "Username Required", message: "Please input username", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: {
                    self.usernameField.becomeFirstResponder()
                })
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true)
        }
        else if password.isEmpty{
            let alertController = UIAlertController(title: "Password Required", message: "Please input password", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: {
                    self.passwordField.becomeFirstResponder()
                })
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true)
        }
        else {
            PFUser.logInWithUsername(inBackground: username.trimmingCharacters(in: .whitespaces), password: password, block: { (user: PFUser?, error: Error?) in
                if let error = error {
                    print("User log in failed: \(error.localizedDescription)")
                } else {
                    print("User logged in successfully")
                    
                    // display view controller that needs to shown after successful login
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            })
        }
        
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        // initialize a user object
        let newUser = PFUser()
        
        
        let email = emailField.text ?? ""
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        
        
        
        if email.isEmpty {
            let alertController = UIAlertController(title: "Email Required", message: "Please input email", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: {
                    self.usernameField.becomeFirstResponder()
                })
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true)
        }
        else if username.isEmpty {
            let alertController = UIAlertController(title: "Username Required", message: "Please input username", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: {
                    self.usernameField.becomeFirstResponder()
                })
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true)
        }
        else if password.isEmpty{
            let alertController = UIAlertController(title: "Password Required", message: "Please input password", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: {
                    self.passwordField.becomeFirstResponder()
                })
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            present(alertController, animated: true)
        }
        else {
        
        // set user properties
        newUser.username = username.trimmingCharacters(in: .whitespaces)
        newUser.email = email
        newUser.password = password
        
        // call sign up function on the object
        newUser.signUpInBackground() { (success: Bool, error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

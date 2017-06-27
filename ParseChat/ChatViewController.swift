//
//  ChatViewController.swift
//  ParseChat
//
//  Created by John Abreu on 6/26/17.
//  Copyright © 2017 John Abreu. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var chatView: UITableView!
    
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        chatView.insertSubview(refreshControl, at: 0)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        
        // Auto size row height based on cell autolayout constraints
        chatView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        chatView.estimatedRowHeight = 50
        
        chatView.delegate = self
        chatView.dataSource = self
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Cannot Get Messages", message: "The internet connection appears to be offline", preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let query = PFQuery(className: "Message_fbu2017")
        query.includeKey("user")
        query.limit = 25
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground() {(posts: [PFObject]?, error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                self.alert()
            } else {
                self.messages = posts!
                refreshControl.endRefreshing()
            }
        }
        
        chatView.reloadData()
        
    }
    
    func getData () {
        let query = PFQuery(className: "Message_fbu2017")
        query.includeKey("user")
        query.limit = 25
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground() {(posts: [PFObject]?, error: Error?) -> Void in
            if let error = error {
                self.alert()
                print(error.localizedDescription)
            } else {
                self.messages = posts!
            }
        }
        chatView.reloadData()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        PFUser.logOutInBackground(block: { (success: Bool, error: Error?)-> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                window?.rootViewController = loginViewController
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendChat(_ sender: UIButton) {
        let chatMessage = PFObject(className: "Message_fbu2017")
        chatMessage["user"] = PFUser.current()
        chatMessage["text"] = chatField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let message = messages[indexPath.row]
        
        if let text = message["text"] as? String {
            cell.message.text = text
            print(cell.message.text ?? "NOOOO")
        }
        
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.sender.text = user.username
        } else {
            // No user found, set default username
            cell.sender.text = "🤖"
        }
        
        cell.selectionStyle = .none
        
        return cell
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

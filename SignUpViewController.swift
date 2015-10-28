//
//  SignUpViewController.swift
//  YouDJ
//
//  Created by Soren Nelson on 9/18/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {

    @IBOutlet weak var reEnterPassword: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var session: SPTSession?
    var player: SPTAudioStreamingController?
    
    func loginSpotify () {
        
        SPTAuth.defaultInstance().clientID = "e7edf0d804bf497d8b58012ce3055c0c"
        SPTAuth.defaultInstance().redirectURL = NSURL(string: "udj://returnafterlogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        
        //Login URl
        let spotifyLoginUrl = SPTAuth.defaultInstance().loginURL
        
        UIApplication.sharedApplication().openURL(spotifyLoginUrl)
        
        
        // Open URL method
        //        application.performSelector(Selector("openURL:"), withObject: spotifyLoginUrl, afterDelay: 0.1)
        
    }
    
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        let ref = Firebase(url: "https://youdj.firebaseio.com/")
        if self.reEnterPassword.text == self.passwordTextField.text {
        ref.createUser(self.emailTextField.text, password: self.passwordTextField.text) { error, result in
            
            if error != nil{
                print(error.localizedDescription)
                
            } else {
                let usersRef = ref.childByAppendingPath("users")
                
                let uid = result["uid"] as? String
                let newUser = User(email: self.emailTextField.text!, password: self.passwordTextField.text!, name: self.usernameTextField.text!, uid: uid!)
                let newUserRef = usersRef.childByAppendingPath("\(newUser.uid)")
                newUserRef.setValue(newUser.toAnyObject())
                self.performSegueWithIdentifier("signedUp", sender: sender)
                
                
            }
        }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

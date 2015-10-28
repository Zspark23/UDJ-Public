//
//  LoginViewController.swift
//  YouDJ
//
//  Created by Zack Spicer on 9/14/15.
//  Copyright © 2015 Jordan Nelson. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, SPTAuthViewDelegate  {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginStatus: UILabel!
    
    static let sharedInstance = LoginViewController()
    var session: SPTSession?
   
    
    let kClientID = "e7edf0d804bf497d8b58012ce3055c0c"
    
    let kCallbackURL = "udj://returnafterlogin"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logInButtonTapped(sender: AnyObject) {
        
        let ref = Firebase(url: "https://youdj.firebaseio.com/")
        ref.authUser(self.usernameTextField.text, password: self.passwordTextField.text,
            withCompletionBlock: { error, authData in
                
                if error != nil {
                    print("login failed")
                    self.loginStatus.text = "Username and password do not match"
                    self.loginStatus.textColor = UIColor.redColor()
                    
                } else {
                    print("WE MADE IT")
                    self.performSegueWithIdentifier("loginSuccess", sender: sender)
                    // We are now logged in
                }
        })
    }
    
//    @IBAction func logInFacebookButtonTapped(sender: AnyObject) {
//        
//        let ref = Firebase(url: "https://youdj.firebaseio.com")
//        let facebookLogin = FBSDKLoginManager()
//}
    
    
    
    //  MARK: - Spotify Login
    @IBAction func logInWithSpotify(sender: UIButton) {
        let spotifyAuthenticator = NetworkController.sharedInstance.spotifyAuthenticator
        spotifyAuthenticator.clientID = kClientID
        spotifyAuthenticator.requestedScopes = [SPTAuthStreamingScope]
        spotifyAuthenticator.redirectURL = NSURL(string: kCallbackURL)
        
        let spotifyAuthenticationViewController = SPTAuthViewController.authenticationViewController()
        spotifyAuthenticationViewController.delegate = self
        spotifyAuthenticationViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        spotifyAuthenticationViewController.definesPresentationContext = true
        presentViewController(spotifyAuthenticationViewController, animated: false, completion: nil)
    }
    
    // SPTAuthViewDelegate protocol methods
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        NetworkController.sharedInstance.setupSpotifyPlayer(session) { (success) -> () in
            if success == true {
                self.performSegueWithIdentifier("loginSuccess", sender: self)
            } else {
                print("Failure to login to Spotify")
            }
        }
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("login cancelled")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("login failed")
    }

    
//    var session: SPTSession?
//    var player: SPTAudioStreamingController?
//    
//    func loginSpotify () {
//        
//        SPTAuth.defaultInstance().clientID = "e7edf0d804bf497d8b58012ce3055c0c"
//        SPTAuth.defaultInstance().redirectURL = NSURL(string: "udj://returnafterlogin")
//        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
//        
//        //Login URl
//        let spotifyLoginUrl = SPTAuth.defaultInstance().loginURL
//        
//        UIApplication.sharedApplication().openURL(spotifyLoginUrl)
//        
//        // Open URL method
////        application.performSelector(Selector("openURL:"), withObject: spotifyLoginUrl, afterDelay: 0.1)
//        
//    }
//
//    
//    //    MARK: -  OpenURL
//    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
//        if (SPTAuth.defaultInstance().canHandleURL(url)) {
//            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, session) -> Void in
//                if (error != nil) {
//                    print("AUTH ERROR:\(error)")
//                    return
//                } else {
//                    print(session.accessToken)
//                }
//            })
//            return true
//        }
//        return false
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

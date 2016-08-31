//
//  ViewController.swift
//  my-plugin
//
//  Created by Chiok Wai Hong on 8/30/16.
//  Copyright © 2016 LetsLookIn Enterprise. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    var btnSignIn : GIDSignInButton!
    var btnSignOut : UIButton!
    var btnDisconnect : UIButton!
    var label : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        btnSignIn = GIDSignInButton(frame: CGRectMake(0,0,230,48))
        btnSignIn.center = view.center
        btnSignIn.style = GIDSignInButtonStyle.Standard
        view.addSubview(btnSignIn)
        
        btnSignOut = UIButton(frame: CGRectMake(0,0,100,30))
        btnSignOut.center = CGPointMake(view.center.x, 100)
        btnSignOut.setTitle("Sign Out", forState: UIControlState.Normal)
        btnSignOut.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btnSignOut.setTitleColor(UIColor.cyanColor(), forState: UIControlState.Highlighted)
        btnSignOut.addTarget(self, action: #selector(ViewController.btnSignOutPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btnSignOut)
        
        btnDisconnect = UIButton(frame: CGRectMake(0,0,100,30))
        btnDisconnect.center = CGPointMake(view.center.x, 200)
        btnDisconnect.setTitle("Disconnect", forState: UIControlState.Normal)
        btnDisconnect.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btnDisconnect.setTitleColor(UIColor.cyanColor(), forState: UIControlState.Highlighted)
        btnDisconnect.addTarget(self, action: #selector(ViewController.btnDisconnectPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btnDisconnect)
        
        
        label = UILabel(frame: CGRectMake(0,0,200,100))
        label.center = CGPointMake(view.center.x, 400)
        label.numberOfLines = 0 //Multi-lines
        label.text = "Please Sign in."
        label.textAlignment = NSTextAlignment.Center
        view.addSubview(label)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
                                                         name: "ToggleAuthUINotification",
                                                         object: nil)
        
        toggleAuthUI()
    }
    
    func btnSignOutPressed(sender: UIButton) {
        GIDSignIn.sharedInstance().disconnect()
        label.text = "Disconnecting."
    }
    
    func btnDisconnectPressed(sender: UIButton) {
        label.text = "Signed out."
        toggleAuthUI()
    }
    
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            btnSignIn.hidden = true
            btnSignOut.hidden = false
            btnDisconnect.hidden = false
        } else {
            btnSignIn.hidden = false
            btnSignOut.hidden = true
            btnDisconnect.hidden = true
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: "ToggleAuthUINotification",
                                                            object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        if (notification.name == "ToggleAuthUINotification") {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                let userInfo:Dictionary<String,String!> =
                    notification.userInfo as! Dictionary<String,String!>
                self.label.text = userInfo["statusText"]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
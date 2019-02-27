//
//  LoginVC.swift
//  Twitter
//
//  Created by Henry Guerra on 2/25/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    /* Public Actions */
    @IBAction func loginButton(_ sender: Any) {
        let loginURL = "https://api.twitter.com/oauth/request_token"
        
        // check if user is valid
        UserDefaults.standard.set(true, forKey: "userLoggedIn")
        
        TwitterAPICaller.client?.login(url: loginURL, success: {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("Login Error")
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // User persistance
        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

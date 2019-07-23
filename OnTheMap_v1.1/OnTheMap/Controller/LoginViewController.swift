//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lucas Stern on 01/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin_Click(_ sender: UIButton) {
        guard txtUser.text!.isEmpty == false && txtPassword.text!.isEmpty == false else {
            showErrorAlert("Email or password is empty")
            return
        }
        LoadingOverlay.shared.showOverlay(view: self.view)
        UdacityAPI.sharedInstance().createSession(username: txtUser.text!, password: txtPassword.text!) { (error) in
            performUIUpdatesOnMain {
                LoadingOverlay.shared.hideOverlayView()
                
                guard error == nil else {
                    self.showErrorAlert(error!)
                    return
                }
                
                self.presentViewControllerWithIdentifier(identifier: "NavigationViewController")
            }
        }
    }
    
    @IBAction func btnRegister_Click(_ sender: UIButton) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

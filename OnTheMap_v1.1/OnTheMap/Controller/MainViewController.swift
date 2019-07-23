//
//  MainViewController.swift
//  OnTheMap
//
//  Created by Lucas Stern on 02/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRefresh_Click(UIBarButtonItem())
    }
    
    @IBAction func btnLogout_Click(_ sender: UIBarButtonItem) {
        showConfirmationAlert("Would you like to logout?", actionButtonTitle: "Logout") { (action) in
            UdacityAPI.sharedInstance().deleteSession(handler: { (error) in
                performUIUpdatesOnMain {
                    guard error == nil else {
                        self.showErrorAlert(error!)
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func btnRefresh_Click(_ sender: UIBarButtonItem) {
        LoadingOverlay.shared.showOverlay(view: self.view)
        LocationAPI.sharedInstance().getStudents { (students, error) in
            performUIUpdatesOnMain {
                LoadingOverlay.shared.hideOverlayView()
                guard error == nil else {
                    self.showErrorAlert(error!)
                    return
                }
                
                Storage.shared.students = students!
                (self.viewControllers![0] as! MapViewController).refresh()
                (self.viewControllers![1] as! ListViewController).refresh()
            }
        }
    }
    
    @IBAction func btnPin_Click(_ sender: UIBarButtonItem) {
        LoadingOverlay.shared.showOverlay(view: self.view)
        LocationAPI.sharedInstance().getStudent(userKey: UdacityAPI.sharedInstance().userId!) { (student, error) in
            performUIUpdatesOnMain {
                LoadingOverlay.shared.hideOverlayView()
                guard error == nil else {
                    self.showErrorAlert(error!)
                    return
                }
                
                Storage.shared.student = student
                
                if student == nil {
                    self.showPostingView()
                }
                else {
                    self.showConfirmationAlert("You have already posted mark \"\(student!.labelName) as \(student!.mapString)\". Would you like to overwrite it?", actionButtonTitle: "Overwrite") { (action) in
                        self.showPostingView()
                    }
                }
            }
        }
    }
    
    private func showPostingView(studentLocationID: String? = nil) {
        let postingView = storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as! PostingViewController
        navigationController?.pushViewController(postingView, animated: true)
    }
}

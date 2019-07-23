//
//  PinViewController.swift
//  OnTheMap
//
//  Created by Lucas Stern on 02/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import UIKit
import CoreLocation

class PostingViewController: UIViewController {

    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtLink: UITextField!
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add Location"
        
        let backButton = UIBarButtonItem()
        backButton.title = "CANCEL"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func btnFind_Click(_ sender: UIButton) {
        let location = txtLocation.text!
        let link = txtLink.text!
        
        if location.isEmpty || link.isEmpty {
            showErrorAlert("All fields are required.")
            return
        }
        guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            showErrorAlert("Please provide a valid link.")
            return
        }
        
        LoadingOverlay.shared.showOverlay(view: self.view)
        UdacityAPI.sharedInstance().getUserInfo { (user, error) in
            performUIUpdatesOnMain {
                LoadingOverlay.shared.hideOverlayView()
                
                guard error == nil else {
                    self.showErrorAlert(error!)
                    return
                }
                
                Storage.shared.user = user
                self.geocode(location: location)
            }
        }
    }
    
    private func geocode(location: String) {
        LoadingOverlay.shared.showOverlay(view: self.view)
        geocoder.geocodeAddressString(location) { (placemarkers, error) in
            
            performUIUpdatesOnMain {
                LoadingOverlay.shared.hideOverlayView()
            }
            
            if let error = error {
                self.showErrorAlert("Unable to Forward Geocode Address (\(error))")
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    self.syncStudentLocation(location.coordinate)
                } else {
                    self.showErrorAlert("No Matching Location Found")
                }
            }
        }
    }
    
    private func syncStudentLocation(_ coordinate: CLLocationCoordinate2D) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MapPinViewController") as! MapPinViewController
        viewController.student = buildStudentInfo(coordinate)
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> Student {
        var studentInfo = [
            "uniqueKey": UdacityAPI.sharedInstance().userId!,
            "firstName": Storage.shared.user!.firstName,
            "lastName": Storage.shared.user!.lastName,
            "mapString": txtLocation.text!,
            "mediaURL": txtLink.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let student = Storage.shared.student {
            studentInfo["objectId"] = student.locationID! as AnyObject
        }
        return Student(studentInfo)
    }
}

//
//  MapPinViewController.swift
//  OnTheMap
//
//  Created by Lucas Stern on 04/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPinViewController: BaseMapViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showLocations()
    }
    
    @IBAction func btnFinish_Click(_ sender: UIButton) {
        if let student = student {
            LoadingOverlay.shared.showOverlay(view: self.view)
            if student.locationID == nil {
                LocationAPI.sharedInstance().postStudent(student: student) { (error) in
                    performUIUpdatesOnMain {
                        LoadingOverlay.shared.hideOverlayView()
                        self.handleSyncLocationResponse(error: error)
                    }
                }
            }
            else {
                LocationAPI.sharedInstance().putStudent(student: student) { (error) in
                    performUIUpdatesOnMain {
                        LoadingOverlay.shared.hideOverlayView()
                        self.handleSyncLocationResponse(error: error)
                    }
                }
            }
        }
    }
    
    private func showLocations() {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate() {
            let annotation = MKPointAnnotation()
            annotation.title = student!.labelName
            annotation.subtitle = student?.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate() -> CLLocationCoordinate2D? {
        if let lat = student?.latitude, let lon = student?.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    private func handleSyncLocationResponse(error: String?) {
        if let error = error {
            self.showErrorAlert(error)
        } else {
            self.showAlert("Student Location updated!") { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

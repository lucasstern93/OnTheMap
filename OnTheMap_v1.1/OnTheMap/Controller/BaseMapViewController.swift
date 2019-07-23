//
//  BaseMapViewController.swift
//  OnTheMap
//
//  Created by Lucas Stern on 04/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class BaseMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else  {
                self.showErrorAlert("No link defined.")
                return
            }
            guard let link = subtitle else {
                self.showErrorAlert("No link defined.")
                return
            }
            openUrl(url: link)
        }
    }
    
}

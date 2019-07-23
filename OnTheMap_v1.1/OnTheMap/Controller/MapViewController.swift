//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lucas Stern on 02/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseMapViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    func refresh() {
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for student in Storage.shared.students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = student.labelName
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
}

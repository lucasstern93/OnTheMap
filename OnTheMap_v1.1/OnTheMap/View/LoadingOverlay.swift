//
//  LoadingOverlay.swift
//  OnTheMap
//
//  Created by Lucas Stern on 01/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay {

    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    // Singleton instance of ParseClient
    static let shared = LoadingOverlay()

    public func showOverlay(view: UIView!) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

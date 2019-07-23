//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Lucas Stern on 01/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import UIKit

extension UIViewController {

    func showErrorAlert(_ message: String, dismissButtonTitle: String = "OK") {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })

        self.present(controller, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String, dismissButtonTitle: String = "OK", handler: @escaping ((UIAlertAction?) -> Void)) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default, handler: handler))
        
        self.present(controller, animated: true, completion: nil)
    }

    func showConfirmationAlert(_ message: String, dismissButtonTitle: String = "Cancel", actionButtonTitle: String = "OK", handler: @escaping ((UIAlertAction?) -> Void)) {
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })

        controller.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: handler))

        self.present(controller, animated: true, completion: nil)
    }

    func presentViewControllerWithIdentifier(identifier: String, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = storyboard!.instantiateViewController(withIdentifier: identifier)
        present(controller, animated: animated, completion: completion)
    }

    func openUrl(url: String) {
        let app = UIApplication.shared
        if let url = URL(string: url), app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        }
        else {
            showErrorAlert("Looks like it's not a link :'(")
        }
    }
}

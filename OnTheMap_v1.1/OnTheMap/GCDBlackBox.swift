//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Lucas Stern on 29/05/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

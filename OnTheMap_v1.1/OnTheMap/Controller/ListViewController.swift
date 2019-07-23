//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Lucas Stern on 02/06/2018.
//  Copyright © 2018 Stern. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    func refresh() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.shared.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = Storage.shared.students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        cell.textLabel?.text = student.labelName
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openUrl(url: Storage.shared.students[indexPath.row].mediaURL)
    }
}

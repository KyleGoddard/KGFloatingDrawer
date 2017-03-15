//
//  LeftDrawerTableViewController.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-16.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit

class LeftDrawerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: <TableViewDataSource>
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if indexPath.row == 2 {
            appDelegate.centerViewController = appDelegate.sourcePageViewController()
        } else if indexPath.row == 3 {
            appDelegate.centerViewController = appDelegate.drawerSettingsViewController()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

}

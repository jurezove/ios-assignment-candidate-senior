//
//  TableViewDataSource.swift
//  Assignment
//
//  Created by Matic Kunaver on 09/02/16.
//  Copyright © 2016 Matic Kunaver. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    let reuseIdentifierHeaderViewCell = "tableViewCellIdentifier"
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierHeaderViewCell, forIndexPath: indexPath)
        
        return cell
    }
}

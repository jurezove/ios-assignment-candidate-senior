//
//  TableViewDataSource.swift
//  Assignment
//
//  Created by Matic Kunaver on 09/02/16.
//  Copyright © 2016 Matic Kunaver. All rights reserved.
//

import UIKit

enum DataSourceType: Int {
    case First = 0
    case Second
    case Third
}

class TableViewDataSource: NSObject, UITableViewDataSource {
    var dataSourceType = DataSourceType.First
    
    let reuseIdentifierHeaderViewCell = "tableViewCellIdentifier"
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierHeaderViewCell, forIndexPath: indexPath)
        
        switch dataSourceType {
        case .First:
            cell.textLabel?.text = NSLocalizedString("First data source, row \(indexPath.row + 1)", comment: "")
        case .Second:
            cell.textLabel?.text = NSLocalizedString("Second data source, row \(indexPath.row + 1)", comment: "")
        case .Third:
            cell.textLabel?.text = NSLocalizedString("Third data source, row \(indexPath.row + 1)", comment: "")
        }
        
        return cell
    }
}

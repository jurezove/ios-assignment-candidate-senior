//
//  HeaderViewDataSource.swift
//  Assignment
//
//  Created by Matic Kunaver on 09/02/16.
//  Copyright © 2016 Matic Kunaver. All rights reserved.
//

import UIKit

class HeaderViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifierHeaderViewCell = "headerViewCell"
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierHeaderViewCell, forIndexPath: indexPath) as! HeaderCollectionViewCell
        
        collectionViewCell.titleLabel.text = NSLocalizedString("Summary view \(indexPath.row + 1)", comment: "")
        
        return collectionViewCell
    }
    
}

//
//  ViewController.swift
//  Assignment
//
//  Created by Matic Kunaver on 09/02/16.
//  Copyright © 2016 Matic Kunaver. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    let tableViewContext = UnsafeMutablePointer<()>()
    
    // MARK: IB Outlets
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stickyHeaderView: UIView!
    @IBOutlet weak var headerSegmentedControl: UISegmentedControl!
    
    // Constraints
    @IBOutlet weak var headerHeightViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightCollectionViewConstraint: NSLayoutConstraint!
    
    private let _headerViewDataSource = HeaderViewDataSource()
    private let _tableViewDataSource = TableViewDataSource()
    
    private var _headerHeight: CGFloat = 0.0 {
        didSet {
            if _headerHeight != oldValue {
                // Update views only if view controller size changes (rotations changes etc)
                updateInitialViewDimensions()
            }
        }
    }
    
    private let viewEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup data sources
        setupCollectionView()
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "contentOffset", context: tableViewContext)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _headerHeight = view.bounds.size.height/CGFloat(2.0) // Max header height is half the screen
    }
    
    private func updateInitialViewDimensions() {
        tableView.contentInset = UIEdgeInsetsMake(_headerHeight, 0, 0, 0)
        tableView.contentOffset = CGPointMake(0,-_headerHeight)
        tableView.scrollIndicatorInsets = tableView.contentInset
        headerHeightCollectionViewConstraint.constant = _headerHeight - headerSegmentedControl.bounds.size.height
        
        headerCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupCollectionView() {
        headerCollectionView.dataSource = _headerViewDataSource
        headerCollectionView.delegate = self
        
        if let layout = headerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = 0.0
        }
        
        self.tableView.addObserver(self, forKeyPath: "contentOffset", options: [.New, .Old], context: tableViewContext)
    }
    
    private func setupTableView() {
        tableView.dataSource = _tableViewDataSource
        tableView.delegate = self
    }
    
    // MARK: CollectionView Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return headerCollectionView.bounds.size
    }
    
    // MARK: TableView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == tableView {
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if tableViewContext == context {
            if let change = change
            {
                let offset = change[NSKeyValueChangeNewKey]?.CGPointValue
                
                let offsetY = offset!.y
                
                let topOffsetLimit = stickyHeaderView.bounds.size.height + viewEdgeInsets.top
                
                // Top sticky header limit
                if (offsetY >= -topOffsetLimit) {
                    headerHeightViewConstraint.constant = topOffsetLimit
                }
                else if (offsetY <= -_headerHeight) {
                    headerHeightViewConstraint.constant = _headerHeight
                }
                else {
                    // Fix constraints to top and tableview insests for floating header
                    headerHeightViewConstraint.constant = -offset!.y;
                    tableView.contentInset = UIEdgeInsetsMake(-offset!.y, 0, 0, 0)
                    tableView.scrollIndicatorInsets = tableView.contentInset
                }
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

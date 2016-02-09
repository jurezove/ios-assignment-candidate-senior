//
//  ViewController.swift
//  Assignment
//
//  Created by Matic Kunaver on 09/02/16.
//  Copyright © 2016 Matic Kunaver. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    let tableViewObserverContext = UnsafeMutablePointer<()>()
    
    // MARK: IB Outlets
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stickyHeaderView: UIView!
    @IBOutlet weak var headerSegmentedControl: UISegmentedControl!
    
    // Constraints
    @IBOutlet weak var headerHeightViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightCollectionViewConstraint: NSLayoutConstraint!
    
    // Design variables
    private var _headerHeight: CGFloat = 0.0 {
        didSet {
            if _headerHeight != oldValue {
                // Update views only if view controller size changes (rotations changes etc)
                updateInitialViewDimensions()
            }
        }
    }
    
    private var _topLimitY: CGFloat {
        get {
            return stickyHeaderView.bounds.size.height + 20.0 // Status bar height
        }
    }
    
    private let _headerViewDataSource = HeaderViewDataSource()
    private let _tableViewDataSource = TableViewDataSource()
    
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
        tableView.removeObserver(self, forKeyPath: "contentOffset", context: tableViewObserverContext)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _headerHeight = view.bounds.size.height/CGFloat(2.0) // Max header height is half the screen
    }
    
    // Animate collection view page position when rotating
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let currentPageIndexPath = headerCollectionView.indexPathsForVisibleItems().first
        
        if let indexPath = currentPageIndexPath {
            coordinator.animateAlongsideTransition({ (coordinatorContext) -> Void in
                self.headerCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
                },
                completion: nil)
        }
    }
    
    private func updateInitialViewDimensions() {
        // Make scroll view content smaller by adding content insets
        tableView.contentInset = UIEdgeInsetsMake(_headerHeight, tableView.contentInset.left, tableView.contentInset.bottom, tableView.contentInset.right)
        tableView.contentOffset = CGPointMake(0,-_headerHeight)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.alwaysBounceVertical = true
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
        
        self.tableView.addObserver(self, forKeyPath: "contentOffset", options: [.New,], context: tableViewObserverContext)
    }
    
    private func setupTableView() {
        tableView.dataSource = _tableViewDataSource
        tableView.delegate = self
    }
    
    private func changeDataSourceWithType(sourceType: DataSourceType) {
        _tableViewDataSource.dataSourceType = sourceType
        
        // Reset offset, so the whole content is visble when we change data source
        if (tableView.contentOffset.y > -_topLimitY) {
            tableView.contentOffset = CGPointMake(0,-_topLimitY)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        tableView.reloadData()
    }
    
    
    // MARK: CollectionView Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return headerCollectionView.bounds.size
    }
    
    // MARK: TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if tableViewObserverContext == context {
            if let change = change
            {
                let offset = change[NSKeyValueChangeNewKey]?.CGPointValue
                
                let offsetY = offset!.y
                
                // Top sticky header limit
                if (offsetY >= -_topLimitY) {
                    headerHeightViewConstraint.constant = _topLimitY
                }
                else if (offsetY <= -_headerHeight) {
                    headerHeightViewConstraint.constant = _headerHeight
                }
                else {
                    // Fix constraints to top
                    headerHeightViewConstraint.constant = -offset!.y;
                }
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: Actions
    @IBAction func segmentedControlChangedValue(sender: UISegmentedControl) {
        let type = DataSourceType(rawValue:sender.selectedSegmentIndex)
        
        if let type = type {
            changeDataSourceWithType(type)
        }
    }
    
    
}

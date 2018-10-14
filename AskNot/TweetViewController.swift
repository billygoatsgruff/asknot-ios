//
//  TweetViewController.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import ThryvUXComponents
import MultiModelTableViewDataSource

class TweetViewController: THUXRefreshableTableViewController, TweetsListViewModelDelegate {
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweetsViewModel: TweetsListViewModel!
    var dataSource: MultiModelTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsViewModel = TweetsListViewModel()
        tweetsViewModel.delegate = self
        tweetsViewModel.fetchTweets()
        
        title = "Tweets"
        
        navigationController?.navigationBar.isTranslucent = false
        
        setupTableView()
        
        let profile = UIBarButtonItem(image: UIImage(named: "profile"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(pushProfile))
        navigationItem.rightBarButtonItem = profile
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        VersionChecker.isVersion(VersionChecker.appVersionString()) { (isCurrent) in
            if !isCurrent {
                let alertController = UIAlertController(title: "New version!", message: "New features and improvements are waiting!", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Yay!", style: UIAlertAction.Style.default, handler: { (action) in
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/asknot/id1205213169?ls=1&mt=8")!, options: [:], completionHandler: nil)
                }))
                alertController.show()
            }
        }
    }
    
    func setupTableView() {
        tableDataSource = TweetsTableViewDataSource()
        tableDataSource.retweetDelegate = self.tweetsViewModel
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self.tweetsViewModel, action: #selector(self.tweetsViewModel.fetchTweets), for: .valueChanged)
        tweetsTableView.refreshControl = refreshControl
        
        tweetsTableView.tableFooterView = UIView(frame: CGRect.zero)
        tweetsTableView.estimatedRowHeight = view.bounds.size.height - (navigationController?.navigationBar.bounds.size.height)! - 20
        tweetsTableView.rowHeight = view.bounds.size.height - (navigationController?.navigationBar.bounds.size.height)! - 20
    }
    
    @objc func pushProfile() {
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    func displayShareSheet(shareContent: String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func finishedLoadingTweets(_ error: NSError?){
        if let e = error {
            if e.domain == "Server" && e.code == 401 {
                UserDefaults.standard.set(nil, forKey: LoginCall.ApiKeyPref)
                self.dismiss(animated: true, completion: nil)
            }
            return
        } else {
            self.tableDataSource.tweets = self.tweetsViewModel.tweets
            self.tableDataSource.tweetIds = self.tweetsViewModel.tweetIds
            
            self.tweetsTableView.delegate = self.tableDataSource
            self.tweetsTableView.dataSource = self.tableDataSource
            self.tweetsTableView.reloadData()
        }
        self.tweetsTableView.refreshControl?.endRefreshing()
    }
    
    func scrollToNextPage() {
        if tweetsTableView.contentOffset.y < ((CGFloat(self.tweetsViewModel.tweets?.count ?? 0)) - 1 as CGFloat) * self.tweetsTableView.frame.height {
            UIView.animate(withDuration: 0.3) {
                self.tweetsTableView.contentOffset.y += self.tweetsTableView.frame.height
            }
        } else {
            self.tweetsTableView.reloadData()
        }
    }

}

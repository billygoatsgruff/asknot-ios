//
//  ProfileViewController.swift
//  AskNot
//
//  Created by Elliot Schrock on 3/6/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import MessageUI
import ThryvUXComponents
import MultiModelTableViewDataSource
import Prelude

class ProfileViewController: THUXRefreshableTableViewController, MFMailComposeViewControllerDelegate, ProfileViewModelDelegate {
    @IBOutlet weak var trendsTableView: UITableView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var supporterLabel: UILabel!
    @IBOutlet weak var trendsLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    var viewModel: ProfileViewModel!
    var dataSource = MultiModelTableViewDataSource()

    override func viewDidLoad() {
        dataSource.tableView = trendsTableView
        
        tableView = trendsTableView
        tableView.dataSource = dataSource
        
        let trendsCall = TrendsCall()
        trendsCall.trendsSignal.observeValues { trends in
            if trends.count == 0 {
                self.trendsLabel.isHidden = true
            }
            let section = MultiModelTableViewDataSourceSection()
            section.items = trends.map { TrendItem(identifier: "cell", $0) }
            self.dataSource.sections = section |> arrayOfSingleObject
            self.tableView.reloadData()
        }
        refreshableModelManager = THUXRefreshableNetworkCallManager(trendsCall)
        
        super.viewDidLoad()
        
        title = "Profile"
        
        trendsTableView.tableFooterView = UIView(frame: CGRect.zero)

        viewModel = ProfileViewModel()
        viewModel.delegate = self
        viewModel.fetchProfile()
        
        let feedback = UIBarButtonItem(image: UIImage(named: "feedback"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(giveFeedback))
        navigationItem.rightBarButtonItem = feedback
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
    
    @objc func giveFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let controller: MFMailComposeViewController = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            controller.setToRecipients(["william.goats.gruff@gmail.com"])
            controller.setSubject("Feedback!")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func sharePressed() {
    }
    
    @IBAction func contributeLabel() {
    }
    
    func didFetchProfile(_ error: NSError?) {
        if let e = error {
            if e.domain == "Server" && e.code == 401 {
                UserDefaults.standard.set(nil, forKey: LoginCall.ApiKeyPref)
                self.dismiss(animated: true, completion: nil)
            }
        }
        if let retweetCount = self.viewModel.user?.retweetsCount {
            self.retweetCount.text = "\(retweetCount)"
        }
        if let hasShared = self.viewModel.user?.hasShared {
            self.sharedLabel.text = hasShared ? "Yup! YAY!" : "Maybe later"
        }
        if let isSupporter = self.viewModel.user?.isSupporter {
            self.supporterLabel.text = isSupporter ? "Yes!!" : "Not yet"
        }
    }
    
    func didFetchTrends(_ error: NSError?) {}
}

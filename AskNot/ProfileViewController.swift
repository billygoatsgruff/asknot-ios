//
//  ProfileViewController.swift
//  AskNot
//
//  Created by Elliot Schrock on 3/6/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import MessageUI

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate, ProfileViewModelDelegate {
    @IBOutlet weak var trendsTableView: UITableView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var supporterLabel: UILabel!
    @IBOutlet weak var trendsLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    var viewModel: ProfileViewModel!
    var dataSource: TrendsDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        dataSource = TrendsDataSource()
        
        trendsTableView.tableFooterView = UIView(frame: CGRect.zero)

        viewModel = ProfileViewModel()
        viewModel.delegate = self
        viewModel.fetchProfile()
        viewModel.fetchTrends()
        
        let profile = UIBarButtonItem(image: UIImage(named: "feedback"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(giveFeedback))
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
        if let retweetCount = self.viewModel.user?.retweetsCount {
            self.retweetCount.text = "\(retweetCount.intValue)"
        }
        if let hasShared = self.viewModel.user?.hasShared {
            self.sharedLabel.text = hasShared ? "Yup! YAY!" : "Maybe later"
        }
        if let isSupporter = self.viewModel.user?.isSupporter {
            self.supporterLabel.text = isSupporter ? "Yes!!" : "Not yet"
        }
    }
    
    func didFetchTrends(_ error: NSError?) {
        if let e = error {
            if e.domain == "Server" && e.code == 401 {
                UserDefaults.standard.set(nil, forKey: LoginCall.ApiKeyPref)
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            if self.viewModel.trends?.count == 0 {
                self.trendsLabel.isHidden = true
            }
            self.dataSource.trends = self.viewModel.trends
            
            self.trendsTableView.delegate = self.dataSource
            self.trendsTableView.dataSource = self.dataSource
            self.trendsTableView.reloadData()
        }
    }
}

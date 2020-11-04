//
//  UserProfileViewController.swift
//  ANLib
//
//  Created by Elliot Schrock on 10/30/20.
//

import fuikit
import LUX
import MessageUI
import FunNet
import Combine
import Slippers
import LithoOperators
import Prelude

func profileVC() -> UserProfileViewController {
    let vc = UserProfileViewController.makeFromXIB()
    
    let call = CombineNetCall(configuration: Current.serverConfig, trendsGetEndpoint())
    let viewModel = refreshableTableViewModel(call, modelUnwrapper: ^\TrendsResponse.trends, configureTrendCell) { _ in }

    viewModel.sectionsPublisher.sink { sections in
        if sections.first?.items?.count ?? 0 > 0 {
            vc.trendLabel.isHidden = false
        }
    }.store(in: &viewModel.cancelBag)
    
    let profileCall = CombineNetCall(configuration: Current.serverConfig, currentUserGetEndpoint())
    let userPub = unwrappedModelPublisher(from: profileCall.publisher.$data.eraseToAnyPublisher(), ^\UserResponse.user)
    userPub.sink { [weak vc] in
        vc?.sharedLabel.text = $0.hasShared == true ? "Yup! (YAY!)" : "Maybe later"
        vc?.supporterLabel.text = $0.isSupporter == true ? "Yes!!" : "Not yet"
        vc?.retweetCount.text = "\($0.retweetsCount ?? 0)"
    }.store(in: &viewModel.cancelBag)
    let profileRefresher = Refresher(profileCall.fire)
    let metaRefresher = MetaRefresher(profileRefresher, viewModel.refresher)
    viewModel.refresher = metaRefresher
    
    let setupViewModel = { (profileVC: UserProfileViewController) in
        viewModel.tableView = profileVC.tableView
        profileVC.viewModel = viewModel
        viewModel.refresh()
    }
    let setupButtons = { (profileVC: UserProfileViewController) in
        profileVC.shareButton |> floatingButtonStyle
        profileVC.shareButton.isHidden = false
        
        let feedback = UIBarButtonItem(image: UIImage(named: "feedback"), style: UIBarButtonItem.Style.plain, target: profileVC, action: #selector(profileVC.giveFeedback))
        profileVC.navigationItem.rightBarButtonItem = feedback
    }
    let setupProfile = set(\UserProfileViewController.trendLabel!.isHidden, true) <> set(\UserProfileViewController.title, "Profile")
    
    vc.onViewDidLoad = optionalCast >?> (setupButtons <> setupProfile <> setupViewModel)
    return vc
}

func configureTrendCell(trend: Trend, cell: UITableViewCell) {
    cell.textLabel?.text = trend.text
}

class UserProfileViewController: FUITableViewViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var supporterLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var trendLabel: UILabel!
    var viewModel: LUXTableViewModel!
    
    @objc public func giveFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let controller: MFMailComposeViewController = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            controller.setToRecipients(["william.goats.gruff@gmail.com"])
            controller.setSubject("Feedback!")
            controller.mailComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sharePressed() {
        let url = URL(string: "https://asknot.app/")!
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        netCall(from: currentUserPutEndpoint(body: User(hasShared: true))).fire()
    }

}

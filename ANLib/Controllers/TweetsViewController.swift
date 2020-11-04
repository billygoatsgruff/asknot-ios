//
//  TweetsViewController.swift
//  ANLib
//
//  Created by Elliot Schrock on 10/30/20.
//

import fuikit
import LUX
import FunNet
import TwitterKit
import LithoOperators
import Prelude
import Combine
import FlexDataSource

class TweetsViewController: FUITableViewViewController {}

func tweetsViewController() -> FUITableViewViewController {
    let vc = FUITableViewViewController.makeFromXIB()
    
    let idCall = CombineNetCall(configuration: Current.serverConfig, tweetsGetEndpoint())
    let idPub = unwrappedModelPublisher(from: idCall.publisher.$data.eraseToAnyPublisher(), ^\TweetsResponse.tweets)
    
    let tweetsSubject = PassthroughSubject<[TWTRTweet], Never>()
    let tweetsPub = tweetsSubject.eraseToAnyPublisher()
    
    let modelPub = idPub.combineLatest(tweetsPub).map(assignTweets)
    
    let refreshManager = LUXRefreshableNetworkCallManager(idCall)
    
    let scroll: () -> Void = voidCurry(vc, scrollToNextTweet(vc:))
    let configurer = union(scroll, refreshManager.refresh) >|||> configureTweetCell(tweet:cell:tweetUpdated:)
    
    let modelToItem = configurer >||> LUXModelItem<TweetId, RetweetTableViewCell>.init
    let modelsToItems = modelToItem >||> map
    let itemsPub: AnyPublisher<[FlexDataSourceItem], Never> = modelPub.map(modelsToItems).map(vc >|> emptyOrAppendAction).eraseToAnyPublisher()
    let vm = LUXItemsTableViewModel(refreshManager, itemsPublisher: itemsPub)
    idPub.sink {
        fetchTweets(tweetIdValues: $0.compactMap(\.twitterId), subject: tweetsSubject)
    }.store(in: &vm.cancelBag)
    itemsPub.sink { [weak vc] _ in vc?.tableView?.refreshControl?.endRefreshing() }.store(in: &vm.cancelBag)
    
    vc.onViewDidLoad = set(\FUIViewController.title, "Tweets")
        <> addProfileNavItem
        <> (^\FUITableViewViewController.tableView >?> setupPagerTable)
        <> (vm >||> setupTableViewModel)
    
    vc.onViewWillAppear = ignoreSecondArg(f: {
        var height = $0.view.bounds.size.height
        if let insets = $0.navigationController?.view.safeAreaInsets {
            height = height - insets.bottom
        }
        $0.tableView?.estimatedRowHeight = height
        $0.tableView?.rowHeight = height
    })
    return vc
}

let setupPagerTable: (UITableView) -> Void = set(\UITableView.tableFooterView, UIView(frame: .zero))
    <> set(\UITableView.separatorStyle, .none)
    <> set(\UITableView.allowsSelection, false)
    <> set(\UITableView.isPagingEnabled, true)

let setupTableViewModel: (FUITableViewViewController, LUXRefreshableTableViewModel) -> Void = {
    $1.tableView = $0.tableView
    $1.refresh()
}

let addProfileNavItem: (UIViewController) -> Void = {
    let profile = UIBarButtonItem(title: nil,
                                  image: UIImage(named: "profile"),
                                  primaryAction: UIAction(handler: ignoreArg(voidCurry(profileVC(), $0.pushAnimated))),
                                  menu: nil)
    $0.navigationItem.rightBarButtonItem = profile
}

func scrollToNextTweet(vc: FUITableViewViewController) { vc.tableView ?> scrollToNextPage }
func scrollToNextPage(tableView: UITableView) {
    if tableView.contentOffset.y < CGFloat(tableView.numberOfRows(inSection: 0) - 1) * tableView.frame.height {
        UIView.animate(withDuration: 0.3) {
            tableView.contentOffset.y += tableView.frame.height
        }
    } else {
        tableView.reloadData()
    }
}

func emptyOrAppendAction(_ vc: UIViewController, _ items: [FlexDataSourceItem]) -> [FlexDataSourceItem] {
    var newItems = [FlexDataSourceItem]()
    newItems.append(contentsOf: items)
    if items.count > 0 {
        newItems.append(LUXModelItem.init(chooseAction(vc), configureActionCell))
    }
    return newItems
}

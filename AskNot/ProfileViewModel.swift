//
//  ProfileViewModel.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/21/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

protocol ProfileViewModelDelegate {
    func didFetchProfile(_ error: NSError?)
    func didFetchTrends(_ error: NSError?)
}

class ProfileViewModel: NSObject {
    var delegate: ProfileViewModelDelegate?
    var user: User?
    var trends: [Trend]?
    
    func fetchProfile() {
        let profileCall = ProfileCall()
        profileCall.userSignal.observeValues { user in
            self.user = user
            self.delegate?.didFetchProfile(nil)
        }
        profileCall.fire()
    }
    
    func fetchTrends() {
        let trendsCall = TrendsCall()
        trendsCall.trendsSignal.observeValues { trends in
            self.trends = trends
            self.delegate?.didFetchTrends(nil)
        }
        trendsCall.fire()
    }

}

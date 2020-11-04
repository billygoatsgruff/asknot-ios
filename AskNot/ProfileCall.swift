//
//  ProfileCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/12/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import LUX
import FunNet

class ProfileCall: THUXModelCall<UserResponse> {
    public lazy var userSignal = modelSignal.map { $0.user }.skipNil()
    
    init(configuration: ServerConfigurationProtocol = AskNotServerConfig.current, stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: configuration, httpMethod: "GET", httpHeaders: [:], endpoint: "current_user", postData: nil, stubHolder: stubHolder)
    }

}

//
//  User.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

class User: ServerObject, Decodable {
    var apiKey: String?
    var username: String?
    var hasShared: Bool?
    var isSupporter: Bool?
    var retweetsCount: Int?
}

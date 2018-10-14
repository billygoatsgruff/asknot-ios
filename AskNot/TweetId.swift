//
//  TweetId.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

class TweetId: ServerObject, Decodable {
    var twitterId: Int64 = 0
    var why: String?
}

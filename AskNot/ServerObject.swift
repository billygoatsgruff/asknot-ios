//
//  ServerObject.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import Eson

class ServerObject: NSObject, EsonKeyMapper {
    var objectId: Int!
    
    open static func esonPropertyNameToKeyMap() -> [String : String] {
        return ["objectId":"id"]
    }
}

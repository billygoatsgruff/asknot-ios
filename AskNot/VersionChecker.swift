//
//  VersionChecker.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/21/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

class VersionChecker: NSObject {
    
    static func isVersion(_ appVersion: String, with completion: @escaping ((Bool) -> Void)) {
        let call = VersionCall()
        call.versionSignal.observeValues { version in
            var result = true
            let currentVersionArray = version.components(separatedBy: ".")
            let appVersionArray = appVersion.components(separatedBy: ".")
            for i in 0..<currentVersionArray.count {
                if let currentComponent = Int(currentVersionArray[i]), let appComponent = Int(appVersionArray[i]) {
                    result = result && appComponent >= currentComponent
                }
            }
            completion(result)
        }
        call.fire()
    }
    
    static func appVersionString() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
}

//
//  AuthedFlowCoordinator.swift
//  ANLib
//
//  Created by Elliot Schrock on 11/2/20.
//

import LUX

open class AuthedFlowCoordinator: LUXAppOpenFlowController {
    open override func initialVC() -> UIViewController? {
        return UINavigationController(rootViewController: tweetsViewController())
    }
}

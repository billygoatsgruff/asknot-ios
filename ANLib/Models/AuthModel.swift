//
//  AuthModel.swift
//  ANLib
//
//  Created by Elliot Schrock on 10/30/20.
//

import Foundation

struct AuthModel: Codable {
    var accessToken: String?
    var accessTokenSecret: String?
}

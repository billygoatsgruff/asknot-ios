//
// TweetsResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation


public struct TweetsResponse: Codable { 


    public var tweets: [TweetId]?

    public init(tweets: [TweetId]? = nil) {
        self.tweets = tweets
    }

}

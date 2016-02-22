//
//  NetworkTzar.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation
import Alamofire

// The NetworkTzar class encapsulates any network requests that need to be made to the server and wraps around the Alamofire
// library

class NetworkTzar {

    // MARK: Properties

    private static let sharedInstance = NetworkTzar()
    private let manager: Manager

    // MARK: Initializer

    private init() {
        let defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        self.manager = Manager(configuration: configuration)
    }

    // MARK: Public Class Methods

    class func request(router: Router, completion: JSONResponse -> Void) -> Request {
        return NetworkTzar.sharedInstance.request(router, completion: completion)
    }

    // MARK: Private Methods

    private func request(router: Router, completion: JSONResponse -> Void) -> Request {
        let request = self.manager.request(router).validate()
        request.responseJSON(completionHandler: completion)
        return request
    }
}

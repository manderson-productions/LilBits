//
//  Router.swift
//  LilBits
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONResponse = Response<AnyObject, NSError>
typealias Request = Alamofire.Request

// The Router is used to define specific URLRequest objects for endpoints.

enum Router: URLRequestConvertible {

    // MARK: Base URL Cases

    private enum BaseURLString: String {
        case Prod = "http://streaming.earbits.com"

        func asURL() -> NSURL {
            return NSURL(string: self.rawValue)!
        }
    }

    // MARK: Router Types

    case TrackJSON

    // MARK: URLRequestConvertible

    var URLRequest: NSMutableURLRequest {
        let result: (method: Alamofire.Method, endpoint: String, parameters: [String: AnyObject], headers: [String: String]?, encoding: Alamofire.ParameterEncoding) = {

            switch self {
            case .TrackJSON:
                let method = Method.GET
                let endpoint = "/api/v1/track.json"
                let streamId = "5654d7c3c5aa6e00030021aa"
                let parameters = ["stream_id": streamId]

                return (method, endpoint, parameters, nil, .URL)
            }
        }()

        let URL = BaseURLString.Prod.asURL()
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.endpoint))
        URLRequest.HTTPMethod = result.method.rawValue

        if let headers = result.headers {
            for (key, value) in headers {
                URLRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        return result.encoding.encode(URLRequest, parameters: result.parameters).0
    }
}

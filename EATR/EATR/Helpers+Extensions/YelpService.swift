//
//  YelpService.swift
//  EATR
//
//  Created by Ian Becker on 9/8/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import Moya

private let apiKey = "EvOvmwKBWEuS2IKXdcj33_ytHRtR6Cxqox_oQXTGAX1NBQeAOHGphI4Dd_T1CsPJLOqaUK8JVMmg_kFeXyKW_mn_ttz36v9CjBChttX5SbwuNRx5VRHJ_DWNeBJYX3Yx"

enum YelpService {
    enum RestaurauntProvider: TargetType {
        case search(term: String, latitude: Double, longitude: Double)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(term, latitude, longitude):
                return .requestParameters(parameters: ["term" : term, "latitude" : latitude, "longitude" : longitude, "limit" : 10], encoding: URLEncoding.queryString)
            }
        }
        
        var headers: [String : String]? {
            return ["Authorization" : "Bearer \(apiKey)"]
        }
    }
} // End of Enum

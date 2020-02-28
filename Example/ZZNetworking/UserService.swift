//
//  UserService.swift
//  ZZNetworking_Example
//
//  Created by Chuan on 2020/2/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ZZNetworking
import Alamofire

struct AuthRes: Codable {
    var access_token: String
}

enum UserService {
    case auth(client_id: String, client_secret: String)
    case login(phone: String)
}

extension UserService: ZZService {
    var path: String {
        switch self {
        case .auth:
            return "/auth/v7/access"
        case .login:
            return "login"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .auth(let client_id, let client_secret):
            return ["client_id": client_id, "client_secret": client_secret, "grant_type": "client_credentials"]
        case .login(let phone):
            return ["phone": phone]
        }
    }
    
    var method: HTTPMethod {
        .post
    }
}

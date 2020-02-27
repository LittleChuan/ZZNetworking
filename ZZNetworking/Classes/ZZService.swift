//
//  ZZService.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/24.
//

import Alamofire

public protocol ZZService: ZZRequest {
    var params: [String: Any] { get }
    
    var method: Alamofire.HTTPMethod { get }
    
    func request() -> [String: Any]
}

public extension ZZService {
    func request() -> [String: Any] {
        switch self {
        default:
            print(self)
        }
        return params
    }
}

//
//  ZZNetConfig.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/20.
//

import UIKit

public enum ZZResponseType {
    case common // for repsonse as { code, message, data }
    case none // for data directly returned
//    case customized
}

public struct ZZResponse<T> {
    public var code: Int?
    public var message: String?
    public var data: T?
}

public struct ZZNetConfig {
    public static var debugLog = false
    public static var host = "your host"
    public static var header = [String: String]()
    public static var responseFormat = ZZResponseType.common
    public static var beforeRequest = { }
    public static var afterRequest = { }
}

func zzlog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if ZZNetConfig.debugLog {
        print(items, separator: separator, terminator: terminator)
    }
}

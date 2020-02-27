//
//  ZZNetConfig.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/20.
//

import UIKit

public struct ZZNetConfig {
    /// open debug log
    public static var debugLog = false
    /// default request URL, mark sure modify this
    public static var host = "your host"
    /// default request Header
    public static var header = [String: String]()
    /// keypath in data structure which need decode. eg. { code, message, *data* }
    public static var keyPath: String?
    /// default timeout
    public static var timeout = 15.0
    /// default retry count
    public static var retry = 0
    /// handle before request
    public static var beforeRequest: ((URLRequest) -> ())?
    /// handle request success
    public static var afterRequestSuccess: (() -> ())?
    /// handle only request failed
    public static var afterRequestFailed: ((Error) -> ())?
}

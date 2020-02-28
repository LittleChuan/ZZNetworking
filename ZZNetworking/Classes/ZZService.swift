//
//  ZZService.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/24.
//

import Alamofire
import RxSwift

public protocol ZZService: ZZRequest {
    var path: String { get }
    
    var params: [String: Any] { get }
    
    var encoding: ParameterEncoding { get }
    
    var method: Alamofire.HTTPMethod { get }
    
    func request<T: Codable>() -> Single<T>
}

public extension ZZService {
    
    var encoding: ParameterEncoding { method == .get ? URLEncoding.default : JSONEncoding.default }
    
    func request<T: Codable>() -> Single<T> {
        return zzMakeRequest(Self.host + path, method: method, parameters: params, encoding: encoding, headers: Self.extraHeader, timeout: Self.timeout)
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: Self.keyPath) }
    }
}

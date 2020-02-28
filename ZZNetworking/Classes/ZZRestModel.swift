//
//  ZZRestModel.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/20.
//

import RxSwift

public protocol ZZRestModel : Codable, ZZRequest {
    static var path: String { get }
    
    static func get(id: Int, _ params: [String: Any]?) -> Single<Self>
    
    static func get(_ params: [String: Any]?) -> Single<[Self]>
    
    func post() -> Single<Self>
    
    // TODO:
//    func put()
//    
//    func delete()
}

public extension ZZRestModel {
    static var url: String { host + path }
    // MARK: - request
    static func get(id: Int, _ params: [String: Any]? = nil) -> Single<Self> {
        return zzMakeRequest(url + "/" + String(id), parameters: params, headers: extraHeader, timeout: timeout)
            .flatMap{ zzRequest($0) }
            .flatMap{ zzDecode($0) }
    }
    
    static func get(_ params: [String: Any]? = nil) -> Single<[Self]> {
        return zzMakeRequest(url, parameters: params, headers: extraHeader, timeout: timeout)
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: keyPath) }
    }
    
    func post() -> Single<Self> {
        return zzEncode(self)
            .flatMap { zzMakeRequest(Self.url, method: .post, parameters: $0, headers: Self.extraHeader, timeout: Self.timeout) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0) }
    }
}

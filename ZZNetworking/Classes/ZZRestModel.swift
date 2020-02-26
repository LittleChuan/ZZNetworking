//
//  ZZRestModel.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/20.
//

import RxSwift

public protocol ZZRestModel : Codable {
    static var zz_path: String { get }
    static var zz_host: String? { get }
    static var zz_keyPath: String? { get }
    
    static func get(_ id: Int?) -> Single<Self>
    static func get<T: Codable>(_ params: [String: Any]?) -> Single<T>
    func post() -> Single<Self>
    
    // TODO:
//    func put()
//    func delete()
    
    static func extraHeader() -> [String: String]
    static func beforeRequest()
    static func afterRequest()
}

public extension ZZRestModel {
    static var zz_host: String? { nil }
    static var zz_keyPath: String? { ZZNetConfig.keyPath }
    static var host: String { zz_host ?? ZZNetConfig.host }
    
    // MARK: - request
    static func get(_ id: Int? = nil) -> Single<Self> {
        var url = host + zz_path
        if let id = id {
            url += String(id)
        }
        return zzMakeRequest(url)
            .flatMap{ zzRequest($0) }
            .flatMap{ zzDecode($0) }
    }
    
    static func get<T: Codable>(_ params: [String: Any]? = nil) -> Single<T> {
        return zzMakeRequest(host + zz_path, parameters: params, headers: extraHeader())
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: zz_keyPath) }
    }
    
    func post() -> Single<Self> {
        return zzEncode(self)
            .flatMap { zzMakeRequest(Self.host + Self.zz_path, method: .post, parameters: $0, headers: Self.extraHeader()) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0) }
    }
    
    // MARK: - config
    static func extraHeader() -> [String: String] {
        [String: String]()
    }
    
    static func beforeRequest() {
        
    }
    
    static func afterRequest() {
        
    }
}

public protocol ZZPageablepModel {
    func refresh()
    func loadNext()
    var page: Int { get set }
    var size: Int { get set }
}

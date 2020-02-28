//
//  ZZRestModel.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/20.
//

import Alamofire
import RxSwift

public protocol ZZRestModel : Codable, ZZRequest {
    var id: Int { get }
    
    static var path: String { get }
    
    static var encoding: ParameterEncoding { get }
    
    static func get(id: Int, _ params: Parameters?) -> Single<Self>
    
    static func get(_ params: Parameters?) -> Single<[Self]>
    
    func get<T: ZZRestModel>(_ params: Parameters?) -> Single<[T]>
    
    func post(_ params: Parameters?) -> Single<Self>
    
    func put(_ params: Parameters?) -> Single<Self>
    
    func delete(_ pramams: Parameters?) -> Single<Self>
}

public extension ZZRestModel {
    static var encoding: ParameterEncoding { JSONEncoding.default }
    
    static func get(id: Int, _ params: Parameters? = nil) -> Single<Self> {
        return zzMakeURL(host: host, path, String(id))
            .flatMap { zzMakeRequest($0, parameters: params, headers: extraHeader, timeout: timeout) }
            .flatMap{ zzRequest($0) }
            .flatMap{ zzDecode($0, keyPath: keyPath) }
    }
    
    static func get(_ params: Parameters? = nil) -> Single<[Self]> {
        return zzMakeURL(host: host, path)
            .flatMap { zzMakeRequest($0, parameters: params, headers: extraHeader, timeout: timeout) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: keyPath) }
    }
    
    func get<T: ZZRestModel>(_ params: Parameters? = nil) -> Single<[T]> {
        return zzMakeURL(host: Self.host, Self.path, String(id), T.path)
            .flatMap { zzMakeRequest($0, parameters: params, headers: T.extraHeader, timeout: T.timeout) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: Self.keyPath) }
    }
    
    func post(_ params: Parameters? = nil) -> Single<Self> {
        return Single.zip(zzMakeURL(host: Self.host, Self.path),
                          zzEncode(self))
            .flatMap { zzMakeRequest($0, method: .post, parameters: $1, encoding: Self.encoding, headers: Self.extraHeader, timeout: Self.timeout) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: Self.keyPath) }
    }
    
    func put(_ params: Parameters? = nil) -> Single<Self> {
        return Single.zip(zzMakeURL(host: Self.host, Self.path, String(id)),
                          zzEncode(self))
            .flatMap { zzMakeRequest($0, method: .put, parameters: $1, encoding: Self.encoding, headers: Self.extraHeader, timeout: Self.timeout) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: Self.keyPath) }
    }
    
    func delete(_ pramams: Parameters? = nil) -> Single<Self> {
        return Single.zip(zzMakeURL(host: Self.host, Self.path, String(id)),
                          zzEncode(self))
            .flatMap { zzMakeRequest($0, method: .delete, parameters: $1, encoding: Self.encoding, headers: Self.extraHeader, timeout: Self.timeout) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: Self.keyPath) }
    }
}

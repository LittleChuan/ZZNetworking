//
//  ZZRestModel.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/20.
//

import RxSwift

public protocol ZZRestModel : Codable {
    static var zz_host: String { get }
    static var zz_path: String { get }
    
    static func get(_ id: Int?) -> Single<Self>
    static func get<T: Codable>(_ params: [String: Any]?) -> Single<T>
    func post()
    func put()
    func delete()
    
    static func dataDecode(_ data: Data) -> Single<[Self]>
    static func extraHeader() -> [String: String]
    static func beforeRequest()
    static func afterRequest()
}

public extension ZZRestModel {
    static var zz_host: String { "" }
    static var host: String { zz_host.count == 0 ? ZZNetConfig.host : zz_host }
    
    static func get(_ id: Int? = nil) -> Single<Self> {
        var url = host + zz_path
        if let id = id {
            url += String(id)
        }
        return request(url)
            .flatMap{ serialize($0) }
    }
    
    static func get<T: Codable>(_ params: [String: Any]? = nil) -> Single<T> {
        return request(host + zz_path, parameters: params)
            .flatMap{ serialize($0) }
    }
    
    func post() {
        print("111")
    }
    
    func put() {
        print("111")
    }
    
    func delete() {
        print("111")
    }
    
    static func extraHeader() -> [String: String] {
        [String: String]()
    }
    
    static func beforeRequest() {
        
    }
    
    static func afterRequest() {
        
    }
}

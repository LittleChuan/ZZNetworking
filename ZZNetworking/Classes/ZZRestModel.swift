//
//  ZZRestModel.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/20.
//

import RxSwift
import RxCocoa

public protocol ZZRestModel : Codable {
    static var path: String { get }
    static var host: String? { get }
    static var keyPath: String? { get }
    static var retry: Int { get }
    static var timeout: TimeInterval { get }
    
    static func get(id: Int, _ params: [String: Any]?) -> Single<Self>
    static func get(_ params: [String: Any]?) -> Single<[Self]>
    func post() -> Single<Self>
    
    // TODO:
//    func put()
//    func delete()
    
    static func extraHeader() -> [String: String]
}

public extension ZZRestModel {
    static var host: String? { nil }
    static var keyPath: String? { ZZNetConfig.keyPath }
    static var retry: Int { ZZNetConfig.retry }
    static var timeout: TimeInterval { ZZNetConfig.timeout }
    static var url: String { (host ?? ZZNetConfig.host) + path }
    
    // MARK: - request
    static func get(id: Int, _ params: [String: Any]? = nil) -> Single<Self> {
        return zzMakeRequest(url + "/" + String(id), parameters: params, headers: extraHeader(), timeout: timeout)
            .flatMap{ zzRequest($0, retry: retry) }
            .flatMap{ zzDecode($0) }
    }
    
    static func get(_ params: [String: Any]? = nil) -> Single<[Self]> {
        return zzMakeRequest(url, parameters: params, headers: extraHeader(), timeout: timeout)
            .flatMap { zzRequest($0, retry: retry) }
            .flatMap { zzDecode($0, keyPath: keyPath) }
    }
    
    func post() -> Single<Self> {
        return zzEncode(self)
            .flatMap { zzMakeRequest(Self.url, method: .post, parameters: $0, headers: Self.extraHeader(), timeout: Self.timeout) }
            .flatMap { zzRequest($0, retry: Self.retry) }
            .flatMap { zzDecode($0) }
    }
    
    // MARK: - config
    static func extraHeader() -> [String: String] {
        [String: String]()
    }
}

public enum PageableStyle {
    case page
    case skip
}

public class ZZPageableModel<T: ZZRestModel> {
    /// page number
    var page: Int = 0
    static var pageKey: String { "page" }
    /// start | skip
    var skip: Int = 0
    static var skipKey: String { "skip" }
    /// count | size
    var size: Int
    static var sizeKey: String { "size" }
    var style: PageableStyle
    
    var list = BehaviorRelay<[T]>(value: [])
    var error = PublishRelay<Error>()
    
    let bag = DisposeBag()
    
    init(size: Int, style: PageableStyle = .skip) {
       self.size = size
       self.style = style
    }
    
    func refresh() {
        var param = [Self.sizeKey: size]
        page = 0
        skip = 0
        switch style {
        case .page:
            param[Self.pageKey] = page
            page += 1
        case .skip:
            param[Self.skipKey] = skip
            skip += size
        }
        
        T.get(param).subscribe({ [weak self] (res) in
            switch res {
            case .success(let model):
                self?.list.accept(model)
            case .error(let err):
                self?.error.accept(err)
            }
        }).disposed(by: bag)
    }
    
//    func loadNext() -> Single<Self> {
//
//    }
}

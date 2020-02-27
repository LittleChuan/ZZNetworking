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
    static var timeout: TimeInterval { ZZNetConfig.timeout }
    static var url: String { (host ?? ZZNetConfig.host) + path }
    
    // MARK: - request
    static func get(id: Int, _ params: [String: Any]? = nil) -> Single<Self> {
        return zzMakeRequest(url + "/" + String(id), parameters: params, headers: extraHeader(), timeout: timeout)
            .flatMap{ zzRequest($0) }
            .flatMap{ zzDecode($0) }
    }
    
    static func get(_ params: [String: Any]? = nil) -> Single<[Self]> {
        return zzMakeRequest(url, parameters: params, headers: extraHeader(), timeout: timeout)
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0, keyPath: keyPath) }
    }
    
    func post() -> Single<Self> {
        return zzEncode(self)
            .flatMap { zzMakeRequest(Self.url, method: .post, parameters: $0, headers: Self.extraHeader(), timeout: Self.timeout) }
            .flatMap { zzRequest($0) }
            .flatMap { zzDecode($0) }
    }
    
    // MARK: - config
    static func extraHeader() -> [String: String] {
        [String: String]()
    }
}

public enum PageableStyle {
    case page(sizeKey: String = "size", pageKey: String = "page")
    case skip(sizeKey: String = "size", skipKey: String = "skip")
}

public class ZZPageableModel<T: ZZRestModel> {
    /// page number
    var page: Int = 0
    /// start | skip
    var skip: Int = 0
    /// count | size
    var size: Int
    var style: PageableStyle
    
    public var list = BehaviorRelay<[T]>(value: [])
    public var error = PublishRelay<Error>()
    
    let bag = DisposeBag()
    
    public init(size: Int, style: PageableStyle = ZZNetConfig.pageableSytle) {
        self.size = size
        self.style = style
    }
    
    public func refresh(_ params: [String: Any]? = nil) {
        page = 0
        skip = 0
        T.get(makeParams(params)).subscribe { [weak self] (res) in
            switch res {
            case .success(let model):
                self?.list.accept(model)
            case .error(let err):
                self?.error.accept(err)
            }
        }
        .disposed(by: bag)
    }
    
    public func more(_ params: [String: Any]? = nil) {
        T.get(makeParams(params)).subscribe { [weak self](res) in
            switch res {
            case .success(let model):
                self?.list.accept((self?.list.value ?? []) + model)
            case .error(let err):
                self?.error.accept(err)
            }
        }
        .disposed(by: bag)
    }
    
    func makeParams(_ params: [String: Any]?) -> [String: Any] {
        var newParams = params ?? [String: Any]()
        switch style {
        case .page(let sizeKey, let pageKey):
            newParams[pageKey] = page
            newParams[sizeKey] = size
            page += 1
        case .skip(let sizeKey, let skipKey):
            newParams[skipKey] = skip
            newParams[sizeKey] = size
            skip += size
        }
        return newParams
    }
}

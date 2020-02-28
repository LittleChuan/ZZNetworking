//
//  ZZRestPager.swift
//  Alamofire
//
//  Created by Chuan on 2020/2/27.
//

import RxSwift
import RxCocoa

public enum PageableStyle {
    case page(sizeKey: String = "pagesize", pageKey: String = "page")
    case skip(sizeKey: String = "count", skipKey: String = "start")
}

public class ZZRestPager<T: ZZRestModel> {
    /// page number
    var page: Int = 1
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
        page = 1
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

//
//  ZZNetworking.swift
//  Nimble
//
//  Created by Chuan on 2020/2/20.
//

import Alamofire
import RxSwift

public class ZZNetworking {
    public static let shared = ZZNetworking()
    public var manager = SessionManager.default
}

func request(_ url: Alamofire.URLConvertible,
             method: Alamofire.HTTPMethod = .get,
             parameters: Alamofire.Parameters? = nil,
             encoding: Alamofire.ParameterEncoding = URLEncoding.default,
             headers: Alamofire.HTTPHeaders? = nil) -> Single<Data> {
    return Single<Data>.create { single in
        zzlog(url)

        let req = ZZNetworking.shared.manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData { (res) in
            switch res.result {
            case .success(let data):
                zzlog(data)
                single(.success(data))
            case .failure(let err):
                zzlog(err)
                single(.error(err))
            }
        }
        return Disposables.create {
            req.cancel()
        }
    }
}

func serialize<T: Codable>(_ data: Data) -> Single<T> {
    return Single<T>.create { single in
        do {
            let res = try JSONDecoder().decode(T.self, from: data)
            single(.success(res))
        } catch {
            single(.error(error))
        }
        return Disposables.create()
    }
}

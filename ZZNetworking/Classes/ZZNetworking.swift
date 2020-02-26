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

 func zzMakeRequest(_ url: Alamofire.URLConvertible,
                    method: Alamofire.HTTPMethod = .get,
                    parameters: Alamofire.Parameters? = nil,
                    encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                    headers: Alamofire.HTTPHeaders? = nil) -> Single<URLRequest> {
    do {
        let request = try URLRequest(url: url, method: method, headers: headers)
        let encodedURLRequest = try encoding.encode(request, with: parameters)
        return Single<URLRequest>.just(encodedURLRequest)
    } catch {
        return Single<URLRequest>.error(error)
    }
}

func zzRequest(_ request: URLRequest) -> Single<Data> {
    return Single<Data>.create { single in
        zzlog("start request:\(request)")
        if let before = ZZNetConfig.beforeRequest {
            before(request)
        }

        let req = ZZNetworking.shared.manager.request(request).responseData { (res) in
            switch res.result {
            case .success(let data):
                zzlog("request succeed, and get data: \(data)")
                if let success = ZZNetConfig.afterRequestSuccess {
                    success()
                }
                single(.success(data))
            case .failure(let err):
                zzlog("request failed, error: \(err)")
                if let failed = ZZNetConfig.afterRequestFailed {
                    failed(err)
                }
                single(.error(err))
            }
        }
        return Disposables.create {
            req.cancel()
        }
    }
}

func zzDecode<T: Codable>(_ data: Data, keyPath: String? = nil) -> Single<T> {
    return Single<T>.create { single in
        do {
            let res = try JSONDecoder().decode(T.self, from: data)
            single(.success(res))
        } catch {
            zzlog("decode  failed, error: \(error)")
            single(.error(error))
        }
        return Disposables.create()
    }
}

func zzEncode<T: Codable>(_ model: T) -> Single<Alamofire.Parameters?> {
    return Single<Alamofire.Parameters?>.create { single in
        do {
            let data = try JSONEncoder().encode(model)
            let res = try JSONSerialization.jsonObject(with: data, options: []) as? Alamofire.Parameters 
            single(.success(res))
        } catch {
            single(.error(error))
        }
        return Disposables.create()
    }
}

// MARK: - debug util
func zzlog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if ZZNetConfig.debugLog {
        print(items, separator: separator, terminator: terminator)
    }
}

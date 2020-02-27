//
//  ZZNetworking.swift
//  Nimble
//
//  Created by Chuan on 2020/2/20.
//

import Alamofire
import RxSwift

class ZZNetworking {
    
}

 func zzMakeRequest(_ url: Alamofire.URLConvertible,
                    method: Alamofire.HTTPMethod = .get,
                    parameters: Alamofire.Parameters? = nil,
                    encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                    headers: Alamofire.HTTPHeaders? = nil,
                    timeout: TimeInterval = ZZNetConfig.timeout) -> Single<URLRequest> {
    do {
        let request = try URLRequest(url: url, method: method, headers: headers)
        var encodedURLRequest = try encoding.encode(request, with: parameters)
        encodedURLRequest.timeoutInterval = timeout
        return Single<URLRequest>.just(encodedURLRequest)
    } catch {
        return Single<URLRequest>.error(error)
    }
}

func zzRequest(_ url: URLRequest) -> Single<Data> {
    return Single<Data>.create { single in
        zzlog("start request: \(url)")
        if let before = ZZNetConfig.beforeRequest {
            before(url)
        }
        let req = request(url).responseData { (res) in
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
            var keyData = data
            if let keyPath = keyPath,
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
                let object = jsonObject[keyPath] {
                keyData = try JSONSerialization.data(withJSONObject: object)
            }
            
            let res = try JSONDecoder().decode(T.self, from: keyData)
            zzlog("decode succeed, and get model: \(res)")
            single(.success(res))
        } catch {
            zzlog("decode failed, error: \(error)")
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
private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return dateFormatter
}()

func zzlog(_ log: String) {
    if ZZNetConfig.debugLog {
        print(dateFormatter.string(from: Date()) + " ZZNetworking Debug Log - " + log)
    }
}

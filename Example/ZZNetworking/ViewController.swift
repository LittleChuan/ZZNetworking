//
//  ViewController.swift
//  ZZNetworking
//
//  Created by ZackXXC on 02/20/2020.
//  Copyright (c) 2020 ZackXXC. All rights reserved.
//

import UIKit
import ZZNetworking
import RxSwift

class ViewController: UIViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ZZNetConfig.host = "https://api.douban.com"
        ZZNetConfig.debugLog = true
        
        Movie.get(["apikey":"0df993c66c0c636e29ecbb5344252a4a","start":0,"count":1]).subscribe(onSuccess: { (res) in
            print(res)
        }) { (err) in
            print(err)
        }.disposed(by: bag)
    }
    
}


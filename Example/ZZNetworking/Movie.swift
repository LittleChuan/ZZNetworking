//
//  Movie.swift
//  ZZNetworking_Example
//
//  Created by Chuan on 2020/2/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZZNetworking
import RxSwift

struct Movie: ZZRestModel {
    
//    static var zz_host = "www.baidu.com"
    static var zz_path: String { "/v2/movie/in_theaters?apikey=0df993c66c0c636e29ecbb5344252a4a&start=0&count=10" }
    
    var title: String
    var mainland_pubdate: String
}

struct Movies: ZZRestModel {
    static var zz_path: String { "/v2/movie/in_theaters?apikey=0df993c66c0c636e29ecbb5344252a4a&start=0&count=10" }
//    static var zz_path = "/v2/movie/in_theaters?apikey=0df993c66c0c636e29ecbb5344252a4a&start=0&count=10"
    
    var title: String
    var total: Int
    var subjects: [Movie]
}

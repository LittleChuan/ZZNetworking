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
    static var path: String { "/v2/movie/in_theaters" }
    static var keyPath: String? { "subjects" }
    
    var title: String
    var mainland_pubdate: String
}

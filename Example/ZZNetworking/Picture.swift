//
//  Picture.swift
//  ZZNetworking_Example
//
//  Created by Chuan on 2020/2/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ZZNetworking

struct Picture: ZZRestModel {
    static var path: String { "/v2/acgclub/pictures" }
    
    var title: String
    var thumbnail: String
}


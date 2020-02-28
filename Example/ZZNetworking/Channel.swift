//
//  Media.swift
//  ZZNetworking_Example
//
//  Created by Chuan on 2020/2/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ZZNetworking

struct Channel: ZZRestModel {
    var id: Int
    
    static var servicePath: String { "media/v7" }
    static var path: String { "channelondemands" }
    
    var title: String
    var description: String
}

struct Program: ZZRestModel {
    var id: Int
    
    static var servicePath: String { "media/v7" }
    static var path: String { "programs" }
    
    var title: String
}

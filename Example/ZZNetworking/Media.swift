//
//  Media.swift
//  ZZNetworking_Example
//
//  Created by Chuan on 2020/2/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ZZNetworking

struct Media: ZZRestModel {
    static var path: String { "/media/v7/channellives" }
    
    var title: String
    var description: String
}

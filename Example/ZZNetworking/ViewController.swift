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

    @IBOutlet weak var table: UITableView!
    let bag = DisposeBag()
    let movies = ZZPageableModel<Movie>(size: 1, style: .skip(sizeKey: "count", skipKey: "start"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put this in you appDelegate
        ZZNetConfig.host = "https://api.douban.com"
        ZZNetConfig.debugLog = true
        
        // register cell
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // bind data
        movies.list.bind(to: table.rx
            .items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, text, cell) in
                cell.textLabel?.text = text.title
            }
            .disposed(by: bag)
        // and done
    }
    
    func testRestModel() {
        Movie.get(["apikey":"0df993c66c0c636e29ecbb5344252a4a","start":0,"count":1]).subscribe(onSuccess: { (res) in
            print(res)
        }).disposed(by: bag)
    }
    
    @IBAction func refresh(_ sender: Any) {
        movies.refresh(["apikey":"0df993c66c0c636e29ecbb5344252a4a"])
    }
    
    @IBAction func more(_ sender: Any) {
        movies.more(["apikey":"0df993c66c0c636e29ecbb5344252a4a"])
    }
}

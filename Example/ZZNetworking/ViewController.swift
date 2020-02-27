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
    let movies = ZZRestPager<Picture>(size: 20, style: .page(sizeKey: "limit", pageKey: "offset"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put this in you appDelegate
        ZZNetConfig.host = "https://rabtman.com/api"
        ZZNetConfig.keyPath = "data"
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
        
        print(UserService.auth(client_id: "", client_secret: "").request())
    }
    
    func testRestModel() {
        Picture.get().subscribe(onSuccess: { (res) in
            print(res)
        }).disposed(by: bag)
    }
    
    @IBAction func refresh(_ sender: Any) {
        movies.refresh()
    }
    
    @IBAction func more(_ sender: Any) {
        movies.more()
    }
}

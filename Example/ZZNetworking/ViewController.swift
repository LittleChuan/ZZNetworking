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
    let lives = ZZRestPager<Live>(size: 30, style: .page(sizeKey: "pagesize"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put this in you appDelegate
        ZZNetConfig.host = "https://open.staging.qingting.fm"
        ZZNetConfig.keyPath = "data"
        ZZNetConfig.debugLog = true
        
        // register cell
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // bind data
        lives.list.bind(to: table.rx
            .items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, text, cell) in
                cell.textLabel?.text = text.title
            }
            .disposed(by: bag)
        // and done
        
        UserService.auth(client_id: "**", client_secret: "**").request().subscribe(onSuccess: { (auth: AuthRes) in
            ZZNetConfig.header = ["QT-Access-Token": auth.access_token]
        }).disposed(by: bag)
    }
    
    
    func testRestModel() {
        Live.get().subscribe(onSuccess: { (res) in
            print(res)
        }).disposed(by: bag)
    }
    
    @IBAction func refresh(_ sender: Any) {
        medias.refresh()
    }
    
    @IBAction func more(_ sender: Any) {
        medias.more()
    }
}

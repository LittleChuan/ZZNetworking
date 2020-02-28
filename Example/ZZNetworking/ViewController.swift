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
    let channels = ZZRestPager<Channel>(size: 30, style: .page())
    
    static let authTokenKey = "authTokenKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put this in you appDelegate
        ZZNetConfig.host = "https://open.staging.qingting.fm"
        ZZNetConfig.keyPath = "data"
        ZZNetConfig.debugLog = true
        
        // register cell
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // bind data
        channels.list.bind(to: table.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, text, cell) in
                cell.textLabel?.text = text.title
        } .disposed(by: bag)
        // and done
                
        table.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self else { return }
            self.showPragrams(self.channels.list.value[indexPath.row])
        }).disposed(by: bag)
        
        if let token = UserDefaults.standard.string(forKey: ViewController.authTokenKey) {
            ZZNetConfig.header = ["QT-Access-Token": token]
        } else {
            UserService.auth(client_id: "x", client_secret: "x").request().subscribe(onSuccess: { (auth: AuthRes) in
                UserDefaults.standard.set(auth.access_token, forKey: ViewController.authTokenKey)
                ZZNetConfig.header = ["QT-Access-Token": auth.access_token]
            }).disposed(by: bag)
        }
    }
    
    func showPragrams(_ channel: Channel) {
        channel.get().subscribe(onSuccess: { (pragrams: [Program]) in
            let alert = UIAlertController(title: "Pragrams", message: "\(pragrams)", preferredStyle: .alert)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }).disposed(by: bag)
    }
    
    func testRestModel() {
        Channel.get().subscribe(onSuccess: { (res) in
            print(res)
        }).disposed(by: bag)
    }
    
    @IBAction func refresh(_ sender: Any) {
        channels.refresh()
    }
    
    @IBAction func more(_ sender: Any) {
        channels.more()
    }
}

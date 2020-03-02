//
//  ProgramController.swift
//  ZZNetworking_Example
//
//  Created by Chuan on 2020/3/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZZNetworking
import RxSwift

class ProgramController: UIViewController {
    
    var programs: ZZRestPager<Program>?
    
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let programs = programs {
            let table = UITableView(frame: UIScreen.main.bounds)
            table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            view.addSubview(table)
            
            programs.list.bind(to: table.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, text, cell) in
                cell.textLabel?.text = text.title
            } .disposed(by: bag)
            
            programs.refresh()
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

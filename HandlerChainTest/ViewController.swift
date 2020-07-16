//
//  ViewController.swift
//  HandlerChainTest
//
//  Created by weng on 2020/7/15.
//  Copyright © 2020 xxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        appendToChain()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SecondViewController")
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    deinit {
        removeFromChain()
        print("\(self) deinit")
    }
}

extension ViewController: MTEHandlerChain {
    func handle(url: String, error: Error) -> Bool {
        if url.contains("report/show"), let error = error as? DemoError {
            print("ViewController 处理了\(url), error:\(error)")
            return true
       }
       return false
    }
}


//
//  SecondViewController.swift
//  HandlerChainTest
//
//  Created by weng on 2020/7/15.
//  Copyright © 2020 xxx. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appendToChain()
        view.backgroundColor = .red
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            print("主动释放ViewController")
            self.navigationController?.viewControllers = [self]
        }
    }
    
    deinit {
        print("\(self) deinit")
        removeFromChain()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        RequestMocker().mockRequestFail()
    }
}

extension SecondViewController: MTEHandlerChain {
    func handle(url: String, error: Error) -> Bool{
        if url.contains("user/login"), let error = error as? DemoError {
            print("SecondViewController 处理了\(url), error:\(error)")
            return true
        }
        return false
     }
}

enum DemoError: Error {
    case decodeFail
    case timeout
    case invalidToken
}

class RequestMocker: NSObject, MTEHandlerChain {
    func mockRequestFail() {
        self.delivery(with: "http://mock.com/report/show", error: DemoError.decodeFail)
        self.delivery(with: "http://mock.com/user/login", error: DemoError.invalidToken)
        self.delivery(with: "http://mock.com/report/show", error: DemoError.invalidToken)
    }
}

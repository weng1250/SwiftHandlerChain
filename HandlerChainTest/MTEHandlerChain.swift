//
//  MTEHandlerChain.swift
//  HandlerChainTest
//
//  Created by weng on 2020/7/15.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

protocol MTEHandlerChain: class {
    func appendToChain()
    func removeFromChain()
    func delivery(with url: String, error: Error)
    func handle(url: String, error: Error) -> Bool
    func isEqualTo(_ other: MTEHandlerChain) -> Bool
    // convenience
    func printAllHandler()
}

extension MTEHandlerChain where Self: Equatable {
    func appendToChain() {
        MTEHandlerChainManager.shared.append(self)
    }
    
    func removeFromChain() {
        MTEHandlerChainManager.shared.remove(self)
    }
    
    func delivery(with url: String, error: Error) {
        MTEHandlerChainManager.shared.delivery(with: url, error: error)
    }
    
    func handle(url: String, error: Error) -> Bool {
        assertionFailure("\(self)的handle方法未实现!")
        return false
    }
    
    func isEqualTo(_ other: MTEHandlerChain) -> Bool {
        guard let it = other as? Self else { return false }
        return self == it
    }
    
    func printAllHandler() {
        MTEHandlerChainManager.shared.printAllHandler()
    }
}

fileprivate
final class MTEHandlerChainManager {
    static let shared = MTEHandlerChainManager()
    
    /// 追加handler到响应链接
    /// - Parameter handler: handler description
    /// - Returns: MTEHandlerChainManager，便于链式编程
    @discardableResult
    func append(_ handler: MTEHandlerChain) -> MTEHandlerChainManager {
        guard weakHandlerList.indexOf(handler as AnyObject) == nil else { return self }
        weakHandlerList.addObject(handler as AnyObject)
        return self
    }
    
    @discardableResult
    func remove(_ handler: MTEHandlerChain) -> MTEHandlerChainManager {
        weakHandlerList.removeObject(handler as AnyObject)
        return self
    }
    
    /// 开始传递错误
    /// - Parameters:
    ///   - url: url description
    ///   - error: error description
    func delivery(with url: String, error: Error) {
        for handler in weakHandlerList.allObjects {
            guard let handler = handler as? MTEHandlerChain else { continue }
            if handler.handle(url: url, error: error) {
                break
            }
        }
    }
    
    func printAllHandler() {
        print("All handlers:")
        for handler in weakHandlerList.allObjects {
            print(handler)
        }
        print("\n")
     }
    
    private var weakHandlerList = NSPointerArray.weakObjects()
}


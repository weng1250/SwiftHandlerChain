//
//  NSPointerArray+.swift
//  HandlerChainTest
//
//  Created by weng on 2020/7/15.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

extension NSPointerArray {
    
    // 增
    func addObject(_ object: AnyObject?) {
        guard let strongObject = object else { return }

        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
 
    func insertObject(_ object: AnyObject?, at index: Int) {
        guard index < count, let strongObject = object else { return }
 
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
    
    // 删
    func removeObject(at index: Int) {
        guard index < count else { return }
        removePointer(at: index)
    }
    
    func removeObject(_ object: AnyObject?) {
        guard let index = indexOf(object), index >= 0 else { return }
        removeObject(at: index)
    }
    
    // 改
 
    func replaceObject(at index: Int, withObject object: AnyObject?) {
        guard index < count, let strongObject = object else { return }
 
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
 
    // 查
    func object(at index: Int) -> AnyObject? {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
    
    func indexOf(_ object: AnyObject?) -> Int? {
        guard let strongObject = object, self.count > 0 else { return nil }
        let targetPointer = Unmanaged.passUnretained(strongObject).toOpaque()
        for index in 0..<self.count {
            guard let pointer = self.pointer(at: index) else { continue }
            if targetPointer == pointer {
                return index
            }
        }
        return nil
    }
}

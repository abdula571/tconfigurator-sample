//
//  Configured.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import Foundation

public protocol Configured { }

public extension Configured {
    
    @discardableResult
    func configured(_ configurator: (_ it: Self) -> Void) -> Self {
        configurator(self)
        return self
    }
    
    func convert<T>(_ converter: (_ it: Self) -> T) -> T {
        return converter(self)
    }
}

extension NSObject: Configured {}

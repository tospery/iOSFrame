//
//  Library.swift
//  iOSFrame
//
//  Created by 杨建祥 on 2020/4/27.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import SwiftyBeaver

public let log = SwiftyBeaver.self

open class Library {
    
    open class func setup() {
        self.setupReachability()
        self.setupSwiftyBeaver()
    }
    
    open class func setupReachability() {
        ReachabilityManager.shared.start()
    }

    open class func setupSwiftyBeaver() {
        let console = ConsoleDestination.init()
        console.format = "$DHH:mm:ss.SSS$d $T $C$L$c $N.$F:$l - $M"
        log.addDestination(console)
        log.addDestination(FileDestination.init())
    }
    
}


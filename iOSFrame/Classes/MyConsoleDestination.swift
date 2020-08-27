//
//  ConsoleDestination.swift
//  iOSFrame
//
//  Created by liaoya on 2020/8/27.
//

import os
import UIKit
import SwiftyBeaver

public class MyConsoleDestination: BaseDestination {

    /// use NSLog instead of print, default is false
    public var useNSLog = false
    /// uses colors compatible to Terminal instead of Xcode, default is false
    public var useTerminalColors: Bool = false {
        didSet {
            if useTerminalColors {
                // use Terminal colors
                levelColor.verbose = "251m"     // silver
                levelColor.debug = "35m"        // green
                levelColor.info = "38m"         // blue
                levelColor.warning = "178m"     // yellow
                levelColor.error = "197m"       // red

            } else {
                // use colored Emojis for better visual distinction
                // of log level for Xcode 8
                levelColor.verbose = "💜 "     // silver
                levelColor.debug = "💚 "        // green
                levelColor.info = "💙 "         // blue
                levelColor.warning = "💛 "     // yellow
                levelColor.error = "❤️ "       // red

            }
        }
    }

    override public var defaultHashValue: Int { return 1 }

    public override init() {
        super.init()
        levelColor.verbose = "💜 "     // silver
        levelColor.debug = "💚 "        // green
        levelColor.info = "💙 "         // blue
        levelColor.warning = "💛 "     // yellow
        levelColor.error = "❤️ "       // red
    }

    // print to Xcode Console. uses full base class functionality
    override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String,
                                file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)

        if let str = formattedString {
            let message = "【\(UIApplication.shared.bundleIdentifier)】\(str)"
            if #available(iOS 10.0, *) {
                os_log("%{public}s", message)
            } else {
                NSLog("%@", message)
            }
        }
        return formattedString
    }

}


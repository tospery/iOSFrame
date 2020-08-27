//
//  ListType.swift
//  iOSFrame
//
//  Created by 杨建祥 on 2020/4/14.
//

import UIKit
import ObjectMapper

//public protocol ListType {
//    associatedtype Item: ModelType
//    var hasNext: Bool { get }
//    var count: Int { get }
//    var items: [Item] { get }
//    var json: [String: Any] { get }
//}
//
//public struct List<Item: ModelType>: ModelType, ListType {
//    public var hasNext = false
//    public var count = 0
//    public var items: [Item]
//}

public struct List<Item: ModelType>: ModelType {

    public var hasNext = false
    public var count = 0
    public var items = [Item].init()

    public init() {
    }

    public init?(map: Map) {
    }

    mutating public func mapping(map: Map) {
        hasNext     <- map["has_next"]
        count       <- map["count"]
        items       <- map["items"]
//        if items == nil {
//            items       <- map["objects"]
//        }
//        if items == nil {
//            items       <- map["messages"]
//        }
    }

}


public protocol ListCompatible {
    associatedtype Item: ModelType
    func hasNext(map: Map) -> Bool
    func count(map: Map) -> Int
    func items(map: Map) -> [Item]
}


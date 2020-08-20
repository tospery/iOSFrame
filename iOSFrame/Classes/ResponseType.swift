//
//  ResponseType.swift
//  iOSFrame
//
//  Created by 杨建祥 on 2020/8/19.
//

import UIKit
import RxSwift
import Moya
import Alamofire
import ObjectMapper

public let successCode = 200

public protocol ResponseType {
    var code: Int { get }
    var message: String { get }
    var data: Any? { get }
}

public protocol ResponseMapping {
    func mappingCode(map: Map) -> Int
    func mappingMessage(map: Map) -> String
    func mappingData(map: Map) -> Any?
}

public struct BaseResponse: ResponseType, ModelType {
    public var code = 0
    public var message = ""
    public var data: Any?
    
    public init() {
    }
    
    public init?(map: Map) {
    }

    mutating public func mapping(map: Map) {
        if let mapping = self as? ResponseMapping {
            code = mapping.mappingCode(map: map)
            message = mapping.mappingMessage(map: map)
            data = mapping.mappingData(map: map)
        } else {
            code        <- map["code"]
            message     <- map["message"]
            data        <- map["data"]
        }
    }
    
}

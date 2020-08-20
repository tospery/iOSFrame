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
    
    func mappingCode(map: Map) -> Int
    func mappingMessage(map: Map) -> String
    func mappingData(map: Map) -> Any?
}

extension ResponseType {
    public func mappingCode(map: Map) -> Int {
        var code: Int?
        code        <- map["code"]
        return code ?? 0
    }
    
    public func mappingMessage(map: Map) -> String {
        var message: String?
        message     <- map["message"]
        return message ?? ""
    }
    
    public func mappingData(map: Map) -> Any? {
        var data: Any?
        data        <- map["data"]
        return data
    }
}

public struct BaseResponse: ModelType {
    public var code = 0
    public var message = ""
    public var data: Any?
    
    public init() {
    }
    
    public init?(map: Map) {
    }

    mutating public func mapping(map: Map) {
        if let responseType = self as? ResponseType {
            code = responseType.mappingCode(map: map)
            message = responseType.mappingMessage(map: map)
            data = responseType.mappingData(map: map)
        }
    }
    
}

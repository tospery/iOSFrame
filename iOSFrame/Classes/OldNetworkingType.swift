//
//  OldNetworkingType.swift
//  iOSFrame
//
//  Created by 杨建祥 on 2020/4/9.
//

import UIKit
import RxSwift
import Moya
import Alamofire
import ObjectMapper

public protocol OldNetworkingType {
    associatedtype T: TargetType
    var provider: NetworkProvider<T> { get }
}

public extension OldNetworkingType {
    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint where T: TargetType {
        return { target in
            let endpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return endpoint
        }
    }
    
    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never
    }
    
    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        #if DEBUG
        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = [.requestBody, .successResponseBody, .errorResponseBody]
        plugins.append(logger)
//        let activity = NetworkActivityPlugin.init { (activityChangeType, targetType) in
//            log.debug("\(targetType.path): \(activityChangeType)")
//        }
//        plugins.append(activity)
        #endif
        return plugins
    }
    
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = true
                request.timeoutInterval = 15 // Constant.Network.timeout
                closure(.success(request))
            } catch {
                log.error(error.localizedDescription)
            }
        }
    }
}

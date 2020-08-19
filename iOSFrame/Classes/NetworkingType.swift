//
//  NetworkingType.swift
//  iOSFrame
//
//  Created by 杨建祥 on 2020/8/19.
//

import UIKit
import RxSwift
import Moya
import Alamofire
import ObjectMapper

public protocol NetworkingType {
    associatedtype Target: TargetType
    var provider: MoyaProvider<Target> { get }
}

public extension NetworkingType {
    static var endpointClosure: MoyaProvider<Target>.EndpointClosure {
        return { target in
            return MoyaProvider.defaultEndpointMapping(for: target)
        }
    }
    
    static var requestClosure: MoyaProvider<Target>.RequestClosure {
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
    
    static var stubClosure: MoyaProvider<Target>.StubClosure {
        return { _ in
            return .never
        }
    }

    static var callbackQueue: DispatchQueue? {
        return nil
    }
        
    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        #if DEBUG
        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = [.requestBody, .successResponseBody, .errorResponseBody]
        plugins.append(logger)
        #endif
        return plugins
    }
    
    static var trackInflights: Bool {
        return false
    }
    
}

public extension NetworkingType {
    func request(_ target: Target) -> Single<Response> {
        return self.provider.rx.request(target)
    }
    
    func requestRaw(_ target: Target) -> Single<Response> {
        return self.request(target)
            .observeOn(MainScheduler.instance)
    }
    
    func requestJSON(_ target: Target) -> Single<Any> {
        return self.request(target)
            .mapJSON()
            .observeOn(MainScheduler.instance)
    }
    
    func requestObject<Model: ModelType>(_ target: Target, type: Model.Type) -> Single<Model> {
        return self.request(target)
            .mapObject(Model.self)
            .observeOn(MainScheduler.instance)
    }
    
    func requestArray<Model: ModelType>(_ target: Target, type: Model.Type) -> Single<[Model]> {
        return self.request(target)
            .mapArray(Model.self)
            .observeOn(MainScheduler.instance)
    }
    
    func requestData(_ target: Target) -> Single<Any?> {
        return self.request(target)
            .mapObject(BaseResponse.self)
            .flatMap { response -> Single<Any?> in
                guard response.code == successCode else {
                    return .error(SFError.server(response.message))
                }
                return .just(response.data)
        }
        .observeOn(MainScheduler.instance)
    }
    
    func requestModel<Model: ModelType>(_ target: Target, type: Model.Type) -> Single<Model> {
        return self.request(target)
            .mapObject(BaseResponse.self)
            .flatMap { response -> Single<Model> in
                guard response.code == successCode,
                    let json = response.data as? [String: Any],
                    let model = Model.init(JSON: json) else {
                        return .error(SFError.server(response.message))
                }
                return .just(model)
        }
        .observeOn(MainScheduler.instance)
    }
    
    func requestModels<Model: ModelType>(_ target: Target, type: Model.Type) -> Single<[Model]> {
        return self.request(target)
            .mapObject(BaseResponse.self)
            .flatMap { response -> Single<[Model]> in
                guard response.code == successCode else {
                    return .error(SFError.server(response.message))
                }
                let jsonArray = response.data as? [[String : Any]] ?? []
                let models = [Model].init(JSONArray: jsonArray)
                return .just(models)
        }
        .observeOn(MainScheduler.instance)
    }
    
    func requestList<Model: ModelType>(_ target: Target, type: Model.Type) -> Single<List<Model>> {
        return self.request(target)
            .mapObject(BaseResponse.self)
            .flatMap { response -> Single<List<Model>> in
                guard response.code == successCode,
                    let json = response.data as? [String: Any],
                    let list = List<Model>.init(JSON: json) else {
                        return .error(SFError.server(response.message))
                }
                return .just(list)
        }
        .observeOn(MainScheduler.instance)
    }
}
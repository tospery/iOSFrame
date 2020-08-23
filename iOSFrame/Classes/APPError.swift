//
//  XYError.swift
//  iOSFrame
//
//  Created by 杨建祥 on 2020/4/11.
//

import UIKit
import RxSwift
import Moya

public enum APPError: Error {
    case network
    case expired
    case server(Int, String?)
    case illegal(Int, String?)
}

extension APPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network:
            return NSLocalizedString("Error.Network.Message", comment: "")
        case .expired:
            return NSLocalizedString("Error.Expired.Message", comment: "")
        case let .server(_, message):
            return message ?? NSLocalizedString("Error.Server.Title", comment: "")
        case let .illegal(_, message):
            return message ?? NSLocalizedString("Error.Illegal.Title", comment: "")
        }
    }
}

extension APPError: Equatable {
    public static func == (lhs: APPError, rhs: APPError) -> Bool {
        switch (lhs, rhs) {
        case (.network, .network), (.expired, .expired):
            return true
        case let (.server(code1, message1), .server(code2, message2)):
            return code1 == code2 && message1 == message2
        case let (.illegal(code1, message1), .illegal(code2, message2)):
            return code1 == code2 && message1 == message2
        default:
            return false
        }
    }
}

public extension Error {
    var isNetwork: Bool {
        if (self as NSError).domain == NSURLErrorDomain {
            return true
        }
        if let error = self as? APPError, error == .network {
            return true
        }
        return false
    }

    var isServer: Bool {
        if (self as NSError).code == 500 {
            return true
        }
        if let error = self as? APPError {
            switch error {
            case .server:
                return true
            default:
                return false
            }
        }
        return false
    }

    var isExpired: Bool {
        if (self as NSError).code == 401 {
            return true
        }
        if let error = self as? APPError, error == .expired {
            return true
        }
        return false
    }

    var isIllegal: Bool {
        if let error = self as? APPError {
            switch error {
            case .illegal:
                return true
            default:
                return false
            }
        }
        return false
    }

    var title: String? {
        if self.isNetwork {
            return NSLocalizedString("Error.Network.Title", comment: "")
        } else if self.isServer {
            return NSLocalizedString("Error.Server.Title", comment: "")
        } else if self.isExpired {
            return NSLocalizedString("Error.Expired.Title", comment: "")
        }
        return nil
    }

    var message: String {
        if self.isNetwork {
            return NSLocalizedString("Error.Network.Message", comment: "")
        } else if self.isServer {
            return NSLocalizedString("Error.Server.Message", comment: "")
        } else if self.isExpired {
            return NSLocalizedString("Error.Expired.Message", comment: "")
        }
        return self.localizedDescription
    }

    var retry: String? {
        return NSLocalizedString("Error.Retry", comment: "")
    }

    var image: UIImage? {
        if self.isNetwork {
            return UIImage.networkError
        } else if self.isServer {
            return UIImage.serverError
        } else if self.isExpired {
            return UIImage.expireError
        }
        return nil
    }
}

//public enum AppError: Error {
//    case network
//    case server
//    case empty
//    case expire
//    case timeout
//    case underlying(Error)
//
//    public struct Code {
//        public static let Success   = 200
//        public static let Expire    = 401
//    }
//
//    public var image: UIImage {
//        switch self {
//        case .network:
//            return .networkError
//        case .server:
//            return .serverError
//        case .empty:
//            return .emptyError
//        case .expire:
//            return .expireError
//        case .timeout:
//            return .expireError
//        case .underlying:
//            return .serverError
//        }
//    }
//
//    public var title: String {
//        switch self {
//        case .network:
//            return NSLocalizedString("Error.Network.Title", comment: "")
//        case .server:
//            return NSLocalizedString("Error.Server.Title", comment: "")
//        case .empty:
//            return NSLocalizedString("Error.Empty.Title", comment: "")
//        case .expire:
//            return NSLocalizedString("Error.Expire.Title", comment: "")
//        case .timeout:
//            return NSLocalizedString("Error.Expire.Title", comment: "")
//        case .underlying:
//            return NSLocalizedString("Error.Server.Title", comment: "")
//        }
//    }
//
//    public var message: String {
//        switch self {
//        case .network:
//            return NSLocalizedString("Error.Network.Message", comment: "")
//        case .server:
//            return NSLocalizedString("Error.Server.Message", comment: "")
//        case .empty:
//            return NSLocalizedString("Error.Empty.Message", comment: "")
//        case .timeout:
//            return NSLocalizedString("Error.Expire.Message", comment: "")
//        case .expire:
//            return NSLocalizedString("Error.Expire.Message", comment: "")
//        case .underlying(let error):
//            return error.localizedDescription
//        }
//    }
//
//    public var retryTitle: String {
//        return NSLocalizedString("Error.Retry", comment: "")
//    }
//
//}
//
//public extension Error {
//
//    public var asAppError: AppError {
//        if let appError = self as? AppError {
//            return appError
//        }
//
//        if let error = self as? RxError {
//            switch error {
//            case .timeout:
//                return .timeout
//            default:
//                return .underlying(self)
//            }
//        }
//
//        if let error = self as? MoyaError {
//            switch error {
//            case let .underlying(error, response):
//                if (error as NSError).isNetwork {
//                    return .network
//                } else if (error as NSError).isExpire {
//                    return .expire
//                }
//                return .server
//            default:
//                return .server
//            }
//        }
//
//        return .underlying(self)
//    }
//}

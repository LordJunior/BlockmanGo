//
//  NetServer.swift
//  BlockyModes
//
//  Created by KiBen on 2017/10/21.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

import UIKit
import Moya
import Result

typealias RequestJsonCallBack = (BlockHTTPResult<[String : Any], BlockHTTPError>) -> Void



// MARK: Plugin
class RequestLoadingPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        var URLString = target.baseURL.absoluteString
        URLString.append(target.path)
        
        var parameters: [String : Any] = [:]
        switch target.task {
        case let .requestParameters(parameters: param, encoding: _):
            parameters += param
        default:
            break
        }
        
        guard let headers = target.headers else { return DebugLog("request ################\n URL: \(URLString) \n param: \(parameters) \n without header \n\n")}
        
        DebugLog("request start ################\n URL: \(URLString) \n param: \(parameters) \n header: \(headers) \n\n")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        var responseDict: [String : Any] = [:]
        
        switch result {
        case let .success(response):
            do {
                responseDict = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as! [String : Any]
            }catch let error as NSError {
                DebugLog("responseData 解析失败, \(error.description)")
            }
            
        default:
            break
        }
        DebugLog("response did ################\n  \(responseDict)")
    }
}

// MARK: Requester
class Requester {

    private static let provider = MoyaProvider<MultiTarget>(plugins: [RequestLoadingPlugin()])
    
    class func requestWithTarget(_ target: TargetType, showToast: Bool = false, completion: @escaping RequestJsonCallBack) {
//        if showToast {
//            BlockyHUD.showLoading(inView: AppDelegate.currentNavigationController().topViewController?.view ?? AppDelegate.keyWindow())
//        }
        provider.request(MultiTarget(target)) { (result) in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    do {
                        guard let json = try response.mapJSON() as? [String : Any] else {
                            completion(.failure(.parseResponseFailed))
                            DebugLog("解析json失败")
                            return
                        }
                        
                        guard let code = json["code"] as? Int else {
                            completion(.success(json))
                            return
                        }
                        guard code == 1 else {
                            completion(.failure(BlockHTTPError(rawValue: code) ?? .unknown))
                            return
                        }
                        completion(.success(json))
                    }catch {
                        completion(.failure(.parseResponseFailed))
                        DebugLog("解析json失败")
                    }
                    return
                }
                completion(.failure(BlockHTTPError(rawValue: response.statusCode) ?? .unknown))
            case .failure(_):
                completion(.failure(.unknown))
            }
        }
    }
}






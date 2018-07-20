//
//  JsonMapper.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation
import HandyJSON

extension Dictionary where Key == String {
    func mapModel<T: HandyJSON>(_ modelType: T.Type) throws -> T  {
        guard let model = T.deserialize(from: self, designatedPath: "data") else {
            throw BlockHTTPError.jsonMapToModelFailed
        }
        return model
    }
    
    func mapModelArray<T: HandyJSON>(_ modelType: T.Type) throws -> [T] {
        guard let jsonArray = self["data"] as? [[String : Any]] else {
            return []
        }
        guard let models = [T].deserialize(from: jsonArray) as? [T] else {
            throw BlockHTTPError.jsonMapToModelFailed
        }
        return models
    }
}

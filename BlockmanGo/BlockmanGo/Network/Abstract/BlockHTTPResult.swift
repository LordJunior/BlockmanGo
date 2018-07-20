//
//  BlockHTTPResponse.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

// MARK: BlockyResult<Void>
enum BlockHTTPResult<Value, BlockHTTPError> {
    case success(Value)
    case failure(BlockHTTPError)
}


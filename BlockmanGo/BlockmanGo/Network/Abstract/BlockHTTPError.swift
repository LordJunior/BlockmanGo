//
//  BlockHTTPCode.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/11.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

// MARK: Error
enum BlockHTTPError: Int, Swift.Error {
    
    // Auth
    case userNotBindDevice = 1004 // 用户没有绑定任何设备
    
    case accountSameAsUserID = 1005 // userId 和 用户账号 存在相等的情况，有冲突
    
    case passwordNotSet = 1006 // 没有设置密码
    
    case thirdPartAccountAlreadyBindUser = 1007 // 第三方账号已经绑定了其他user
    
    // User
    case nicknameInvalid = 3
    case noPermission = 7
    case nicknameExist = 1003
    case accountExist = 101
    case accountNotExist = 102
    case phoneHasBinded = 103
    case phoneNotBind = 104
    case smsSendFailed = 105
    case hasBindedPhone = 106
    case captchaError = 107
    case passwordError = 108
    case emailPatternError = 111
    case emailNotValid = 112
    case emailHasBeenBind = 113
    case userHasBindEmail = 114
    case userNotBindEmail = 115
    case emailNotBindToUser = 116
    case profileNotExist = 1002
    
    // Game
    case enterGameInQueue = 2 // 因为服务器返回的错误码重复冲突了
    case gameNotExist = 2002
    case alreadyAppreciated = 2005
    case withoutPlayGame = 2008
    case gameversionTooLow = 2009
    
    // Friend
    case maxFriendCountLimit = 3002
    case notFriendship = 3003
    
    // Decoration
    case systemNoDecoration = 4003 //系统不存在该装饰信息
    case userNoDecoration = 4005 // 用户没有该装饰信息
    case notUseDecorationInLowVIP = 6001 // 用户VIP等级不足, 无法使用
    
    // Decoration Shop
    case productNotExist = 5002 // 没有此商品
    case productSellOut = 5004 //商品卖完
    case balanceNotEnough = 5006 //余额不足
    case goldsOrDiamondsNotEnough = 5007 //金币不足
    
    // Pay
    case transactionHasVerified = 5003 // 订单已处理
    
    // DailyTask
    case hasSignedIn = 6002 // 已签到
    
    // Tribe
    case hasBeenInTribe = 7001 // 已加入部落
    case tribeNameExists = 7002 // 部落名称已存在
    case notChiefInTribe = 7003 // 不是该部落酋长
    case notElderInTribe = 7004 // 不是该部落长老
    case tribeMemberCountLimit = 7005 // 部落人员已满
    case notInTribe = 7006 // 未加入部落
    case tribeLevelNotEnough = 7008 // 部落级别太低
    case tribeElderCountLimit = 7010 // 长老人数已满
    case tribeDonateLimit = 7011 // 超过捐献最大数
    case tribeJoinedCountInDayLimit = 7015 // 今日加入部落的人数已达上限
    case tribeTaskRewardCountInDayLimit = 7016 // 今日领取任务奖励的数量已达上限
    case tribeTaskCanNotRefreshUntilDone = 7017 // 无法刷新，请先完成任务
    
    // HTTP
    case parametersError = 400
    case unauthorized = 401
    case serverNotFound = 404
    case requestMethodError = 405
    case serverInnerError = 500
    
    case unknown = -1
    case parseResponseFailed = -2
    case jsonMapToModelFailed = -3
}

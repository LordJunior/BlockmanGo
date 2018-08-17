//
//  AnalysisManager.swift
//  BlockyModes
//
//  Created by KiBen on 2018/1/22.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

import Foundation

struct AnalysisService {
    
    enum Event: String {
        case enter_loginpage = "enter_loginpage"
        case third_facebook = "third_facebook"
        case third_facebook_suc = "third_facebook_suc"
        case click_login = "click_login"
        case loginpage_reg = "loginpage_reg"
        case regpage_login = "regpage_login"
        case account_login_suc = "account_login_suc"
        case login_failed = "login_failed"
        case reg_failed = "reg_failed"
        case enter_useroage = "enter_useroage"
        case useroage_suc = "useroage_suc"
        case useroage_failed = "useroage_failed"
        case home_startapp = "home_startapp"
        case home_view = "home_view"
        case home_class = "home_class"
        case home_reco = "home_reco"
        case home_change = "home_change"
        case home_game = "home_game"
        case home_game_tab = "home_game_tab"
        case home_dress_tab = "home_dress_tab"
        case home_chat_tab = "home_chat_tab"
        case home_more_tab = "home_more_tab"
        case home_recegames = "home_recegames"
        case home_frigames = "home_frigames"
        case home_recogames = "home_recogames"
        case home_classgames = "home_classgames"
        case home_update = "home_update"
        case home_cancel = "home_cancel"
        case click_quickaccess = "click_quickaccess"
        case click_good = "click_good"
        case more_persinfo = "more_persinfo"
        case more_shop = "more_shop"
        case more_topup = "more_topup"
        case more_setup = "more_setup"
        case more_help = "more_help"
        case more_head_suc = "more_head_suc"
        case more_bir_suc = "more_bir_suc"
        case more_pers_suc = "more_pers_suc"
        case more_exit_suc = "more_exit_suc"
        case more_chpass_click = "more_chpass_click"
        case more_chpass_suc = "more_chpass_suc"
        case more_email_click = "more_email_click"
        case more_email_suc = "more_email_suc"
        case more_moi_click = "more_moi_click"
        case more_moi_suc = "more_moi_suc"
        case topup_diamonds = "topup_diamonds"
        case topup_dia_no_login = "topup_dia_no_login"
        case topup_dia_cancel_pay = "topup_dia_cancel_pay"
        case topup_request_product_failed = "topup_request_product_failed"
        case topup_dia_suc = "topup_dia_suc"
        case topup_dia_consume_suc = "topup_dia_consume_suc"
        case topup_info = "topup_info"
        case click_Dress = "Click_Dress"
        case dress_Shop = "Dress_Shop"
        case me_Shop = "Me_Shop"
        case buy_Dress_Suc = "Buy_Dress_Suc"
        case buy_Dress_Failed = "Buy_Dress_Failed"
        case click_Cart = "Click_Cart"
        case click_Confirm_Payment = "Click_Confirm_Payment"
        case buy_success = "buy_success"
        case buy_failed = "buy_failed"
    }

    private static let eventLabelDict = ["enter_loginpage" : "进入登录页",
                                                            "click_login" : "登录页登录点击",
                                                            "third_facebook" : "第三方Facebook登录点击",
                                                            "third_facebook_suc" : "第三方Facebook登录成功",
                                                            "loginpage_reg" : "创建账户点击",
                                                            "regpage_login" : "我已有账户点击",
                                                            "account_login_suc" : "账号密码登录成功",
                                                            "login_failed" : "登录失败",
                                                            "reg_failed" : "注册失败",
                                                            "enter_useroage" : "进入用户信息编辑页",
                                                            "useroage_suc" : "用户信息编辑成功",
                                                            "useroage_failed" : "用户信息编辑失败",
                                                            "home_startapp" : "启动APP",
                                                            "home_view" : "进入首页",
                                                            "home_class" : "点击分类",
                                                            "home_reco" : "点击推荐",
                                                            "home_change" : "换一批",
                                                            "home_game" : "进入游戏详情",
                                                            "home_game_tab" : "点击导航游戏",
                                                            "home_dress_tab" : "点击导航装扮",
                                                            "home_chat_tab" : "点击导航聊天",
                                                            "home_more_tab" : "点击更多",
                                                            "home_recegames" : "最近游戏进入详情",
                                                            "home_frigames" : "好友在玩进入详情",
                                                            "home_recogames" : "推荐进入详情",
                                                            "home_classgames" : "分类进入详情",
                                                            "home_update" : "更新",
                                                            "home_cancel" : "取消更新",
                                                            "click_quickaccess" : "进入游戏",
                                                            "click_good" : "点赞",
                                                            "more_persinfo" : "点击个人信息",
                                                            "more_shop" : "点击商店",
                                                            "more_topup" : "点击充值",
                                                            "more_setup" : "点击设置",
                                                            "more_help" : "点击帮助",
                                                            "more_head_suc" : "上传头像成功",
                                                            "more_bir_suc" : "修改生日成功",
                                                            "more_pers_suc" : "修改个人简介成功",
                                                            "more_exit_suc" : "退出登录成功",
                                                            "more_chpass_click" : "点击“修改密码",
                                                            "more_chpass_suc" : "修改密码成功",
                                                            "more_email_click" : "点击”绑定邮箱“",
                                                            "more_email_suc" : "绑定邮箱成功",
                                                            "more_moi_click" : "点击绑定手机",
                                                            "more_moi_suc" : "绑定“手机成功“",
                                                            "topup_diamonds" : "点击充值钻石",
                                                            "topup_dia_no_login" : "点击充值钻石未登录",
                                                            "topup_dia_cancel_pay" : "你取消了购买",
                                                            "topup_dia_unknown_failed" : "充值未知错误",
                                                            "topup_request_product_failed" : "商品数据请求失败",
                                                            "topup_dia_suc" : "充值钻石成功",
                                                            "topup_dia_consume_suc" : "订单消耗成功",
                                                            "topup_info" : "查看充值记录",
                                                            "Click_Dress" : "点击装饰tab",
                                                            "Dress_Shop" : "从装饰界面进入商店",
                                                            "Me_Shop" : "从我界面进入商店",
                                                            "Buy_Dress_Suc" : "购买装饰成功",
                                                            "Buy_Dress_Failed" : "购买装饰失败",
                                                            "Click_Cart" : "点击购物车",
                                                            "Click_Confirm_Payment" : "点击确认支付",
                                                            "buy_success" : "购买商品成功",
                                                            "buy_failed" : "购买失败",
                                                            ]
    public static func start() {
        TalkingData.sessionStarted("F36C73916ACC4939BE27FE2C4F5E438C", withChannelId: "App Store")
        TalkingData.setSignalReportEnabled(true)
        TalkingData.setExceptionReportEnabled(true)
    }
    
    public static func trackEvent(_ event: String) {
        #if DEBUG
        #else
            TalkingData.trackEvent(event)
        #endif
    }
    
    public static func trackEvent(_ event: Event) {
        #if DEBUG
        #else
        TalkingData.trackEvent(event.rawValue, label: eventLabelDict[event.rawValue] ?? "")
        #endif
    }
    
    public static func trackEvent(_ event: Event, parameters: [String : String]) {
        #if DEBUG
        #else
            TalkingData.trackEvent(event.rawValue, label: eventLabelDict[event.rawValue] ?? "", parameters: parameters)
        #endif
    }
}


extension AnalysisManager {
    
    public static func analysisEnterGame(_ gameID: String) {
        
        let firstEnterGameTimeKey = "first_games_user_" + gameID
        guard let cacheDate = BlockyUserDefaults.date(forKey: firstEnterGameTimeKey) else {
            BlockyUserDefaults.storeDate(Date(), forKey: firstEnterGameTimeKey)
            AnalysisManager.trackEvent(firstEnterGameTimeKey)
            return
        }
        
        let nextEnterGameTimeKey = "next_games_user_" + gameID
        guard Date().isNextDay(from: cacheDate) && BlockyUserDefaults.date(forKey: nextEnterGameTimeKey) == nil else {
            return
        }
        BlockyUserDefaults.storeDate(Date(), forKey: nextEnterGameTimeKey)
        AnalysisManager.trackEvent(nextEnterGameTimeKey)
    }
}

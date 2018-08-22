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
        case enter_sandbox_page // 进入Sandbox页
        case resource_win_time // 弹出资源解压窗口
        case click_exit // 点击取消资源更新
        case click_ok // 点击OK同意资源更新
        case resource_success // 解压资源成功
        case enter_blockmango_page // 进入Blockmango进入游戏页
        case click_entergame // 点击EnterGame
        case enter_homepage // 进入游戏主页
        case click_play // 点击Play
        case click_all_tab // 点击All TAB
        case click_battle_tab // 点击Battle  TAB
        case click_fps_tab // 点击FPS TAB
        case click_adv_tab // 点击Adv TAB
        case click_game_detail_page // 点击游戏弹出游戏详情页
        case click_stargame // 点击开始按钮直接开始游戏
        case click_joingame // 点击Join进入游戏
        case click_like // 点击爱心点赞
        case stargame_success // 成功启动游戏
    }

    static func start() {
        TalkingData.sessionStarted("94FC268A15884348AB38611CE69766FE", withChannelId: "App Store")
        TalkingData.setSignalReportEnabled(true)
        TalkingData.setExceptionReportEnabled(true)
    }
    
    static func trackEvent(_ event: Event) {
        #if DEBUG
        #else
            TalkingData.trackEvent(event.rawValue)
        #endif
    }
    
    static func trackEvent(_ event: Event, parameters: [String : String]) {
        #if DEBUG
        #else
            TalkingData.trackEvent(event.rawValue, label: "", parameters: parameters)
        #endif
    }
}


extension AnalysisService {
    
//    public static func analysisEnterGame(_ gameID: String) {
//        
//        let firstEnterGameTimeKey = "first_games_user_" + gameID
//        guard let cacheDate = BlockyUserDefaults.date(forKey: firstEnterGameTimeKey) else {
//            BlockyUserDefaults.storeDate(Date(), forKey: firstEnterGameTimeKey)
//            AnalysisManager.trackEvent(firstEnterGameTimeKey)
//            return
//        }
//        
//        let nextEnterGameTimeKey = "next_games_user_" + gameID
//        guard Date().isNextDay(from: cacheDate) && BlockyUserDefaults.date(forKey: nextEnterGameTimeKey) == nil else {
//            return
//        }
//        BlockyUserDefaults.storeDate(Date(), forKey: nextEnterGameTimeKey)
//        AnalysisManager.trackEvent(nextEnterGameTimeKey)
//    }
}

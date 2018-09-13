//
//  InitializeProfleModuleManager.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/9/13.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

struct InitializeProfleModuleManager {
    private var firstNames: [String] = []
    private var secondNames: [String] = []
    
    init() {
        do {
            let firstNamesData = try Data.init(contentsOf: Bundle.main.url(forResource: "rdm_first_name", withExtension: ".txt")!)
            let secondNamesData = try Data.init(contentsOf: Bundle.main.url(forResource: "rdm_second_name", withExtension: ".txt")!)
            let firstNamesString = String.init(data: firstNamesData, encoding: String.Encoding.utf8)
            firstNames = firstNamesString?.components(separatedBy: "\n") ?? []
            let secondNamesString = String.init(data: secondNamesData, encoding: String.Encoding.utf8)
            secondNames = secondNamesString?.components(separatedBy: "\n") ?? []
        }catch {
        }
    }
    
    func fetchRandomName() -> String {
        let firstRandomIndex = Int(arc4random_uniform(UInt32(firstNames.count)))
        let secondRandomIndex = Int(arc4random_uniform(UInt32(secondNames.count)))
        var randomName = firstNames[firstRandomIndex] + "_" + secondNames[secondRandomIndex]
        if randomName.count > 16 {
            randomName = (randomName as NSString).substring(to: 14)
            randomName += randomLetters(length: 2)
        }
        return randomName
    }
    
    private func randomLetters(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyz"
        let len = UInt32(letters.length)
        var randomLetters = ""
        for _ in 0 ..< length {
            let rand = Int(arc4random_uniform(len))
            var nextChar = letters.character(at: rand)
            randomLetters += NSString(characters: &nextChar, length: 1) as String
        }
        return randomLetters
    }
}

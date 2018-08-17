//
//  CopyFileTool.swift
//  BlockmanGo
//
//  Created by KiBen on 2018/7/18.
//  Copyright © 2018年 SanboxOL. All rights reserved.
//

import Foundation

protocol CopyFileToolDelegate: class {
    func copyFileInProgress(_ progress: Float, totalSize: UInt64)
    func copyFileDidFinished()
}

class CopyFileTool: NSObject, FileManagerDelegate {
    weak var delegate: CopyFileToolDelegate?
    
    private var timer: Timer?
    private var sourcePath: String?
    private var targetPath: String?
    private let fileManager = FileManager.default
    private var totalSize: UInt64 = 0
    
    override init() {
        super.init()
        
        fileManager.delegate = self
    }
    
    func copyFile(atPath: String, toPath: String) {
        guard fileManager.fileExists(atPath: atPath) else {
            print("\(atPath) 文件不存在！请检查路径")
            return
        }
        sourcePath = atPath;
        targetPath = toPath;
        prepareForCopy()
    }
    
    func copyFiles(atDirectory: String, toDirectory: String) {
        var isDirectory: ObjCBool = true
        guard fileManager.fileExists(atPath: atDirectory, isDirectory: &isDirectory), isDirectory.boolValue else {
            print("\(atDirectory) 该路径不存在 !")
            return
        }
        sourcePath = atDirectory;
        targetPath = toDirectory;
        prepareForCopy()
    }
    
    private func prepareForCopy() {
        if timer != nil {
            destroyTimer()
        }
        
        var isDirectory: ObjCBool = true
        fileManager.fileExists(atPath: sourcePath!, isDirectory: &isDirectory)
        timer = Timer.scheduledTimer(timeInterval: 0.100, target: self, selector: #selector(checkFileSize(timer:)), userInfo: isDirectory.boolValue, repeats: true)
        perform(#selector(startCopy), with: nil, afterDelay: 0.5)
    }
    
    @objc private func checkFileSize(timer: Timer) {
        DispatchQueue.main.async {
            guard let isDirectory = timer.userInfo as? Bool else {return}
            
            var originFileSize: UInt64 = 0
            var copyingFileSize: UInt64 = 0
            if isDirectory {
                originFileSize = BMFileManager.calculateFolderSize(directoryPath: self.sourcePath!)
                copyingFileSize = BMFileManager.calculateFolderSize(directoryPath: self.targetPath!)
            }else {
                originFileSize = BMFileManager.calculateFileSize(filePath: self.sourcePath!)
                copyingFileSize = BMFileManager.calculateFileSize(filePath: self.targetPath!)
            }
            self.totalSize = originFileSize
            let progress = Float(copyingFileSize) / Float(originFileSize)
            self.delegate?.copyFileInProgress(progress, totalSize: originFileSize)
        }
    }
    
    @objc private func startCopy() {
        DispatchQueue.global().async {
            guard self.timer != nil else {return}
            guard self.fileManager.fileExists(atPath: self.sourcePath!) else { return }
            try! self.fileManager.copyItem(atPath: self.sourcePath!, toPath: self.targetPath!)
            self.destroyTimer()
            DispatchQueue.main.async {
                self.delegate?.copyFileInProgress(1.0, totalSize: self.totalSize)
                self.delegate?.copyFileDidFinished()
            }
        }
    }
    
    private func destroyTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func fileManager(_ fileManager: FileManager, shouldProceedAfterError error: Error, copyingItemAtPath srcPath: String, toPath dstPath: String) -> Bool {
        if (error as NSError).code == 516 {
            do {
                var isdirectory: ObjCBool = false
                let _ = fileManager.fileExists(atPath: dstPath, isDirectory: &isdirectory)
                let srcURL = URL(fileURLWithPath: srcPath, isDirectory: isdirectory.boolValue)
                let dstURL = URL(fileURLWithPath: dstPath, isDirectory: isdirectory.boolValue)
                let _ = try fileManager.replaceItemAt(dstURL, withItemAt: srcURL)
            }catch { }
            return true
        }
        return false
    }
}


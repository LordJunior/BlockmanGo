//
//  BMDecorationViewController.h
//  BlockModsGameKit
//
//  Created by KiBen on 2018/1/2.
//  Copyright © 2018年 SandboxOL. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface BMDecorationViewController : GLKViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@property(nonatomic, copy) void (^generateFinished)(BMDecorationViewController *decorationController);

/// 暂停渲染
- (void)suspend;

/// 恢复渲染
- (void)resume;

/// 1: 男 2: 女
- (void)changeGender:(int)gender;

/// 使用某种装饰
- (void)useDecorationWithResourceID:(NSString *)resourceID;

/// 卸下某种装饰
- (void)unuseDecorationWithResourceID:(NSString *)resourceID;

/// 使用某种肤色
- (void)useSkinWithResourceID:(NSString *)resourceID;

/// 卸下某种肤色
- (void)unuseSkinWithResourceID:(NSString *)resourceID;
@end

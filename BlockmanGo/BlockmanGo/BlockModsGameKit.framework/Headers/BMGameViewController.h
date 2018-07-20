//
//  BMGameViewController.h
//  BlockModsGameKit
//
//  Created by KiBen on 2017/12/4.
//  Copyright © 2017年 SandboxOL. All rights reserved.
//

#import <GLKit/GLKit.h>

@class BMGameViewController;

@protocol BMGameViewControllerDelegate <NSObject>
@optional
- (void)gameViewControllerdidDismissed:(BMGameViewController *)controller autoStartNextGame:(BOOL)isAutoStart;
- (void)gameViewController:(BMGameViewController *)controller userDidIn:(unsigned long long)userID;
- (void)gameViewController:(BMGameViewController *)controller didAgreeFriendRequest:(unsigned long long)userID;
- (void)gameViewController:(BMGameViewController *)controller didRequestAddFriend:(unsigned long long)userID;
@end

typedef NS_ENUM(NSUInteger, FriendOperationResult) {
    FriendOperationResultNoFriend = 1,
    FriendOperationResultIsFriend = 2,
    FriendOperationResultAgreeAddFriend = 3,
    FriendOperationResultRequestAddFriend = 4,
    FriendOperationResultAgreeAddFriendFailed = 10000,
    FriendOperationResultRequestAddFriendFailed = 10001
};

@interface BMGameViewController : GLKViewController

@property (nonatomic, copy) NSNumber *userID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSString *gameAddr;
@property (nonatomic, copy) NSString *gameType;
@property (nonatomic, copy) NSNumber *gameTimestamp;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *mapName;
@property (nonatomic, copy) NSString *mapUrl;

@property (nonatomic, weak) id<BMGameViewControllerDelegate> bmDelegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)resolvedFriendOperationInResult:(FriendOperationResult)result withUserID:(unsigned long long)userID;
@end



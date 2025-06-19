//
//  YCYShareContactListView.h
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import <UIKit/UIKit.h>
#import "YCTChatFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTShareContactListView : UIView

@property (nonatomic, copy) NSArray<YCTChatFriendModel *> *models;
@property (nonatomic, copy, readonly) NSArray<NSString *> *selectedUserIds;
@property (nonatomic, copy) void (^selectedIndexPathsChangeBlock)(NSArray<NSIndexPath *> * _Nullable selectedIndexPaths);

@end

NS_ASSUME_NONNULL_END

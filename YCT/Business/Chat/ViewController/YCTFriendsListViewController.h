//
//  YCTFriendsListViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/22.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTFriendsListViewController : UIViewController<JXCategoryListContentViewDelegate>

@property UITableView *tableView;

@end

NS_ASSUME_NONNULL_END

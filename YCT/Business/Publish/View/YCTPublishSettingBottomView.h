//
//  YCTPublishSettingBottomView.h
//  YCT
//
//  Created by hua-cloud on 2022/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^publishVisibleSettingSelected)(NSString * _Nullable title, NSInteger index);
typedef void(^publishAdvanceSettingSelected)(bool save, bool canShare, bool landscape);

@interface YCTPublishSettingBottomView : UIView

+ (id)visibleSettingViewWithDefaultIndex:(NSInteger)index
                         selectedHandler:(publishVisibleSettingSelected)handler;

+ (id)advanceSettingViewWithSave:(BOOL)save canshare:(BOOL)canshare landscape:(BOOL)landscape selectedHandler:(publishAdvanceSettingSelected)handler;


+ (id)settingViewWithDefaultIndex:(NSInteger)index
                            title:(NSString *)title
                           titles:(NSArray *)titles
                        subtitles:(NSArray *)subtitles
                  selectedHandler:(publishVisibleSettingSelected)handler;
+ (id)settingViewIconWithDefaultIndex:(NSInteger)index
                            title:(NSString *)title
                           titles:(NSArray *)titles
                           icons:(NSArray *)icons
                        subtitles:(NSArray *)subtitles
                  selectedHandler:(publishVisibleSettingSelected)handler;

@end

NS_ASSUME_NONNULL_END

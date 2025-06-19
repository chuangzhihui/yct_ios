//
//  YCTPostTagsView.h
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import <UIKit/UIKit.h>
#import "YCTTagsView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YCTPostAddTagsViewDelegate <NSObject>

- (void)didSelectTags:(NSArray *)tags;
- (void)didTagViewUpdateHeight:(CGFloat)newHeight;

@end

@interface YCTPostAddTagsView : UIView

@property (assign, nonatomic) NSUInteger limitCount;

@property (weak, nonatomic) id<YCTPostAddTagsViewDelegate> delegate;

- (void)setSystemTags:(NSArray<NSString *> *)systemsTags
         selectedTags:(NSArray * _Nullable)selectedTags;

- (NSArray<NSString *> *)systemTags;
- (NSArray<NSString *> *)customTags;

@end

NS_ASSUME_NONNULL_END

//
//  YCTTagsView.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import <UIKit/UIKit.h>
#import "YCTTagAttributeConfiguration.h"

@class YCTTagsView;

@protocol YCTTagsViewDelegate <NSObject>
@optional
- (BOOL)tagsView:(YCTTagsView *)tagsView shouldSelectIndexPath:(NSIndexPath *)indexPath;
- (void)tagsView:(YCTTagsView *)tagsView didSelectTags:(NSArray *)tags;
- (void)tagsViewDidAddNewTag:(YCTTagsView *)tagsView;
- (void)tagsViewDidRemoveTag:(YCTTagsView *)tagsView;
@end

@interface YCTTagsView : UIView

@property (copy, nonatomic) NSArray *tags;

@property (weak, nonatomic) id<YCTTagsViewDelegate> delegate;

@property (strong, nonatomic, readonly) YCTTagAttributeConfiguration *tagAttributeConfiguration;

@property (assign, nonatomic) BOOL isMultiSelect;

- (void)updateSelectedTags:(NSArray *)seletedTags;
- (NSArray<NSString *> *)selectedTags;

- (void)reloadData;

- (void)setCanScroll:(BOOL)canScroll;

+ (CGFloat)getHeightWithTags:(NSArray *)tags
                tagAttribute:(YCTTagAttributeConfiguration *)tagAttribute
                       width:(CGFloat)width;

@end

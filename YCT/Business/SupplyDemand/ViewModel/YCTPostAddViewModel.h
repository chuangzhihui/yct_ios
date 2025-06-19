//
//  YCTPostAddViewModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/27.
//

#import "YCTBaseViewModel.h"
#import "YCTGXTag.h"
#import "YCTImageModelUtil.h"
#import "YCTMyGXListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPostAddViewModel : YCTBaseViewModel

- (instancetype)initWithType:(YCTPostType)type;
- (instancetype)initWithModel:(YCTMyGXListModel *)model;

- (void)requestTags;
- (void)submitPost;

@property (nonatomic, strong) YCTImageModelUtil *imageModelUtil;
@property (nonatomic, strong, readonly) RACSubject *loadTagsSubject;
@property (nonatomic, copy, readonly) NSArray<YCTGXTag *> *tags;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSArray *tagTexts;
@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *goodstype;

@end

NS_ASSUME_NONNULL_END

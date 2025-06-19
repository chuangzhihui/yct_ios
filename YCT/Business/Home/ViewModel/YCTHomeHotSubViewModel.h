//
//  YCTHomeHotSubViewModel.h
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import <Foundation/Foundation.h>
#import "YCTApiGetHotList.h"
#import "YCTApiGetHotTopTag.h"
#import "YCTApiGetHotCompanyList.h"
#import "NSString+Common.h"
#import "YCTSearchUserModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YCTHotTagType) {
    YCTHotTagTypeHot,
    YCTHotTagTypeCo
};
@interface YCTHomeHotListItemViewModel : NSObject

@property (nonatomic, strong, readonly) UIImage * rankImage;
@property (nonatomic, strong, readonly) UIImage * titleIconImage;
@property (nonatomic, copy, readonly) NSString * rankNum;
@property (nonatomic, copy, readonly) NSString * title;
@property (nonatomic, copy, readonly) NSString * hotNum;
@property (nonatomic, copy, readonly) NSString * avatar;
@property (nonatomic, copy)NSString * userId;
@property (nonatomic, assign) bool isCo;

@property (nonatomic, strong) YCTTagsModel * hotModel;
@property (nonatomic, strong) YCTSearchUserModel * coModel;
@end

@interface YCTHomeHotSubViewModel : NSObject
@property (nonatomic, copy, readonly) NSArray<YCTHomeHotListItemViewModel *> * cellViewModels;

- (instancetype)initWithType:(YCTHotTagType)type;
@end

NS_ASSUME_NONNULL_END

//
//  YCTBgmMusicModel.h
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBgmMusicModel : YCTBaseModel

@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , assign) NSInteger              atime;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * url;

@end

NS_ASSUME_NONNULL_END

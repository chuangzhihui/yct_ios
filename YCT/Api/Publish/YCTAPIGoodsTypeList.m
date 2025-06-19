//
//  YCTAPIGoodsTypeList.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/28.
//

#import "YCTAPIGoodsTypeList.h"
#import "YCTSearchCateModel.h"
@implementation YCTAPIGoodsTypeList{
    NSInteger _id;
}
-(instancetype)initWithTypeId:(NSInteger)typeId{
    self=[super init];
    if(self){
        _id=typeId;
    }
    return self;
}

- (NSString *)requestUrl {
   return @"/index/home/getGoodsTypeList";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
   return @{
       @"id": @(_id),
   };
}
@end

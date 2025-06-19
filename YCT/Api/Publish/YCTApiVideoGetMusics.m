//
//  YCTApiVideoGetMusics.m
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "YCTApiVideoGetMusics.h"

@implementation YCTApiVideoGetMusics{
    NSInteger _page;
    NSInteger _size;
    NSString *_text;
    
    NSInteger _type;
}

- (instancetype)initWithPage:(NSInteger)page {
   self = [super init];
   if (self) {
       _page = page;
       _size = 20;
   }
   return self;
}

- (instancetype)initWithAddBgmAi:(NSInteger)type text:(NSString *)text {
   self = [super init];
   if (self) {
       _type = type;
       _text = text;
   }
   return self;
}
//- (NSString *)baseUrl {
//    return @"";
//}

- (NSString *)requestUrl {
    if (_type == 1) {
        return @"/index/user/addMusic";
    }
    return @"/index/video/getMusics";
}

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}

- (Class)dataModelClass {
    if (_type == 1) {
        return nil;
    }
   return YCTBgmMusicModel.class;
}

- (NSDictionary *)yct_requestArgument {
    if (_type == 1) {
        return @{
            @"text": _text,
         };
    }
    return @{
       @"page": @(_page),
       @"size": @(_size),
    };
}

@end
